package BikeManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.List;

@WebServlet("/AddBikeServlet")
@MultipartConfig
public class AddBikeServlet extends HttpServlet {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String bikeName = request.getParameter("bikeName");
        String bikePrice = request.getParameter("bikePrice");
        String ownerName = request.getParameter("ownerName");
        String availability = request.getParameter("availability");

        // Get the username of the logged-in user from the session
        HttpSession session = request.getSession();
        String ownerUsername = (String) session.getAttribute("username");
        if (ownerUsername == null) {
            request.setAttribute("errorMessage", "You must be logged in to add a bike.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        // Handle file upload (bike photo)
        Part filePart = request.getPart("bikePhoto");
        String fileName = filePart.getSubmittedFileName();
        String uploadPath = getServletContext().getRealPath("") + File.separator + "image";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);

        // Create the file if it doesn't exist
        File bikesFile = new File(BIKES_FILE_PATH);
        if (!bikesFile.exists()) {
            bikesFile.getParentFile().mkdirs();
            bikesFile.createNewFile();
            System.out.println("AddBikeServlet: Created Bikes.txt at: " + BIKES_FILE_PATH);
        }

        // Format the new bike data, including the ownerUsername
        String bikeData = String.format("%s|%s|%s|%s|%s|%s%n", bikeName, fileName, bikePrice, ownerName, availability, ownerUsername);
        System.out.println("AddBikeServlet: Attempting to write bike data: " + bikeData);

        // Append the new bike data to Bikes.txt with SYNC option
        try {
            Files.write(Paths.get(BIKES_FILE_PATH), bikeData.getBytes(), StandardOpenOption.APPEND, StandardOpenOption.SYNC);
            System.out.println("AddBikeServlet: Successfully wrote bike data to " + BIKES_FILE_PATH + ": " + bikeData);

            // Read back the file to confirm the data was written
            List<String> lines = Files.readAllLines(Paths.get(BIKES_FILE_PATH));
            System.out.println("AddBikeServlet: Contents of Bikes.txt after writing: " + lines);
        } catch (IOException e) {
            System.err.println("AddBikeServlet: Failed to write to " + BIKES_FILE_PATH + ": " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to add bike: " + e.getMessage());
            request.getRequestDispatcher("Bikes.jsp").forward(request, response);
            return;
        }

        // Redirect back to BikeListServlet to refresh the bike list
        System.out.println("AddBikeServlet: Redirecting to BikeListServlet");
        response.sendRedirect("BikeListServlet");
    }
}