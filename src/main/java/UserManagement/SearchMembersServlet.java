package UserManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/SearchMembersServlet")
public class SearchMembersServlet extends HttpServlet {

    // Use Constants.FILE_PATH instead of a hardcoded path
    private static final String FILE_PATH = Constants.FILE_PATH;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check if the user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("email") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String searchQuery = request.getParameter("searchQuery");

        // Input validation
        if (searchQuery == null || searchQuery.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Please enter a username or NIC number to search.");
            request.getRequestDispatcher("SearchMembers.jsp").forward(request, response);
            return;
        }

        // Search for users
        List<String[]> searchResults = new ArrayList<>();
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] userData = line.split(" \\| ");
                if (userData.length == 5) {
                    String username = userData[0].trim();
                    String nic = userData[4].trim();
                    // Match username or NIC (case-insensitive)
                    if (username.equalsIgnoreCase(searchQuery) || nic.equalsIgnoreCase(searchQuery)) {
                        searchResults.add(userData);
                    }
                }
            }
        } catch (IOException e) {
            System.err.println("Error reading user data: " + e.getMessage());
            request.setAttribute("errorMessage", "Error reading user data. Please try again.");
            request.getRequestDispatcher("SearchMembers.jsp").forward(request, response);
            return;
        }

        if (searchResults.isEmpty()) {
            request.setAttribute("errorMessage", "No users found with the given username or NIC number.");
        } else {
            request.setAttribute("searchResults", searchResults);
        }

        request.getRequestDispatcher("SearchMembers.jsp").forward(request, response);
    }
}