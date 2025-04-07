package UserManagement;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet("/registerServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String city = request.getParameter("city");
        String nic = request.getParameter("nic");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm_password");
        String formType = request.getParameter("formType");

        request.setAttribute("formType", formType);

        if (isEmpty(username) || isEmpty(email) || isEmpty(city) || isEmpty(nic) || isEmpty(password) || isEmpty(confirmPassword)) {
            request.setAttribute("errorMessage", "All fields are required!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Passwords do not match!");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
            return;
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        System.out.println("RegisterServlet: Hashed Password = " + hashedPassword); // Debugging

        if (saveUserData(username, email, hashedPassword, city, nic)) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("email", email);
            session.setAttribute("city", city);
            session.setAttribute("nic", nic);
            response.sendRedirect("index.jsp");
        } else {
            request.setAttribute("errorMessage", "Failed to save user data. Please try again.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean saveUserData(String username, String email, String hashedPassword, String city, String nic) {
        try (FileWriter fileWriter = new FileWriter(Constants.FILE_PATH, true);
             PrintWriter writer = new PrintWriter(fileWriter)) {
            writer.println(username + " | " + email + " | " + hashedPassword + " | " + city + " | " + nic);
            return true;
        } catch (IOException e) {
            System.err.println("Error saving user data: " + e.getMessage());
            return false;
        }
    }
}