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

// Abstract base class for users with polymorphic display method
abstract class User {
    protected String username;
    protected String email;
    protected String city;
    protected String nic;

    public User(String username, String email, String city, String nic) {
        this.username = username;
        this.email = email;
        this.city = city;
        this.nic = nic;
    }

    // Getters for encapsulation
    public String getUsername() { return username; }
    public String getEmail() { return email; }
    public String getCity() { return city; }
    public String getNic() { return nic; }

    // Abstract method for polymorphic display
    public abstract String display();

    // Abstract method to define redirection behavior
    public abstract String getRedirectPage();
}

// Regular user class
class RegularUser extends User {
    public RegularUser(String username, String email, String city, String nic) {
        super(username, email, city, nic);
    }

    @Override
    public String display() {
        return "Regular User: " + username + " | Email: " + email;
    }

    @Override
    public String getRedirectPage() {
        return "index.jsp";
    }
}

// Admin class inheriting from User
class Admin extends User {
    public Admin(String username, String email, String city, String nic) {
        super(username, email, city, nic);
    }

    @Override
    public String display() {
        return "Admin: " + username + " | Email: " + email + " (Admin Privileges)";
    }

    @Override
    public String getRedirectPage() {
        return "AdminDashboard.jsp";
    }

    // Admin-specific method (abstraction)
    public void performAdminAction() {
        System.out.println("Admin action performed by: " + username);
    }
}

@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {

    // File paths for users and admins
    private static final String USER_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/users.txt";
    private static final String ADMIN_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Admin.txt";

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

        System.out.println("LoginServlet: Attempting login with Email = " + email + ", Password = " + password);

        // First, try to authenticate as an admin
        User authenticatedUser = authenticateAdmin(email, password);
        if (authenticatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", authenticatedUser.getUsername());
            session.setAttribute("email", authenticatedUser.getEmail());
            session.setAttribute("city", authenticatedUser.getCity());
            session.setAttribute("nic", authenticatedUser.getNic());
            session.setAttribute("isAdmin", true); // Flag to indicate admin status
            session.setAttribute("userObject", authenticatedUser); // Store user object for polymorphic use
            response.sendRedirect(authenticatedUser.getRedirectPage());
            return;
        }

        // If not an admin, try to authenticate as a regular user
        authenticatedUser = authenticateRegularUser(email, password);
        if (authenticatedUser != null) {
            HttpSession session = request.getSession();
            session.setAttribute("username", authenticatedUser.getUsername());
            session.setAttribute("email", authenticatedUser.getEmail());
            session.setAttribute("city", authenticatedUser.getCity());
            session.setAttribute("nic", authenticatedUser.getNic());
            session.setAttribute("isAdmin", false); // Flag to indicate regular user
            session.setAttribute("userObject", authenticatedUser); // Store user object for polymorphic use
            response.sendRedirect(authenticatedUser.getRedirectPage());
            return;
        }

        // If authentication fails
        request.setAttribute("errorMessage", "Invalid email or password!");
        request.getRequestDispatcher("Login.jsp").forward(request, response);
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private User authenticateAdmin(String email, String password) {
        try (BufferedReader reader = new BufferedReader(new FileReader(ADMIN_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("LoginServlet: Reading admin line = " + line);
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) {
                    String storedUsername = userData[0].trim();
                    String storedEmail = userData[1].trim();
                    String storedHashedPassword = userData[2].trim();
                    String storedCity = userData[3].trim();
                    String storedNic = userData[4].trim();

                    System.out.println("LoginServlet: Stored Admin Email = " + storedEmail);

                    if (!storedHashedPassword.startsWith("$2a$") && !storedHashedPassword.startsWith("$2b$")) {
                        System.out.println("LoginServlet: Invalid BCrypt hash format for admin " + storedEmail);
                        continue;
                    }

                    if (email.trim().toLowerCase().equals(storedEmail.toLowerCase())) {
                        try {
                            if (BCrypt.checkpw(password, storedHashedPassword)) {
                                System.out.println("LoginServlet: Admin password match for " + storedEmail);
                                return new Admin(storedUsername, storedEmail, storedCity, storedNic);
                            } else {
                                System.out.println("LoginServlet: Admin password does not match for " + storedEmail);
                            }
                        } catch (IllegalArgumentException e) {
                            System.out.println("LoginServlet: BCrypt error for admin " + storedEmail + ": " + e.getMessage());
                            continue;
                        }
                    }
                } else {
                    System.out.println("LoginServlet: Invalid admin line format: " + line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading admin data: " + e.getMessage());
        }
        System.out.println("LoginServlet: No matching admin found for email " + email);
        return null;
    }

    private User authenticateRegularUser(String email, String password) {
        try (BufferedReader reader = new BufferedReader(new FileReader(USER_FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                System.out.println("LoginServlet: Reading user line = " + line);
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) {
                    String storedUsername = userData[0].trim();
                    String storedEmail = userData[1].trim();
                    String storedHashedPassword = userData[2].trim();
                    String storedCity = userData[3].trim();
                    String storedNic = userData[4].trim();

                    System.out.println("LoginServlet: Stored User Email = " + storedEmail);

                    if (!storedHashedPassword.startsWith("$2a$") && !storedHashedPassword.startsWith("$2b$")) {
                        System.out.println("LoginServlet: Invalid BCrypt hash format for user " + storedEmail);
                        continue;
                    }

                    if (email.trim().toLowerCase().equals(storedEmail.toLowerCase())) {
                        try {
                            if (BCrypt.checkpw(password, storedHashedPassword)) {
                                System.out.println("LoginServlet: User password match for " + storedEmail);
                                return new RegularUser(storedUsername, storedEmail, storedCity, storedNic);
                            } else {
                                System.out.println("LoginServlet: User password does not match for " + storedEmail);
                            }
                        } catch (IllegalArgumentException e) {
                            System.out.println("LoginServlet: BCrypt error for user " + storedEmail + ": " + e.getMessage());
                            continue;
                        }
                    }
                } else {
                    System.out.println("LoginServlet: Invalid user line format: " + line);
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
        }
        System.out.println("LoginServlet: No matching user found for email " + email);
        return null;
    }
}