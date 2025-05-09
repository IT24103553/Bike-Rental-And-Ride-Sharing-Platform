package BikeManagement;

import RentAndRideManagement.RentalRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/BikeDetailsServlet")
public class BikeDetailsServlet extends HttpServlet {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";
    private static final String REQUESTS_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/RentalRequests.txt";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bikeName = request.getParameter("bikeName");
        if (bikeName == null || bikeName.isEmpty()) {
            request.setAttribute("errorMessage", "Bike name is required.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // Decode the bikeName to handle URL-encoded characters
        bikeName = URLDecoder.decode(bikeName, StandardCharsets.UTF_8.toString());

        // Fetch bike details
        String[] bikeData = null;
        try {
            List<String> bikeLines = Files.readAllLines(Paths.get(BIKES_FILE_PATH));
            for (String line : bikeLines) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.trim().split("\\s*\\|\\s*");
                if (parts.length == 6 && parts[0].equals(bikeName)) {
                    bikeData = parts;
                    break;
                }
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Failed to load bike details: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        if (bikeData == null) {
            request.setAttribute("errorMessage", "Bike not found.");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        // Fetch rental requests
        List<RentalRequest> rentalRequests = new ArrayList<>();
        boolean isRented = false;
        boolean isRentedByCurrentUser = false;
        String renterUsername = null;
        long rentalStartTime = 0;
        long rentalDurationDays = 0;
        long rentalEndTime = 0;
        String rentalDaysStr = "0";
        String username = (String) request.getSession().getAttribute("username");

        List<String> requestLines = new ArrayList<>();
        try {
            File file = new File(REQUESTS_FILE_PATH);
            if (file.exists()) {
                requestLines = Files.readAllLines(Paths.get(REQUESTS_FILE_PATH));
                for (String line : requestLines) {
                    if (line.trim().isEmpty()) continue;
                    String[] parts = line.trim().split("\\s*\\|\\s*");
                    if (parts.length >= 9 && parts[1].equals(bikeName)) {
                        RentalRequest rentalRequest = new RentalRequest(
                                parts[0], // requestId
                                parts[1], // bikeId
                                parts[2], // renterUsername
                                parts[4], // email (adjusting from original totalPayment)
                                parts[6], // status
                                parts[8], // rentalDays (adjusting from original rentalDays)
                                parts[3], // totalPayment (adjusting from original totalPayment)
                                parts[5].isEmpty() ? "None" : parts[5], // additionalServices (from additionalNote)
                                "N/A" // fileName (default value since not in RentalRequests.txt)
                        );
                        rentalRequests.add(rentalRequest);

                        // Check for active rental
                        if (parts[6].equals("Accepted")) {
                            isRented = true;
                            renterUsername = parts[2];
                            rentalStartTime = Long.parseLong(parts[7]);
                            rentalDaysStr = parts[8];
                            rentalDurationDays = Long.parseLong(rentalDaysStr);
                            long rentalDurationMillis = rentalDurationDays * 24 * 60 * 60 * 1000;
                            rentalEndTime = rentalStartTime + rentalDurationMillis;
                            if (username != null && username.equals(renterUsername)) {
                                isRentedByCurrentUser = true;
                            }
                            // If rental period has expired, update status to "Completed" and make bike available
                            if (System.currentTimeMillis() > rentalEndTime) {
                                isRented = false;
                                isRentedByCurrentUser = false;
                                // Update the line in requestLines
                                for (int i = 0; i < requestLines.size(); i++) {
                                    String lineToCheck = requestLines.get(i);
                                    if (lineToCheck.trim().isEmpty()) continue;
                                    String[] lineParts = lineToCheck.trim().split("\\s*\\|\\s*");
                                    if (lineParts.length >= 9 && lineParts[0].equals(parts[0])) {
                                        requestLines.set(i, String.format("%s | %s | %s | %s | %s | %s | Completed | %s | %s",
                                                lineParts[0], lineParts[1], lineParts[2], lineParts[3], lineParts[4], lineParts[5], lineParts[7], lineParts[8]));
                                        break;
                                    }
                                }
                                // Update bike availability
                                List<String> bikeLines = Files.readAllLines(Paths.get(BIKES_FILE_PATH));
                                for (int i = 0; i < bikeLines.size(); i++) {
                                    String bikeLine = bikeLines.get(i);
                                    if (bikeLine.trim().isEmpty()) continue;
                                    String[] bikeParts = bikeLine.trim().split("\\s*\\|\\s*");
                                    if (bikeParts.length == 6 && bikeParts[0].equals(bikeName)) {
                                        bikeLines.set(i, String.format("%s | %s | %s | %s | Available | %s",
                                                bikeParts[0], bikeParts[1], bikeParts[2], bikeParts[3], bikeParts[5]));
                                        bikeData[4] = "Available"; // Update bikeData for display
                                        break;
                                    }
                                }
                                try (BufferedWriter writer = new BufferedWriter(new FileWriter(BIKES_FILE_PATH))) {
                                    for (String bikeLine : bikeLines) {
                                        if (!bikeLine.trim().isEmpty()) {
                                            writer.write(bikeLine);
                                            writer.newLine();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } catch (IOException e) {
            request.setAttribute("errorMessage", "Failed to load rental requests: " + e.getMessage());
            request.getRequestDispatcher("/BikeDetails.jsp").forward(request, response);
            return;
        }

        // Write updated rental requests back to file if status changed
        if (!isRented) {
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(REQUESTS_FILE_PATH))) {
                for (String line : requestLines) {
                    if (!line.trim().isEmpty()) {
                        writer.write(line);
                        writer.newLine();
                    }
                }
            } catch (IOException e) {
                request.setAttribute("errorMessage", "Failed to update rental requests: " + e.getMessage());
                request.getRequestDispatcher("/BikeDetails.jsp").forward(request, response);
                return;
            }
        }

        // Set attributes for JSP
        request.setAttribute("bikeData", bikeData);
        request.setAttribute("rentalRequests", rentalRequests);
        request.setAttribute("isRented", isRented);
        request.setAttribute("isRentedByCurrentUser", isRentedByCurrentUser);
        request.setAttribute("renterUsername", renterUsername);
        request.setAttribute("rentalEndTime", rentalEndTime);
        request.setAttribute("rentalDays", rentalDaysStr);

        request.getRequestDispatcher("/BikeDetails.jsp").forward(request, response);
    }
}