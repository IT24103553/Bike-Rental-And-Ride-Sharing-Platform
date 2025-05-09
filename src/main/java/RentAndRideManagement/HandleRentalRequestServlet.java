package RentAndRideManagement;

import BikeManagement.BikeAvailabilityManager;
import BikeManagement.BikeAvailabilityManagerImpl;

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
import java.util.logging.Logger;

@WebServlet("/HandleRentalRequestServlet")
public class HandleRentalRequestServlet extends HttpServlet {
    private static final String PAYMENT_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Payment.txt";
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";
    private final BikeAvailabilityManager bikeAvailabilityManager;
    private static final Logger LOGGER = Logger.getLogger(HandleRentalRequestServlet.class.getName());

    public HandleRentalRequestServlet() {
        this.bikeAvailabilityManager = new BikeAvailabilityManagerImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        LOGGER.info("Processing request in HandleRentalRequestServlet");

        String requestId = request.getParameter("requestId");
        String action = request.getParameter("action");
        String bikeName = request.getParameter("bikeName");
        String rentalDays = request.getParameter("rentalDays"); // Added to get rentalDays directly from form

        if (requestId == null || action == null || bikeName == null || rentalDays == null) {
            LOGGER.warning("Missing required parameters: requestId=" + requestId + ", action=" + action + ", bikeName=" + bikeName + ", rentalDays=" + rentalDays);
            request.setAttribute("errorMessage", "Missing required parameters.");
            request.getRequestDispatcher("BikeRequests.jsp").forward(request, response);
            return;
        }

        // Read Payment.txt to find the request
        List<String> paymentLines = new ArrayList<>();
        String renterUsername = null;
        boolean requestFound = false;
        long rentalEndTime = 0;

        try {
            LOGGER.info("Reading Payment.txt");
            paymentLines = Files.readAllLines(Paths.get(PAYMENT_FILE_PATH));
            for (int i = 0; i < paymentLines.size(); i++) {
                String line = paymentLines.get(i).trim();
                if (line.isEmpty()) continue;
                String[] paymentData = line.split("\\s*\\|\\s*");
                if (paymentData.length != 9) {
                    System.out.println("HandleRentalRequestServlet: Skipping malformed line: " + line);
                    continue; // Skip malformed lines
                }
                if (paymentData[0].equals(requestId)) {
                    requestFound = true;
                    renterUsername = paymentData[2];
                    if (action.equals("accept")) {
                        LOGGER.info("Accepting rental request for bike: " + bikeName);
                        long days;
                        try {
                            days = Long.parseLong(rentalDays.trim());
                        } catch (NumberFormatException e) {
                            LOGGER.severe("Invalid rentalDays format: " + rentalDays);
                            request.setAttribute("errorMessage", "Invalid rental days format.");
                            request.getRequestDispatcher("BikeRequests.jsp").forward(request, response);
                            return;
                        }
                        rentalEndTime = System.currentTimeMillis() + (days * 24 * 60 * 60 * 1000);
                        paymentData[4] = "Accepted"; // Status is 5th field
                        paymentLines.set(i, String.join(" | ", paymentData));
                        bikeAvailabilityManager.updateBikeAvailability(bikeName, "Not Available");
                    } else if (action.equals("reject")) {
                        LOGGER.info("Rejecting rental request for bike: " + bikeName);
                        paymentLines.remove(i); // Remove the rejected request
                        i--; // Adjust index after removal
                        break;
                    }
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Failed to process rental request: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to process rental request: " + e.getMessage());
            request.getRequestDispatcher("BikeRequests.jsp").forward(request, response);
            return;
        }

        if (!requestFound) {
            LOGGER.warning("Rental request not found for requestId: " + requestId);
            request.setAttribute("errorMessage", "Rental request not found.");
            request.getRequestDispatcher("BikeRequests.jsp").forward(request, response);
            return;
        }

        // Write updated payments back to Payment.txt
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(PAYMENT_FILE_PATH))) {
            LOGGER.info("Writing updated payment requests to Payment.txt");
            for (String line : paymentLines) {
                if (!line.trim().isEmpty()) {
                    writer.write(line);
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Failed to update payment requests: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to update payment requests: " + e.getMessage());
            request.getRequestDispatcher("BikeRequests.jsp").forward(request, response);
            return;
        }

        // If action is "accept", set session attributes for BikeDetails.jsp and profile.jsp
        if (action.equals("accept")) {
            request.getSession().setAttribute("isRented_" + bikeName, true);
            request.getSession().setAttribute("renterUsername_" + bikeName, renterUsername);
            request.getSession().setAttribute("rentalEndTime_" + bikeName, rentalEndTime);
            LOGGER.info("Set session attributes: isRented_" + bikeName + "=true, renterUsername_" + bikeName + "=" + renterUsername + ", rentalEndTime_" + bikeName + "=" + rentalEndTime);
            request.getSession().setAttribute("successMessage", "Rental request accepted successfully.");
            response.sendRedirect("BikeDetailsServlet?bikeName=" + java.net.URLEncoder.encode(bikeName, "UTF-8"));
        } else {
            // Redirect to BikeRequestsServlet to refresh BikeRequests.jsp
            response.sendRedirect("BikeRequestsServlet?bikeName=" + java.net.URLEncoder.encode(bikeName, "UTF-8"));
        }
    }
}