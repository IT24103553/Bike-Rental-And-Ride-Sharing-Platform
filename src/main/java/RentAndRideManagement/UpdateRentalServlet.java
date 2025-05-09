package RentAndRideManagement;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UpdateRentalServlet")
public class UpdateRentalServlet extends HttpServlet {
    private static final String RENTAL_REQUESTS_FILE = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/RentalRequests.txt";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String bikeName = request.getParameter("bikeName");
        String rentalDays = request.getParameter("rentalDays");
        String[] additionalServices = request.getParameterValues("additionalServices");
        String currentTotalPayment = request.getParameter("currentTotalPayment");
        String updatedTotalPayment = request.getParameter("updatedTotalPayment");
        String orderNumber = request.getParameter("orderNumber");

        System.out.println("UpdateRentalServlet: Processing update - bikeName: " + bikeName + ", username: " + username +
                ", orderNumber: " + orderNumber + ", rentalDays: " + rentalDays + ", updatedTotalPayment: " + updatedTotalPayment +
                ", additionalServices: " + (additionalServices != null ? String.join(",", additionalServices) : "none"));

        // Verify file exists and is writable
        File file = new File(RENTAL_REQUESTS_FILE);
        if (!file.exists()) {
            System.out.println("UpdateRentalServlet: File does not exist: " + RENTAL_REQUESTS_FILE);
            throw new ServletException("RentalRequests.txt does not exist at: " + RENTAL_REQUESTS_FILE);
        }
        if (!file.canWrite()) {
            System.out.println("UpdateRentalServlet: File is not writable: " + RENTAL_REQUESTS_FILE);
            throw new ServletException("Cannot write to RentalRequests.txt at: " + RENTAL_REQUESTS_FILE);
        }
        System.out.println("UpdateRentalServlet: File exists and is writable: " + RENTAL_REQUESTS_FILE);

        // Read and update RentalRequests.txt
        List<String> lines = null;
        try {
            lines = Files.readAllLines(Paths.get(RENTAL_REQUESTS_FILE));
            System.out.println("UpdateRentalServlet: Total lines read: " + lines.size());
            boolean updated = false;
            for (int i = 0; i < lines.size(); i++) {
                String line = lines.get(i);
                if (line.trim().isEmpty()) {
                    System.out.println("UpdateRentalServlet: Skipping empty line at index " + i);
                    continue;
                }
                String[] data = line.split("\\s*\\|\\s*");
                System.out.println("UpdateRentalServlet: Checking line " + i + ": " + line + ", data length: " + data.length);
                if (data.length == 5) {
                    System.out.println("UpdateRentalServlet: Line " + i + " - BikeName: " + data[0] +
                            ", Username: " + data[1] + ", OrderNumber: " + data[2]);
                    if (data[0].trim().equalsIgnoreCase(bikeName) &&
                            data[1].trim().equalsIgnoreCase(username) &&
                            data[2].trim().equals(orderNumber)) {
                        System.out.println("UpdateRentalServlet: Match found at line " + i);
                        String newLine = data[0] + " | " + data[1] + " | " + data[2] + " | " + rentalDays +
                                " | " + (additionalServices != null ? String.join(",", additionalServices) : "");
                        lines.set(i, newLine);
                        System.out.println("UpdateRentalServlet: Updated line to: " + newLine);
                        updated = true;
                        break;
                    }
                } else {
                    System.out.println("UpdateRentalServlet: Invalid format at line " + i + ", expected 5 fields, got: " + data.length);
                }
            }
            if (!updated) {
                System.out.println("UpdateRentalServlet: No matching record found for bikeName: " + bikeName +
                        ", username: " + username + ", orderNumber: " + orderNumber);
            } else {
                // Write back to file
                try {
                    Files.write(Paths.get(RENTAL_REQUESTS_FILE), lines);
                    System.out.println("UpdateRentalServlet: File write successful for " + RENTAL_REQUESTS_FILE);
                } catch (IOException e) {
                    System.out.println("UpdateRentalServlet: Write failed: " + e.getMessage());
                    throw new ServletException("Failed to write to RentalRequests.txt", e);
                }
            }
        } catch (IOException e) {
            System.out.println("UpdateRentalServlet: Error reading RentalRequests.txt: " + e.getMessage());
            throw new ServletException("Failed to read RentalRequests.txt", e);
        }

        // Forward to UpdatePayment.jsp with parameters
        request.setAttribute("bikeName", bikeName);
        request.setAttribute("currentTotalPayment", currentTotalPayment);
        request.setAttribute("updatedTotalPayment", updatedTotalPayment);
        request.getRequestDispatcher("/UpdatePayment.jsp").forward(request, response);
    }
}