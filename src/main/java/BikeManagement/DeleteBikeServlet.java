package BikeManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/DeleteBikeServlet")
public class DeleteBikeServlet extends HttpServlet {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get and decode the bike name
        String encodedBikeName = request.getParameter("bikeName");
        if (encodedBikeName == null || encodedBikeName.isEmpty()) {
            request.setAttribute("errorMessage", "Bike name is missing.");
            request.getRequestDispatcher("/Bikes.jsp").forward(request, response);
            return;
        }

        // Decode the bike name
        String bikeName = URLDecoder.decode(encodedBikeName, "UTF-8");

        // Get the path to Bikes.txt
        String bikesFilePath = BIKES_FILE_PATH;
        List<String> updatedLines = new ArrayList<>();
        boolean bikeFound = false;

        // Read and filter Bikes.txt
        try {
            File file = new File(bikesFilePath);
            if (!file.exists()) {
                System.err.println("DeleteBikeServlet: Bikes.txt not found at: " + bikesFilePath);
                request.setAttribute("errorMessage", "Bikes.txt file not found.");
                request.getRequestDispatcher("/Bikes.jsp").forward(request, response);
                return;
            }

            List<String> lines = Files.readAllLines(Paths.get(bikesFilePath));
            for (String line : lines) {
                if (line.trim().isEmpty()) continue; // Skip empty lines
                String[] parts = line.trim().split("\\s*\\|\\s*");
                if (parts.length == 6) {
                    if (parts[0].equals(bikeName)) {
                        bikeFound = true; // Mark that we found the bike
                    } else {
                        updatedLines.add(line); // Keep lines that don't match
                    }
                } else {
                    System.err.println("DeleteBikeServlet: Skipping malformed line: " + line);
                }
            }

            if (!bikeFound) {
                System.out.println("DeleteBikeServlet: Bike not found: " + bikeName);
                request.setAttribute("errorMessage", "Bike '" + bikeName + "' not found.");
                request.getRequestDispatcher("/Bikes.jsp").forward(request, response);
                return;
            }

            // Write the updated contents back to Bikes.txt
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(bikesFilePath))) {
                for (String line : updatedLines) {
                    writer.write(line);
                    writer.newLine();
                }
            }
            System.out.println("DeleteBikeServlet: Successfully deleted bike: " + bikeName);

        } catch (IOException e) {
            System.err.println("DeleteBikeServlet: Failed to delete bike: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to delete bike: " + e.getMessage());
            request.getRequestDispatcher("/Bikes.jsp").forward(request, response);
            return;
        }

        // Set success message in session for display after redirect
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", "Bike '" + bikeName + "' deleted successfully.");

        // Redirect to BikeListServlet to refresh the bike list
        response.sendRedirect("BikeListServlet");
    }
}