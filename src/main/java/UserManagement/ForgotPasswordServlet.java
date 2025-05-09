package UserManagement;

import java.io.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    private static final String FILE_PATH = Constants.FILE_PATH; // Ensure this is correctly defined

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String nic = request.getParameter("nic");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Input validation
        if (isEmpty(email) || isEmpty(nic) || isEmpty(newPassword) || isEmpty(confirmNewPassword)) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("errorMessage", "New password and confirm password do not match!");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        // Read all users from the file
        ArrayList<String> userLines = new ArrayList<>();
        boolean userFound = false;
        String updatedLine = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                // Trim the line to avoid whitespace issues
                line = line.trim();
                if (line.isEmpty()) {
                    userLines.add(line);
                    continue;
                }

                String[] userData = line.split("\\s*\\|\\s*"); // More flexible delimiter handling
                if (userData.length == 5) { // Expect 5 fields: username, email, password, city, NIC
                    String storedEmail = userData[1].trim().toLowerCase();
                    String storedNic = userData[4].trim().toLowerCase();
                    String inputEmail = email.trim().toLowerCase();
                    String inputNic = nic.trim().toLowerCase();

                    if (inputEmail.equals(storedEmail) && inputNic.equals(storedNic)) {
                        userFound = true;
                        String username = userData[0].trim();
                        String city = userData[3].trim();
                        // Hash the new password
                        String newHashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
                        // Update the line with the new hashed password
                        updatedLine = String.join(" | ", username, userData[1].trim(), newHashedPassword, city, userData[4].trim());
                        userLines.add(updatedLine);
                    } else {
                        userLines.add(line);
                    }
                } else {
                    // Log malformed lines but keep them
                    System.err.println("Malformed line in user file: " + line);
                    userLines.add(line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            request.setAttribute("errorMessage", "Error reading user data. Please try again.");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        // If user not found (email and NIC don't match), show error
        if (!userFound) {
            request.setAttribute("errorMessage", "Email or NIC number not found!");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        // Write updated user data back to the file
        try (FileWriter fileWriter = new FileWriter(FILE_PATH, false);
             PrintWriter writer = new PrintWriter(fileWriter)) {
            for (String userLine : userLines) {
                writer.println(userLine);
            }
            writer.flush(); // Ensure all data is written
        } catch (IOException e) {
            System.err.println("Error updating password: " + e.getMessage());
            request.setAttribute("errorMessage", "Error updating password. Please try again.");
            request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
            return;
        }

        // Success message
        request.setAttribute("successMessage", "Password reset successfully! Please log in with your new password.");
        request.getRequestDispatcher("ForgotPassword.jsp").forward(request, response);
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}