package RentAndRideManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.nio.file.*;
import java.util.List;
import java.util.Random;
import java.net.URLEncoder;

@WebServlet("/RentBikeServlet")
public class RentBikeServlet extends HttpServlet {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";
    private static final String RENTAL_REQUEST_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/RentalRequests.txt";
    private static final double ADDITIONAL_SERVICE_COST = 25.0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bikeName = request.getParameter("bikeName");
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        // Debug: Log the incoming request
        System.out.println("RentBikeServlet: Received GET request for bikeName: " + bikeName);
        System.out.println("RentBikeServlet: Username from session: " + username);

        // Check if user is logged in
        if (username == null) {
            System.out.println("RentBikeServlet: User not logged in, redirecting to Login.jsp");
            request.setAttribute("errorMessage", "You must be logged in to rent a bike.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        // Validate bike name
        if (bikeName == null || bikeName.trim().isEmpty()) {
            System.out.println("RentBikeServlet: Bike name is missing, redirecting to Bikes.jsp");
            request.setAttribute("errorMessage", "Bike name is missing.");
            request.getRequestDispatcher("Bikes.jsp").forward(request, response);
            return;
        }

        // Fetch bike details from Bikes.txt
        double pricePerHour = 0;
        boolean bikeAvailable = false;
        boolean bikeFound = false;
        try {
            File bikesFile = new File(BIKES_FILE_PATH);
            System.out.println("RentBikeServlet: Checking if Bikes.txt exists at: " + BIKES_FILE_PATH);
            if (!bikesFile.exists()) {
                System.out.println("RentBikeServlet: Bikes.txt not found");
                request.setAttribute("errorMessage", "Bike data file not found at: " + BIKES_FILE_PATH);
                request.getRequestDispatcher("Bikes.jsp").forward(request, response);
                return;
            }

            List<String> lines = Files.readAllLines(Paths.get(BIKES_FILE_PATH));
            System.out.println("RentBikeServlet: Bikes.txt contents:");
            for (String line : lines) {
                System.out.println(line);
                if (line.trim().isEmpty()) continue;
                String[] bikeData = line.trim().split("\\s*\\|\\s*");
                if (bikeData.length != 6) {
                    System.out.println("RentBikeServlet: Skipping malformed line: " + line);
                    continue; // Skip malformed lines
                }
                if (bikeData[0].equals(bikeName)) {
                    bikeFound = true;
                    try {
                        pricePerHour = Double.parseDouble(bikeData[2]);
                    } catch (NumberFormatException e) {
                        System.out.println("RentBikeServlet: Invalid price format for bike " + bikeName + ": " + bikeData[2]);
                        throw new NumberFormatException("Invalid price format for bike " + bikeName + ": " + bikeData[2]);
                    }
                    bikeAvailable = bikeData[4].trim().equalsIgnoreCase("Available");
                    System.out.println("RentBikeServlet: Found bike - Name: " + bikeName + ", Price Per Hour: " + pricePerHour + ", Availability: " + bikeData[4]);
                    break;
                }
            }
        } catch (IOException e) {
            System.out.println("RentBikeServlet: IOException while reading Bikes.txt: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to fetch bike details: " + e.getMessage());
            request.getRequestDispatcher("Bikes.jsp").forward(request, response);
            return;
        } catch (NumberFormatException e) {
            System.out.println("RentBikeServlet: NumberFormatException while parsing price: " + e.getMessage());
            request.setAttribute("errorMessage", "Invalid bike price format: " + e.getMessage());
            request.getRequestDispatcher("Bikes.jsp").forward(request, response);
            return;
        }

        // Check if bike was found
        if (!bikeFound) {
            System.out.println("RentBikeServlet: Bike not found: " + bikeName);
            request.setAttribute("errorMessage", "Bike not found: " + bikeName);
            request.getRequestDispatcher("Bikes.jsp").forward(request, response);
            return;
        }

        // Check if bike is available
        if (!bikeAvailable) {
            System.out.println("RentBikeServlet: Bike not available: " + bikeName);
            request.setAttribute("errorMessage", "This bike is not available for rent.");
            request.getRequestDispatcher("BikeDetailsServlet?bikeName=" + bikeName).forward(request, response);
            return;
        }

        // Get or generate order number
        String orderNumberStr = request.getParameter("orderNumber");
        Integer orderNumber;
        if (orderNumberStr != null && !orderNumberStr.isEmpty()) {
            // Use the existing order number from the form
            orderNumber = Integer.parseInt(orderNumberStr);
            System.out.println("RentBikeServlet: Reusing existing order number: " + orderNumber);
        } else {
            // Generate a new order number and store it in the session
            Random random = new Random();
            orderNumber = 1000 + random.nextInt(9000); // Random number between 1000 and 9999
            session.setAttribute("orderNumber", orderNumber);
            System.out.println("RentBikeServlet: Generated new order number: " + orderNumber);
        }

        // Get rental days and additional services (default to 1 day, no services if not provided)
        String rentalDaysStr = request.getParameter("rentalDays");
        int rentalDays = (rentalDaysStr != null && !rentalDaysStr.isEmpty()) ? Integer.parseInt(rentalDaysStr) : 1;
        if (rentalDays < 1) rentalDays = 1; // Ensure at least 1 day

        String[] additionalServices = request.getParameterValues("additionalServices");
        int additionalServicesCount = (additionalServices != null) ? additionalServices.length : 0;

        // Calculate total payment
        double basePayment = pricePerHour * 24 * rentalDays;
        double additionalCost = additionalServicesCount * ADDITIONAL_SERVICE_COST;
        double totalPayment = basePayment + additionalCost;

        // Debug: Log the calculation
        System.out.println("RentBikeServlet: Rental Days: " + rentalDays);
        System.out.println("RentBikeServlet: Additional Services Count: " + additionalServicesCount);
        System.out.println("RentBikeServlet: Base Payment: " + basePayment);
        System.out.println("RentBikeServlet: Additional Cost: " + additionalCost);
        System.out.println("RentBikeServlet: Total Payment: " + totalPayment);

        // Set attributes for RentBike.jsp
        request.setAttribute("bikeName", bikeName);
        request.setAttribute("pricePerHour", pricePerHour);
        request.setAttribute("username", username);
        request.setAttribute("orderNumber", orderNumber);
        request.setAttribute("rentalDays", rentalDays);
        request.setAttribute("additionalServices", additionalServices);
        request.setAttribute("totalPayment", totalPayment);

        // Debug: Log the attributes being set
        System.out.println("RentBikeServlet: Setting attributes - bikeName: " + bikeName + ", pricePerHour: " + pricePerHour + ", username: " + username + ", orderNumber: " + orderNumber + ", rentalDays: " + rentalDays + ", totalPayment: " + totalPayment);
        System.out.println("RentBikeServlet: Forwarding to RentBike.jsp");

        // Forward to RentBike.jsp
        request.getRequestDispatcher("RentBike.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Debug: Log the incoming POST request
        System.out.println("RentBikeServlet: Received POST request");

        // Extract parameters from the POST request
        String action = request.getParameter("action");
        String bikeName = request.getParameter("bikeName");
        String usernameFromRequest = request.getParameter("username");
        String orderNumber = request.getParameter("orderNumber");
        String rentalDays = request.getParameter("rentalDays");
        String[] additionalServices = request.getParameterValues("additionalServices");

        // Get username from session as fallback if request parameter is null
        HttpSession session = request.getSession();
        String username = usernameFromRequest != null && !usernameFromRequest.trim().isEmpty() ? usernameFromRequest : (String) session.getAttribute("username");

        // Debug: Log the username values
        System.out.println("RentBikeServlet: usernameFromRequest: " + usernameFromRequest);
        System.out.println("RentBikeServlet: username from session: " + session.getAttribute("username"));
        System.out.println("RentBikeServlet: Final username used: " + username);

        if ("checkout".equals(action)) {
            // Handle checkout: Save details to RentalRequests.txt and redirect to Payment.jsp
            StringBuilder rentalDetails = new StringBuilder();
            rentalDetails.append("Bike Name: ").append(bikeName).append(" | ");
            rentalDetails.append("Username: ").append(username != null ? username : "Unknown").append(" | ");
            rentalDetails.append("Order Number: ").append(orderNumber).append(" | ");
            rentalDetails.append("Rental Days: ").append(rentalDays).append(" | ");
            rentalDetails.append("Additional Services: ");
            if (additionalServices != null && additionalServices.length > 0) {
                for (String service : additionalServices) {
                    rentalDetails.append(service).append(", ");
                }
                rentalDetails.setLength(rentalDetails.length() - 2); // Remove the last ", "
            } else {
                rentalDetails.append("None");
            }

            // Save to RentalRequests.txt
            try (BufferedWriter writer = Files.newBufferedWriter(Paths.get(RENTAL_REQUEST_FILE_PATH), StandardOpenOption.APPEND, StandardOpenOption.CREATE)) {
                writer.write(rentalDetails.toString());
                writer.newLine();
                System.out.println("RentBikeServlet: Successfully saved rental details to RentalRequests.txt: " + rentalDetails.toString());
            } catch (IOException e) {
                System.out.println("RentBikeServlet: Failed to save rental details: " + e.getMessage());
                request.setAttribute("errorMessage", "Failed to save rental details: " + e.getMessage());
                request.getRequestDispatcher("RentBike.jsp").forward(request, response);
                return;
            }

            // Redirect to Payment.jsp with all parameters
            StringBuilder redirectUrl = new StringBuilder("Payment.jsp?");
            redirectUrl.append("bikeId=").append(URLEncoder.encode(bikeName, "UTF-8"));
            redirectUrl.append("&username=").append(URLEncoder.encode(username != null ? username : "", "UTF-8"));
            redirectUrl.append("&orderNumber=").append(orderNumber);
            redirectUrl.append("&rentalDays=").append(rentalDays);
            if (additionalServices != null) {
                for (String service : additionalServices) {
                    redirectUrl.append("&additionalServices=").append(URLEncoder.encode(service, "UTF-8"));
                }
            }
            redirectUrl.append("&totalPayment=").append(request.getParameter("totalPayment"));

            System.out.println("RentBikeServlet: Redirecting to Payment.jsp with URL: " + redirectUrl.toString());
            response.sendRedirect(redirectUrl.toString());
        } else {
            // Handle "Update Total" action (existing behavior)
            StringBuilder redirectUrl = new StringBuilder("RentBikeServlet?");
            redirectUrl.append("bikeName=").append(URLEncoder.encode(bikeName, "UTF-8"));
            redirectUrl.append("&orderNumber=").append(orderNumber);
            redirectUrl.append("&rentalDays=").append(rentalDays);

            if (additionalServices != null) {
                for (String service : additionalServices) {
                    redirectUrl.append("&additionalServices=").append(URLEncoder.encode(service, "UTF-8"));
                }
            }

            // Debug: Log the redirect URL
            System.out.println("RentBikeServlet: Redirecting to GET with URL: " + redirectUrl.toString());

            // Redirect to the GET handler
            response.sendRedirect(redirectUrl.toString());
        }
    }
}