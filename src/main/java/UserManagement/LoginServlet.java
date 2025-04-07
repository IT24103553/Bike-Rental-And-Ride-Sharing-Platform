package UserManagement;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String formType = request.getParameter("formType");

        request.setAttribute("formType", formType);

        if (isEmpty(email) || isEmpty(password)) {
            request.setAttribute("errorMessage", "Email and password are required!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        System.out.println("LoginServlet: Attempting login with Email = " + email + ", Password = " + password); // Debugging

        User authenticatedUser = authenticateUser(email, password);

        if (authenticatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", authenticatedUser.username);
            session.setAttribute("email", authenticatedUser.email);
            session.setAttribute("city", authenticatedUser.city);
            session.setAttribute("nic", authenticatedUser.nic);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("errorMessage", "Invalid email or password!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private User authenticateUser(String email, String password) {
        try (BufferedReader reader = new BufferedReader(new FileReader(Constants.FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("LoginServlet: Reading line = " + line); // Debugging
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) { // Updated to expect 5 fields
                    String storedUsername = userData[0].trim();
                    String storedEmail = userData[1].trim();
                    String storedHashedPassword = userData[2].trim();
                    String storedCity = userData[3].trim();
                    String storedNic = userData[4].trim();

                    System.out.println("LoginServlet: Stored Email = " + storedEmail + ", Stored Password = " + storedHashedPassword + ", Stored City = " + storedCity + ", Stored NIC = " + storedNic); // Debugging

                    // Check if the stored password is a valid BCrypt hash
                    if (!storedHashedPassword.startsWith("$2a$") && !storedHashedPassword.startsWith("$2b$")) {
                        System.out.println("LoginServlet: Invalid BCrypt hash format for user " + storedEmail);
                        continue;
                    }

                    // Case-insensitive email comparison
                    if (email.trim().toLowerCase().equals(storedEmail.toLowerCase())) {
                        try {
                            if (BCrypt.checkpw(password, storedHashedPassword)) {
                                System.out.println("LoginServlet: Password match for user " + storedEmail);
                                return new User(storedUsername, storedEmail, storedCity, storedNic);
                            } else {
                                System.out.println("LoginServlet: Password does not match for user " + storedEmail);
                            }
                        } catch (IllegalArgumentException e) {
                            System.out.println("LoginServlet: BCrypt error for user " + storedEmail + ": " + e.getMessage());
                            continue;
                        }
                    }
                } else {
                    System.out.println("LoginServlet: Invalid line format: " + line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
        }
        System.out.println("LoginServlet: No matching user found for email " + email);
        return null;
    }

    private static class User {
        String username;
        String email;
        String city;
        String nic;

        User(String username, String email, String city, String nic) {
            this.username = username;
            this.email = email;
            this.city = city;
            this.nic = nic;
        }
    }
}