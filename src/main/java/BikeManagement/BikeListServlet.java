package BikeManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BikeListServlet")
public class BikeListServlet extends HttpServlet {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String[]> bikeDataList = new ArrayList<>();

        // Read the bike data from the file
        File bikesFile = new File(BIKES_FILE_PATH);
        if (bikesFile.exists()) {
            try {
                List<String> lines = Files.readAllLines(Paths.get(BIKES_FILE_PATH));
                System.out.println("BikeListServlet: Contents of Bikes.txt when reading: " + lines);
                for (String line : lines) {
                    if (line.trim().isEmpty()) {
                        System.out.println("BikeListServlet: Skipping empty line");
                        continue; // Skip empty lines
                    }
                    // Split on | with optional spaces around it
                    String[] bikeData = line.trim().split("\\s*\\|\\s*");
                    if (bikeData.length == 6) { // Expect 6 fields
                        bikeDataList.add(bikeData);
                        System.out.println("BikeListServlet: Successfully parsed bike data: " + String.join("|", bikeData));
                    } else {
                        System.err.println("BikeListServlet: Invalid bike data format: " + line + " (Found " + bikeData.length + " fields, expected 6)");
                    }
                }
                System.out.println("BikeListServlet: Read " + bikeDataList.size() + " bikes from " + BIKES_FILE_PATH);
            } catch (IOException e) {
                System.err.println("BikeListServlet: Failed to read " + BIKES_FILE_PATH + ": " + e.getMessage());
                request.setAttribute("errorMessage", "Failed to load bikes: " + e.getMessage());
            }
        } else {
            System.out.println("BikeListServlet: Bikes.txt does not exist at: " + BIKES_FILE_PATH);
            request.setAttribute("errorMessage", "Bikes.txt file not found.");
        }

        // Set the bike data as a request attribute
        request.setAttribute("bikeDataList", bikeDataList);
        System.out.println("BikeListServlet: Forwarding to Bikes.jsp with " + bikeDataList.size() + " bikes");

        // Forward to Bikes.jsp
        request.getRequestDispatcher("/Bikes.jsp").forward(request, response);
    }
}