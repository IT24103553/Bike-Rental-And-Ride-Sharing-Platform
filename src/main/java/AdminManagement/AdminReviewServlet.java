package AdminManagement;

import BikeManagement.PublicReview;
import BikeManagement.ReviewServlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;

@WebServlet("/AdminReviewServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AdminReviewServlet extends HttpServlet {
    private static final String REVIEWS_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Reviews.txt";
    private static final String UPLOAD_DIR = "uploads";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin privileges required");
            return;
        }

        String action = request.getParameter("action");
        String reviewId = request.getParameter("reviewId");
        String bikeName = request.getParameter("bikeName");

        if ("delete".equals(action) && reviewId != null && bikeName != null) {
            ReviewServlet reviewServlet = new ReviewServlet();
            reviewServlet.deleteReview(bikeName, reviewId);
            response.sendRedirect("AdminReviews.jsp");
        } else if ("update".equals(action) && reviewId != null && bikeName != null) {
            request.setAttribute("reviewId", reviewId);
            request.setAttribute("bikeName", bikeName);
            request.getRequestDispatcher("/AdminReviews.jsp").forward(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action or parameters");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
        if (isAdmin == null || !isAdmin) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied: Admin privileges required");
            return;
        }

        String action = request.getParameter("action");
        String reviewId = request.getParameter("reviewId");
        String bikeName = request.getParameter("bikeName");
        String feedback = request.getParameter("feedback");
        String ratingStr = request.getParameter("rating");

        if (bikeName == null || reviewId == null || feedback == null || ratingStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rating value");
            return;
        }

        if ("update".equals(action)) {
            // Load the original review to preserve userAccountName
            ReviewServlet reviewServlet = new ReviewServlet();
            PublicReview originalReview = null;
            for (String line : java.nio.file.Files.readAllLines(java.nio.file.Paths.get(REVIEWS_FILE_PATH))) {
                String[] parts = line.split("\\|", -1);
                if (parts.length == 7 && parts[0].equals(reviewId)) {
                    originalReview = new PublicReview(parts);
                    break;
                }
            }

            if (originalReview == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found");
                return;
            }

            // Handle image uploads
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String imagePath1 = originalReview.getImagePath1();
            String imagePath2 = originalReview.getImagePath2();

            Part filePart1 = request.getPart("image1");
            if (filePart1 != null && filePart1.getSize() > 0) {
                if (!imagePath1.isEmpty()) new File(uploadPath + File.separator + imagePath1.split("/")[1]).delete();
                String fileName = System.currentTimeMillis() + "_" + filePart1.getSubmittedFileName();
                imagePath1 = UPLOAD_DIR + File.separator + fileName;
                filePart1.write(uploadPath + File.separator + fileName);
            }

            Part filePart2 = request.getPart("image2");
            if (filePart2 != null && filePart2.getSize() > 0) {
                if (!imagePath2.isEmpty()) new File(uploadPath + File.separator + imagePath2.split("/")[1]).delete();
                String fileName = System.currentTimeMillis() + "_" + filePart2.getSubmittedFileName();
                imagePath2 = UPLOAD_DIR + File.separator + fileName;
                filePart2.write(uploadPath + File.separator + fileName);
            }

            // Create updated review with original userAccountName
            PublicReview updatedReview = new PublicReview(reviewId, originalReview.getUserAccountName(), feedback, rating, bikeName, imagePath1, imagePath2);
            reviewServlet.updateReview(updatedReview);
            response.sendRedirect("AdminReviews.jsp");
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
}