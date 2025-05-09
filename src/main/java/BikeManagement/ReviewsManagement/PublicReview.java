package BikeManagement.ReviewsManagement;

public class PublicReview {
    private String reviewId; // Unique identifier for the review
    private String userAccountName;
    private String feedback;
    private int rating;
    private String bikeName;
    private String imagePath1;
    private String imagePath2;

    // Constructor for creating a new review
    public PublicReview(String reviewId, String userAccountName, String feedback, int rating, String bikeName, String imagePath1, String imagePath2) {
        this.reviewId = reviewId;
        this.userAccountName = userAccountName;
        this.feedback = feedback;
        this.rating = rating;
        this.bikeName = bikeName;
        this.imagePath1 = imagePath1 != null ? imagePath1 : "";
        this.imagePath2 = imagePath2 != null ? imagePath2 : "";
    }

    // Constructor for loading reviews from file
    public PublicReview(String[] parts) {
        this.reviewId = parts[0];
        this.userAccountName = parts[1];
        this.feedback = parts[2];
        this.rating = Integer.parseInt(parts[3]);
        this.bikeName = parts[4];
        this.imagePath1 = parts[5];
        this.imagePath2 = parts[6];
    }

    // Getters and setters
    public String getReviewId() {
        return reviewId;
    }

    public String getUserAccountName() {
        return userAccountName;
    }

    public String getFeedback() {
        return feedback;
    }

    public int getRating() {
        return rating;
    }

    public String getBikeName() {
        return bikeName;
    }

    public String getImagePath1() {
        return imagePath1;
    }

    public String getImagePath2() {
        return imagePath2;
    }
}