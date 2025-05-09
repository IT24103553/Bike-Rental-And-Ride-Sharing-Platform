<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, BikeManagement.ReviewsManagement.PublicReview, java.io.BufferedReader, java.io.FileReader, java.net.URLEncoder" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE - Admin Reviews</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0==" crossorigin="anonymous">
  <style>
    body { background-color: #f0f0f0; }
    .btn-custom { border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; width: 120px; }
    .btn-danger { background-color: #dc3545; }
    .btn-danger:hover { background-color: #c82333; transform: scale(1.05); }
    .btn-primary { background-color: #0d6efd; }
    .btn-primary:hover { background-color: #0b5ed7; transform: scale(1.05); }
    .btn-secondary { background-color: #6c757d; }
    .btn-secondary:hover { background-color: #5c636a; transform: scale(1.05); }
    .review-card { background-color: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
    .star-rating { color: #f76b64; font-size: 1.2rem; }
    .review-images { display: flex; flex-direction: row; gap: 10px; }
    .review-image { max-width: 150px; }
    .update-form { display: none; margin-top: 20px; padding: 15px; background-color: #fff; border: 1px solid #ddd; border-radius: 8px; }
    .update-form.active { display: block; }
    .image-preview { max-width: 150px; margin-top: 10px; }
  </style>
</head>
<body>
<!-- Admin Reviews Section -->
<section class="container mx-auto px-6 py-16">
  <%
    // Check if the user is an admin
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
  %>
  <div class="alert alert-danger" role="alert">
    Access Denied: You must be an admin to view this page. Please <a href="Login.jsp">log in</a> as an admin.
  </div>
  <% return; } %>

  <div class="flex justify-between items-center mb-6">
    <h2 class="text-3xl font-bold">Admin Reviews & Feedback</h2>
    <a href="AdminDashboard.jsp" class="btn btn-secondary btn-custom text-white">Go Back</a>
  </div>

  <%
    String REVIEWS_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Reviews.txt";
    Map<String, List<PublicReview>> reviewsByBike = new TreeMap<>(); // TreeMap to sort bike names alphabetically

    // Load all reviews and group by bikeName
    try {
      File file = new File(REVIEWS_FILE_PATH);
      if (file.exists()) {
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
          String line;
          while ((line = reader.readLine()) != null) {
            if (line.trim().isEmpty()) continue;
            String[] parts = line.split("\\|", -1);
            if (parts.length == 7) {
              PublicReview review = new PublicReview(parts);
              String bikeName = review.getBikeName();
              reviewsByBike.computeIfAbsent(bikeName, k -> new ArrayList<>()).add(review);
            }
          }
        }
      }
    } catch (Exception e) {
  %>
  <div class="alert alert-danger" role="alert">Error loading reviews: <%= e.getMessage() %></div>
  <% return; } %>

  <!-- Display reviews grouped by bikeName -->
  <% if (reviewsByBike.isEmpty()) { %>
  <p class="text-center">No reviews yet.</p>
  <% } else { %>
  <div class="review-list">
    <% for (Map.Entry<String, List<PublicReview>> entry : reviewsByBike.entrySet()) { %>
    <div class="mb-8">
      <h3 class="text-2xl font-semibold mb-4"><%= entry.getKey() %></h3>
      <% for (PublicReview review : entry.getValue()) { %>
      <div class="review-card">
        <div class="flex justify-between items-center">
          <p><strong><%= review.getUserAccountName() %></strong> <span class="star-rating">★ <%= review.getRating() %>/5</span></p>
          <div>
            <a href="AdminReviews.jsp?action=update&reviewId=<%= URLEncoder.encode(review.getReviewId(), "UTF-8") %>&bikeName=<%= URLEncoder.encode(review.getBikeName(), "UTF-8") %>" class="btn btn-primary btn-custom text-white mr-2">Update</a>
            <a href="AdminReviewServlet?action=delete&reviewId=<%= URLEncoder.encode(review.getReviewId(), "UTF-8") %>&bikeName=<%= URLEncoder.encode(review.getBikeName(), "UTF-8") %>" class="btn btn-danger btn-custom text-white" onclick="return confirm('Are you sure you want to delete this review?');">Delete</a>
          </div>
        </div>
        <p><%= review.getFeedback() %></p>
        <div class="review-images mt-2">
          <% if (review.getImagePath1() != null && !review.getImagePath1().isEmpty()) { %>
          <img src="<%= request.getContextPath() + "/" + review.getImagePath1() %>" alt="Bike Image 1" class="review-image">
          <% } %>
          <% if (review.getImagePath2() != null && !review.getImagePath2().isEmpty()) { %>
          <img src="<%= request.getContextPath() + "/" + review.getImagePath2() %>" alt="Bike Image 2" class="review-image">
          <% } %>
        </div>
        <!-- Update Form Positioned Right Below the Review -->
        <%
          String action = request.getParameter("action");
          String reviewId = request.getParameter("reviewId");
          String bikeName = request.getParameter("bikeName");
          if ("update".equals(action) && reviewId != null && reviewId.equals(review.getReviewId()) && bikeName != null && bikeName.equals(review.getBikeName())) {
            PublicReview reviewToUpdate = review;
        %>
        <div class="update-form active">
          <h3 class="text-2xl font-semibold mb-4">Update Review for <%= bikeName %></h3>
          <form action="AdminReviewServlet" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="reviewId" value="<%= reviewId %>">
            <input type="hidden" name="bikeName" value="<%= bikeName %>">
            <div class="mb-3">
              <label for="feedback_<%= reviewId %>" class="form-label">Feedback</label>
              <textarea class="form-control" id="feedback_<%= reviewId %>" name="feedback" required><%= reviewToUpdate.getFeedback() %></textarea>
              <div class="invalid-feedback">Please provide feedback.</div>
            </div>
            <div class="mb-3">
              <label for="rating_<%= reviewId %>" class="form-label">Rating (1-5)</label>
              <input type="number" class="form-control" id="rating_<%= reviewId %>" name="rating" min="1" max="5" value="<%= reviewToUpdate.getRating() %>" required>
              <div class="invalid-feedback">Please provide a rating between 1 and 5.</div>
            </div>
            <div class="mb-3">
              <label for="image1_<%= reviewId %>" class="form-label">Image 1 (optional)</label>
              <% if (reviewToUpdate.getImagePath1() != null && !reviewToUpdate.getImagePath1().isEmpty()) { %>
              <img src="<%= request.getContextPath() + "/" + reviewToUpdate.getImagePath1() %>" alt="Current Image 1" class="image-preview">
              <% } %>
              <input type="file" class="form-control" id="image1_<%= reviewId %>" name="image1" accept="image/*">
            </div>
            <div class="mb-3">
              <label for="image2_<%= reviewId %>" class="form-label">Image 2 (optional)</label>
              <% if (reviewToUpdate.getImagePath2() != null && !reviewToUpdate.getImagePath2().isEmpty()) { %>
              <img src="<%= request.getContextPath() + "/" + review.getImagePath2() %>" alt="Current Image 2" class="image-preview">
              <% } %>
              <input type="file" class="form-control" id="image2_<%= reviewId %>" name="image2" accept="image/*">
            </div>
            <button type="submit" class="btn btn-primary btn-custom text-white">Save Changes</button>
            <a href="AdminReviews.jsp" class="btn btn-secondary btn-custom ms-2">Cancel</a>
          </form>
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
    <% } %>
  </div>
  <% } %>
</section>

<!-- JavaScript for form validation -->
<script>
  // Bootstrap form validation
  (function () {
    'use strict'
    var forms = document.querySelectorAll('.needs-validation')
    Array.prototype.slice.call(forms)
            .forEach(function (form) {
              form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                  event.preventDefault()
                  event.stopPropagation()
                }
                form.classList.add('was-validated')
              }, false)
            })
  })()
</script>
</body>
</html>