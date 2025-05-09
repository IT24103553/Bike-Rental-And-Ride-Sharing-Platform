package PaymentManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@WebServlet("/UploadPaymentServlet")
@MultipartConfig
public class UploadPaymentServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/webapp/uploads";
    private static final String PAYMENT_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Payment.txt";
    private static final double BASE_RATE_PER_DAY = 100.0; // Example base rate per day
    private static final double ADDITIONAL_SERVICE_COST = 20.0; // Example cost per additional service
    private static final double DEFAULT_TOTAL_PAYMENT = 0.0; // Default if calculation fails

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get form parameters
        String orderNumber = request.getParameter("orderNumber");
        String email = request.getParameter("email");
        String bikeId = request.getParameter("bikeId");
        String username = request.getParameter("name");
        String totalPaymentStr = request.getParameter("totalPayment");
        String rentalDays = request.getParameter("rentalDays");
        String[] additionalServices = request.getParameterValues("additionalServices");
        Part filePart = request.getPart("slip");

        // Debug: Log the received parameters
        System.out.println("UploadPaymentServlet: Received parameters - orderNumber: " + orderNumber +
                ", email: " + email +
                ", bikeId: " + bikeId +
                ", username: " + username +
                ", totalPayment: " + totalPaymentStr +
                ", rentalDays: " + rentalDays);

        // Debug: Log additional services
        System.out.println("UploadPaymentServlet: Additional Services: " +
                (additionalServices != null ? String.join(", ", additionalServices) : "None"));

        // Validate inputs
        if (orderNumber == null || orderNumber.isEmpty() ||
                email == null || email.isEmpty() ||
                bikeId == null || bikeId.isEmpty() ||
                username == null || username.isEmpty() ||
                totalPaymentStr == null || totalPaymentStr.trim().isEmpty() ||
                rentalDays == null || rentalDays.isEmpty() ||
                filePart == null || filePart.getSize() == 0) {
            System.out.println("UploadPaymentServlet: Validation failed - Missing required fields");
            request.setAttribute("errorMessage", "All fields are required, including the payment slip.");
            request.setAttribute("bikeId", bikeId);
            request.setAttribute("username", username);
            request.setAttribute("totalPayment", totalPaymentStr);
            request.getRequestDispatcher("/Payment.jsp").forward(request, response);
            return;
        }

        String loggedInUser = (String) request.getSession().getAttribute("username");
        if (loggedInUser == null || !loggedInUser.equals(username)) {
            System.out.println("UploadPaymentServlet: Authorization failed - Logged in user: " + loggedInUser + ", Form username: " + username);
            request.setAttribute("errorMessage", "You are not authorized to upload a payment slip for this user.");
            request.setAttribute("bikeId", bikeId);
            request.setAttribute("username", username);
            request.setAttribute("totalPayment", totalPaymentStr);
            request.getRequestDispatcher("/Payment.jsp").forward(request, response);
            return;
        }

        // Save the uploaded file
        String fileName = username + "_" + orderNumber + "_slip" + getFileExtension(filePart);
        File uploadDir = new File(UPLOAD_DIR);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        File file = new File(uploadDir, fileName);
        try (InputStream input = filePart.getInputStream()) {
            Files.copy(input, file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            System.out.println("UploadPaymentServlet: Payment slip saved successfully at: " + file.getAbsolutePath());
        } catch (IOException e) {
            System.out.println("UploadPaymentServlet: Failed to upload payment slip: " + e.getMessage());
            request.setAttribute("errorMessage", "Failed to upload payment slip: " + e.getMessage());
            request.setAttribute("bikeId", bikeId);
            request.setAttribute("username", username);
            request.setAttribute("totalPayment", totalPaymentStr);
            request.getRequestDispatcher("/Payment.jsp").forward(request, response);
            return;
        }

        // Validate and calculate totalPayment
        double totalPayment;
        try {
            totalPayment = Double.parseDouble(totalPaymentStr.trim());
            System.out.println("UploadPaymentServlet: Using provided totalPayment: " + totalPayment);
        } catch (NumberFormatException e) {
            System.out.println("UploadPaymentServlet: Invalid totalPayment value: " + totalPaymentStr + ", calculating fallback");
            int days;
            try {
                days = Integer.parseInt(rentalDays.trim());
            } catch (NumberFormatException ex) {
                System.out.println("UploadPaymentServlet: Invalid rentalDays value: " + rentalDays + ", Exception: " + ex.getMessage());
                days = 1; // Default to 1 day if rentalDays is invalid
            }
            int serviceCount = additionalServices != null ? additionalServices.length : 0;
            totalPayment = (days * BASE_RATE_PER_DAY) + (serviceCount * ADDITIONAL_SERVICE_COST);
            System.out.println("UploadPaymentServlet: Calculated totalPayment: " + totalPayment);
        }

        // Verify Payment.txt accessibility before writing
        File paymentFile = new File(PAYMENT_FILE_PATH);
        if (!paymentFile.exists()) {
            paymentFile.createNewFile();
            System.out.println("UploadPaymentServlet: Created new Payment.txt at: " + PAYMENT_FILE_PATH);
        }
        if (!paymentFile.canWrite()) {
            System.out.println("UploadPaymentServlet: Payment.txt is not writable at: " + PAYMENT_FILE_PATH);
            request.setAttribute("errorMessage", "Server error: Payment.txt is not writable.");
            request.setAttribute("bikeId", bikeId);
            request.setAttribute("username", username);
            request.setAttribute("totalPayment", totalPaymentStr);
            request.getRequestDispatcher("/Payment.jsp").forward(request, response);
            return;
        }

        // Save payment details to Payment.txt
        String additionalServicesStr = additionalServices != null && additionalServices.length > 0 ? String.join(", ", additionalServices) : "None";
        String paymentLine = String.format("%s | %s | %s | %s | Pending | %s | %.2f | %s | %s",
                orderNumber, bikeId, username, email, rentalDays, totalPayment, additionalServicesStr, fileName);
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(PAYMENT_FILE_PATH, true))) {
            writer.write(paymentLine);
            writer.newLine();
            writer.flush(); // Ensure the buffer is flushed to the file
            System.out.println("UploadPaymentServlet: Payment details saved successfully to Payment.txt: " + paymentLine);
        } catch (IOException e) {
            System.out.println("UploadPaymentServlet: Failed to save payment details to Payment.txt: " + e.getMessage());
            e.printStackTrace(); // Print stack trace for detailed error
            request.setAttribute("errorMessage", "Failed to save payment details: " + e.getMessage());
            request.setAttribute("bikeId", bikeId);
            request.setAttribute("username", username);
            request.setAttribute("totalPayment", totalPaymentStr);
            request.getRequestDispatcher("/Payment.jsp").forward(request, response);
            return;
        }

        // Set success message and forward back to Payment.jsp to display it, then redirect to index.jsp
        request.setAttribute("successMessage", "Payment Successful!");
        System.out.println("UploadPaymentServlet: Forwarding to Payment.jsp to display success message");
        request.getRequestDispatcher("/Payment.jsp").forward(request, response);
    }

    private String getFileExtension(Part part) {
        String fileName = part.getSubmittedFileName();
        if (fileName != null && fileName.lastIndexOf('.') != -1) {
            return fileName.substring(fileName.lastIndexOf('.'));
        }
        return ".unknown";
    }
}