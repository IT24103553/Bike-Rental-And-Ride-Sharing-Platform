package BikeManagement.ReviewsManagement;

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
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/ReviewServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ReviewServlet extends HttpServlet {
    private static final String REVIEWS_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Reviews.txt";
    private static final String UPLOAD_DIR = "uploads";
    private static final Logger LOGGER = Logger.getLogger(ReviewServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bikeName = request.getParameter("bikeName");
        if (bikeName == null || bikeName.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing bikeName parameter");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            String reviewIdToDelete = request.getParameter("reviewId");
            if (reviewIdToDelete == null || reviewIdToDelete.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing reviewId parameter");
                return;
            }
            LOGGER.info("Attempting to delete review with ID: " + reviewIdToDelete + " for bike: " + bikeName);
            deleteReview(bikeName, reviewIdToDelete);
            LOGGER.info("Deleted review for bike: " + bikeName + " with reviewId: " + reviewIdToDelete);
            response.sendRedirect("ReviewServlet?bikeName=" + java.net.URLEncoder.encode(bikeName, "UTF-8"));
            return;
        }

        List<PublicReview> reviews = loadReviewsForBike(bikeName);
        LOGGER.info("Loaded " + reviews.size() + " reviews for bike: " + bikeName);
        request.setAttribute("reviews", reviews);
        request.setAttribute("bikeName", bikeName);
        request.getRequestDispatcher("/Review.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String bikeName = request.getParameter("bikeName");
        String userAccountName = (String) request.getSession().getAttribute("username");
        String feedback = request.getParameter("feedback");
        String ratingStr = request.getParameter("rating");
        String reviewId = request.getParameter("reviewId");

        if (bikeName == null || bikeName.trim().isEmpty() || userAccountName == null || feedback == null || ratingStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters");
            return;
        }

        int rating;
        try {
            rating = Integer.parseInt(ratingStr);
            if (rating < 1 || rating > 5) {
                throw new NumberFormatException("Rating must be between 1 and 5");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid rating value");
            return;
        }

        if ("add".equals(action)) {
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String imagePath1 = "";
            String imagePath2 = "";

            Part filePart1 = request.getPart("image1");
            if (filePart1 != null && filePart1.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart1.getSubmittedFileName();
                imagePath1 = UPLOAD_DIR + File.separator + fileName;
                filePart1.write(uploadPath + File.separator + fileName);
            }

            Part filePart2 = request.getPart("image2");
            if (filePart2 != null && filePart2.getSize() > 0) {
                String fileName = System.currentTimeMillis() + "_" + filePart2.getSubmittedFileName();
                imagePath2 = UPLOAD_DIR + File.separator + fileName;
                filePart2.write(uploadPath + File.separator + fileName);
            }

            String reviewIdNew = String.valueOf(System.currentTimeMillis()); // Unique ID for the review
            PublicReview review = new PublicReview(reviewIdNew, userAccountName, feedback, rating, bikeName, imagePath1, imagePath2);
            addReview(review);
            LOGGER.info("Added review for bike: " + bikeName + " by user: " + userAccountName);
            response.sendRedirect("ReviewServlet?bikeName=" + java.net.URLEncoder.encode(bikeName, "UTF-8"));
        } else if ("edit".equals(action)) {
            if (reviewId == null || reviewId.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing reviewId parameter");
                return;
            }

            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            List<PublicReview> reviews = loadReviewsForBike(bikeName);
            PublicReview reviewToUpdate = reviews.stream()
                    .filter(r -> r.getReviewId().equals(reviewId))
                    .findFirst()
                    .orElse(null);

            if (reviewToUpdate == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found");
                return;
            }

            String imagePath1 = reviewToUpdate.getImagePath1();
            String imagePath2 = reviewToUpdate.getImagePath2();

            Part filePart1 = request.getPart("image1");
            if (filePart1 != null && filePart1.getSize() > 0) {
                if (imagePath1 != null && !imagePath1.isEmpty()) {
                    new File(uploadPath + File.separator + imagePath1.split("/")[1]).delete();
                }
                String fileName = System.currentTimeMillis() + "_" + filePart1.getSubmittedFileName();
                imagePath1 = UPLOAD_DIR + File.separator + fileName;
                filePart1.write(uploadPath + File.separator + fileName);
            }

            Part filePart2 = request.getPart("image2");
            if (filePart2 != null && filePart2.getSize() > 0) {
                if (imagePath2 != null && !imagePath2.isEmpty()) {
                    new File(uploadPath + File.separator + imagePath2.split("/")[1]).delete();
                }
                String fileName = System.currentTimeMillis() + "_" + filePart2.getSubmittedFileName();
                imagePath2 = UPLOAD_DIR + File.separator + fileName;
                filePart2.write(uploadPath + File.separator + fileName);
            }

            PublicReview updatedReview = new PublicReview(reviewId, userAccountName, feedback, rating, bikeName, imagePath1, imagePath2);
            updateReview(updatedReview);
            LOGGER.info("Updated review for bike: " + bikeName + " with reviewId: " + reviewId);
            response.sendRedirect("ReviewServlet?bikeName=" + java.net.URLEncoder.encode(bikeName, "UTF-8"));
        }
    }

    private List<PublicReview> loadReviewsForBike(String bikeName) {
        List<PublicReview> reviews = new ArrayList<>();
        File file = new File(REVIEWS_FILE_PATH);
        if (!file.exists()) {
            LOGGER.warning("Reviews file does not exist: " + REVIEWS_FILE_PATH);
            try {
                file.createNewFile();
                LOGGER.info("Created new Reviews file: " + REVIEWS_FILE_PATH);
            } catch (IOException e) {
                LOGGER.severe("Failed to create Reviews file: " + e.getMessage());
            }
            return reviews;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split("\\|", -1);
                if (parts.length == 7 && parts[4].equals(bikeName)) {
                    try {
                        reviews.add(new PublicReview(parts));
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid rating in line: " + line);
                    }
                } else {
                    LOGGER.warning("Invalid format or bikeName mismatch in line: " + line);
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Failed to load reviews: " + e.getMessage());
        }
        return reviews;
    }

    private void addReview(PublicReview review) {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(REVIEWS_FILE_PATH, true))) {
            String line = review.getReviewId() + "|" +
                    review.getUserAccountName() + "|" +
                    review.getFeedback() + "|" +
                    review.getRating() + "|" +
                    review.getBikeName() + "|" +
                    review.getImagePath1() + "|" +
                    review.getImagePath2();
            writer.write(line);
            writer.newLine();
            writer.flush();
            LOGGER.info("Wrote review to file: " + line);
        } catch (IOException e) {
            LOGGER.severe("Failed to add review: " + e.getMessage());
        }
    }

    public void updateReview(PublicReview updatedReview) {
        File file = new File(REVIEWS_FILE_PATH);
        if (!file.exists()) {
            LOGGER.severe("Reviews file does not exist: " + REVIEWS_FILE_PATH);
            return;
        }
        if (!file.canWrite()) {
            LOGGER.severe("Reviews file is not writable: " + REVIEWS_FILE_PATH);
            return;
        }

        try {
            List<String> lines = Files.readAllLines(Paths.get(REVIEWS_FILE_PATH));
            List<String> updatedLines = new ArrayList<>();
            for (String line : lines) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split("\\|", -1);
                if (parts.length == 7 && parts[0].equals(updatedReview.getReviewId())) {
                    String updatedLine = updatedReview.getReviewId() + "|" +
                            updatedReview.getUserAccountName() + "|" +
                            updatedReview.getFeedback() + "|" +
                            updatedReview.getRating() + "|" +
                            updatedReview.getBikeName() + "|" +
                            updatedReview.getImagePath1() + "|" +
                            updatedReview.getImagePath2();
                    updatedLines.add(updatedLine);
                } else {
                    updatedLines.add(line);
                }
            }
            Files.write(Paths.get(REVIEWS_FILE_PATH), updatedLines);
        } catch (IOException e) {
            LOGGER.severe("Failed to update review: " + e.getMessage());
        }
    }

    public void deleteReview(String bikeName, String reviewId) {
        File file = new File(REVIEWS_FILE_PATH);
        if (!file.exists()) {
            LOGGER.severe("Reviews file does not exist: " + REVIEWS_FILE_PATH);
            return;
        }
        if (!file.canWrite()) {
            LOGGER.severe("Reviews file is not writable: " + REVIEWS_FILE_PATH);
            return;
        }

        try {
            List<String> lines = Files.readAllLines(Paths.get(REVIEWS_FILE_PATH));
            LOGGER.info("Total lines before deletion: " + lines.size());
            List<String> updatedLines = new ArrayList<>();
            boolean deleted = false;
            for (String line : lines) {
                if (line.trim().isEmpty()) continue;
                String[] parts = line.split("\\|", -1);
                if (parts.length == 7 && parts[4].equals(bikeName) && parts[0].equals(reviewId)) {
                    deleted = true;
                    LOGGER.info("Deleting line: " + line);
                } else {
                    updatedLines.add(line);
                }
            }
            if (deleted) {
                Files.write(Paths.get(REVIEWS_FILE_PATH), updatedLines);
                LOGGER.info("Total lines after deletion: " + updatedLines.size());
                LOGGER.info("Successfully deleted review for bike: " + bikeName + " with reviewId: " + reviewId);
            } else {
                LOGGER.warning("No review found to delete for bike: " + bikeName + " with reviewId: " + reviewId);
            }
        } catch (IOException e) {
            LOGGER.severe("Failed to delete review: " + e.getMessage());
        }
    }
}