package UserManagement;

import java.io.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String currentEmail = (String) session.getAttribute("email");
        String newUsername = request.getParameter("username");
        String newEmail = request.getParameter("email");
        String newCity = request.getParameter("city");
        String newNic = request.getParameter("nic");

        // Input validation
        if (isEmpty(newUsername) || isEmpty(newEmail) || isEmpty(newCity) || isEmpty(newNic)) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
            return;
        }

        // Read all users from the file
        ArrayList<String> userLines = new ArrayList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(Constants.FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) {
                    String storedEmail = userData[1].trim().toLowerCase();
                    if (currentEmail.trim().toLowerCase().equals(storedEmail)) {
                        userFound = true;
                        String storedHashedPassword = userData[2].trim();
                        // Update the line with new details
                        line = newUsername + " | " + newEmail + " | " + storedHashedPassword + " | " + newCity + " | " + newNic;
                        // Update session attributes
                        session.setAttribute("username", newUsername);
                        session.setAttribute("email", newEmail);
                        session.setAttribute("city", newCity);
                        session.setAttribute("nic", newNic);
                    }
                }
                userLines.add(line);
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            request.setAttribute("errorMessage", "Error reading user data. Please try again.");
            request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
            return;
        }

        if (!userFound) {
            request.setAttribute("errorMessage", "User not found!");
            request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
            return;
        }

        // Write updated user data back to the file
        try (FileWriter fileWriter = new FileWriter(Constants.FILE_PATH, false);
             PrintWriter writer = new PrintWriter(fileWriter)) {
            for (String userLine : userLines) {
                writer.println(userLine);
            }
        } catch (IOException e) {
            System.err.println("Error updating user data: " + e.getMessage());
            request.setAttribute("errorMessage", "Error updating profile. Please try again.");
            request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
            return;
        }

        // Success message
        request.setAttribute("successMessage", "Profile updated successfully!");
        request.getRequestDispatcher("EditProfile.jsp").forward(request, response);
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}