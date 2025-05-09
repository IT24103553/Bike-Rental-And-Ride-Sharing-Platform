package BikeManagement.ReviewsManagement;

public class Review {
    private String userAccountName;
    private String feedback;
    private int rating;
    private String bikeName;

    public Review(String userAccountName, String feedback, int rating, String bikeName) {
        this.userAccountName = userAccountName;
        this.feedback = feedback;
        this.rating = rating;
        this.bikeName = bikeName;
    }

    public String getUserAccountName() {
        return userAccountName;
    }

    public void setUserAccountName(String userAccountName) {
        this.userAccountName = userAccountName;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getBikeName() {
        return bikeName;
    }

    public void setBikeName(String bikeName) {
        this.bikeName = bikeName;
    }
}