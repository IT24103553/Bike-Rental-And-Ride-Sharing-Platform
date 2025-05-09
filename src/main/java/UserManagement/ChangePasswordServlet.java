package UserManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

    private static final String FILE_PATH = Constants.FILE_PATH; // Use Constants.FILE_PATH instead of hardcoding

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check if the user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Input validation
        if (currentPassword == null || newPassword == null || confirmNewPassword == null ||
                currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmNewPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "All fields are required.");
            request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("errorMessage", "New password and confirmation do not match.");
            request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
            return;
        }

        // Read user data and verify current password
        List<String[]> userDataList = new ArrayList<>();
        boolean userFound = false;
        String[] currentUserData = null;

        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) {
                    String storedEmail = userData[1].trim();
                    if (storedEmail.equalsIgnoreCase(email)) {
                        userFound = true;
                        currentUserData = userData;
                        String storedHashedPassword = userData[2].trim();
                        // Verify current password using BCrypt
                        if (!BCrypt.checkpw(currentPassword, storedHashedPassword)) {
                            request.setAttribute("errorMessage", "Current password is incorrect.");
                            request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
                            return;
                        }
                    }
                    userDataList.add(userData);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            request.setAttribute("errorMessage", "Error reading user data. Please try again.");
            request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
            return;
        }

        if (!userFound) {
            request.setAttribute("errorMessage", "User not found.");
            request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
            return;
        }

        // Hash the new password using BCrypt
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        // Update the user's password in the list
        for (String[] userData : userDataList) {
            if (userData[1].trim().equalsIgnoreCase(email)) {
                userData[2] = hashedNewPassword;
                break;
            }
        }

        // Write the updated user data back to the file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (String[] userData : userDataList) {
                writer.write(String.join(" | ", userData));
                writer.newLine();
            }
        } catch (IOException e) {
            System.err.println("Error writing user data: " + e.getMessage());
            request.setAttribute("errorMessage", "Error saving new password. Please try again.");
            request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
            return;
        }

        // Display success message
        request.setAttribute("successMessage", "Password changed successfully!");
        request.getRequestDispatcher("ChangePassword.jsp").forward(request, response);
    }
}