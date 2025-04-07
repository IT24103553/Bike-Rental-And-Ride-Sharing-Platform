package UserManagement;

import java.io.*;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String email = (String) session.getAttribute("email");

        // Read all users except the one to delete
        ArrayList<String> userLines = new ArrayList<>();
        boolean userFound = false;

        try (BufferedReader reader = new BufferedReader(new FileReader(Constants.FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) { // Expect 5 fields: username, email, password, city, NIC
                    String storedEmail = userData[1].trim().toLowerCase();
                    if (!email.trim().toLowerCase().equals(storedEmail)) {
                        userLines.add(line);
                    } else {
                        userFound = true;
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            response.sendRedirect("profile.jsp");
            return;
        }

        if (!userFound) {
            response.sendRedirect("profile.jsp");
            return;
        }

        // Write updated user data back to the file
        try (FileWriter fileWriter = new FileWriter(Constants.FILE_PATH, false);
             PrintWriter writer = new PrintWriter(fileWriter)) {
            for (String userLine : userLines) {
                writer.println(userLine);
            }
        } catch (IOException e) {
            System.err.println("Error deleting user data: " + e.getMessage());
            response.sendRedirect("profile.jsp");
            return;
        }

        // Log the user out
        session.invalidate();
        response.sendRedirect("index.jsp");
    }
}