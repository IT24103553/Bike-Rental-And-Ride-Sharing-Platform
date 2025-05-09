<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, BikeManagement.ReviewsManagement.PublicReview, java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE - Reviews & Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0==" crossorigin="anonymous">
    <style>
        body { background-color: #f0f0f0; }
        .btn-primary { background-color: #f76b64; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
        .btn-primary:hover { background-color: #fa8a76; transform: scale(1.05); }
        .btn-edit { background-color: #17a2b8; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
        .btn-edit:hover { background-color: #138496; transform: scale(1.05); }
        .btn-danger { background-color: #dc3545; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
        .btn-danger:hover { background-color: #c82333; transform: scale(1.05); }
        .review-card { background-color: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-bottom: 15px; }
        .star-rating { color: #f76b64; font-size: 1.2rem; }
        .review-images { display: flex; flex-direction: row; gap: 10px; }
        .review-image { max-width: 150px; }
        .dropdown-menu { min-width: 150px; }
        nav .text-4xl { font-size: 2.75rem; }
        nav ul li a { font-size: 1.125rem; }
        nav .bg-white.text-f76b64 { padding: 0.55rem 1.2rem; font-size: 1.125rem; color: #f76b64; }
        #mobile-menu a, #mobile-menu button { font-size: 1.125rem; }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="bg-[#f76b64] shadow-lg">
    <div class="container mx-auto px-6 py-4 flex justify-between items-center">
        <a href="index.jsp" class="text-4xl font-extrabold text-black">JOY-RIDE</a>
        <div class="hidden lg:flex items-center w-full max-w-lg">
            <label for="searchInput" class="sr-only">Search bikes or rides</label>
            <input type="text" id="searchInput" placeholder="Search bikes or rides..." class="w-full px-4 py-2 rounded-l-lg focus:outline-none"/>
            <button class="bg-white text-[#f76b64] px-4 py-2 rounded-r-lg hover:bg-gray-200 transition">Search</button>
        </div>
        <ul class="hidden lg:flex space-x-6">
            <li><a href="index.jsp" class="text-white hover:underline">Home</a></li>
            <li><a href="#" class="text-white hover:underline">About</a></li>
            <li><a href="#" class="text-white hover:underline">Services</a></li>
            <li><a href="BikeListServlet" class="text-white hover:underline">Bikes</a></li>
            <li><a href="#" class="text-white hover:underline">Contact</a></li>
        </ul>
        <div class="hidden lg:flex items-center gap-4">
            <% String username = (String) session.getAttribute("username"); if (username != null) { %>
            <div class="dropdown">
                <button class="bg-transparent text-white px-2 py-2 rounded-lg hover:bg-gray-200 transition" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="fas fa-user-circle fa-2x"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileDropdown">
                    <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                    <li><a class="dropdown-item" href="SearchMembers.jsp">Search Members</a></li>
                    <li><a class="dropdown-item" href="ChangePassword.jsp">Change Password</a></li>
                    <li><a class="dropdown-item" href="LogoutServlet">Logout</a></li>
                </ul>
            </div>
            <% } else { %>
            <a href="Login.jsp" class="bg-white text-f76b64 px-4 py-2 rounded-lg hover:bg-gray-200 transition">Login/Sign Up</a>
            <% } %>
        </div>
        <button id="menu-toggle" class="lg:hidden text-white focus:outline-none">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
            </svg>
        </button>
    </div>
    <div id="mobile-menu" class="lg:hidden hidden bg-[#f76b64] p-4 space-y-4">
        <label for="mobileSearchInput" class="sr-only">Search</label>
        <input type="text" id="mobileSearchInput" placeholder="Search..." class="w-full px-4 py-2 rounded-lg focus:outline-none"/>
        <a href="index.jsp" class="block text-white hover:underline">Home</a>
        <a href="#" class="block text-white hover:underline">About</a>
        <a href="#" class="block text-white hover:underline">Services</a>
        <a href="BikeListServlet" class="block text-white hover:underline">Bikes</a>
        <a href="#" class="block text-white hover:underline">Contact</a>
        <% if (username != null) { %>
        <div class="dropdown">
            <button class="bg-transparent text-white px-2 py-2 rounded-lg hover:bg-gray-200 transition block w-full text-left" id="mobileProfileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-user-circle fa-lg mr-2"></i> Profile
            </button>
            <ul class="dropdown-menu" aria-labelledby="mobileProfileDropdown">
                <li><a class="dropdown-item" href="profile.jsp">Profile</a></li>
                <li><a class="dropdown-item" href="SearchMembers.jsp">Search Members</a></li>
                <li><a class="dropdown-item" href="ChangePassword.jsp">Change Password</a></li>
                <li><a class="dropdown-item" href="LogoutServlet">Logout</a></li>
            </ul>
        </div>
        <% } else { %>
        <a href="Login.jsp" class="block bg-white text-f76b64 text-center px-4 py-2 rounded-lg hover:bg-gray-200 transition">Login/Sign Up</a>
        <% } %>
    </div>
</nav>

<!-- Review Section -->
<section class="container mx-auto px-6 py-16">
    <%
        String bikeName = (String) request.getAttribute("bikeName");
        @SuppressWarnings("unchecked")
        List<PublicReview> reviews = (List<PublicReview>) request.getAttribute("reviews");
        String editReviewId = (String) request.getAttribute("editReviewId");
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
    <div class="alert alert-danger" role="alert">
        <%= errorMessage %>
    </div>
    <%
        }
    %>

    <h2 class="text-3xl font-bold mb-6">Reviews & Feedback for <%= bikeName %></h2>

    <% if (username != null) { %>
    <button class="btn-primary text-white mb-4" data-bs-toggle="modal" data-bs-target="#addReviewModal">Add Review</button>
    <% } else { %>
    <p class="text-red-600 mb-4">Please log in to add a review.</p>
    <a href="Login.jsp" class="btn-primary text-white mb-4">Login</a>
    <% } %>

    <div class="review-list">
        <% if (reviews != null && !reviews.isEmpty()) { %>
        <p>Found <%= reviews.size() %> reviews:</p>
        <% for (PublicReview review : reviews) { %>
        <div class="review-card">
            <div class="flex justify-between items-center">
                <p><strong><%= review.getUserAccountName() %></strong> <span class="star-rating">★ <%= review.getRating() %>/5</span></p>
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
            <% if (username != null && username.equalsIgnoreCase(review.getUserAccountName())) { %>
            <div class="flex space-x-2 mt-2">
                <button class="btn-edit text-white" data-bs-toggle="modal" data-bs-target="#editReviewModal" data-review-id="<%= review.getReviewId() %>" data-review-feedback="<%= review.getFeedback() %>" data-review-rating="<%= review.getRating() %>" data-review-image1="<%= review.getImagePath1() %>" data-review-image2="<%= review.getImagePath2() %>">Update</button>
                <a href="ReviewServlet?action=delete&reviewId=<%= URLEncoder.encode(review.getReviewId(), "UTF-8") %>&bikeName=<%= URLEncoder.encode(bikeName, "UTF-8") %>" class="btn-danger text-white" onclick="return confirm('Are you sure you want to delete this review?');">Delete</a>
            </div>
            <% } %>
        </div>
        <% } %>
        <% } else { %>
        <p>No reviews yet.</p>
        <% } %>
    </div>

    <!-- Add Review Modal -->
    <div class="modal fade" id="addReviewModal" tabindex="-1" aria-labelledby="addReviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-2xl font-bold" id="addReviewModalLabel">Add Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="ReviewServlet" method="POST" enctype="multipart/form-data" id="addReviewForm">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="bikeName" value="<%= bikeName != null ? URLEncoder.encode(bikeName, "UTF-8") : "" %>">
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Enter your feedback</label>
                            <textarea class="form-control" name="feedback" id="feedback" rows="3" required></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Rate the bike (1-5 stars)</label>
                            <input type="number" class="form-control" name="rating" id="rating" min="1" max="5" required>
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Upload Bike Image 1</label>
                            <input type="file" class="form-control" name="image1" accept="image/*">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Upload Bike Image 2</label>
                            <input type="file" class="form-control" name="image2" accept="image/*">
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn-primary text-white">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Review Modal -->
    <div class="modal fade" id="editReviewModal" tabindex="-1" aria-labelledby="editReviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title text-2xl font-bold" id="editReviewModalLabel">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="ReviewServlet" method="POST" enctype="multipart/form-data" id="editReviewForm">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="bikeName" id="editBikeName" value="">
                        <input type="hidden" name="reviewId" id="editReviewId" value="">
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Feedback</label>
                            <textarea class="form-control" name="feedback" id="editFeedback" rows="3" required></textarea>
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Rating (1-5)</label>
                            <input type="number" class="form-control" name="rating" id="editRating" min="1" max="5" required>
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Current Image 1</label>
                            <div id="currentImage1"></div>
                            <label class="block text-gray-700 font-semibold mb-2">Upload New Bike Image 1 (optional)</label>
                            <input type="file" class="form-control" name="image1" accept="image/*">
                        </div>
                        <div class="mb-4">
                            <label class="block text-gray-700 font-semibold mb-2">Current Image 2</label>
                            <div id="currentImage2"></div>
                            <label class="block text-gray-700 font-semibold mb-2">Upload New Bike Image 2 (optional)</label>
                            <input type="file" class="form-control" name="image2" accept="image/*">
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn-primary text-white">Update</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- JavaScript to handle form validation, menu toggle, and modal population -->
<script>
    const menuToggle = document.getElementById('menu-toggle');
    const mobileMenu = document.getElementById('mobile-menu');
    menuToggle.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));

    // Populate edit modal when "Update" button is clicked
    document.querySelectorAll('.btn-edit').forEach(button => {
        button.addEventListener('click', function() {
            const reviewId = this.getAttribute('data-review-id');
            const feedback = this.getAttribute('data-review-feedback');
            const rating = this.getAttribute('data-review-rating');
            const image1 = this.getAttribute('data-review-image1');
            const image2 = this.getAttribute('data-review-image2');
            const bikeName = '<%= bikeName != null ? URLEncoder.encode(bikeName, "UTF-8") : "" %>';

            document.getElementById('editReviewId').value = reviewId;
            document.getElementById('editBikeName').value = bikeName;
            document.getElementById('editFeedback').value = feedback;
            document.getElementById('editRating').value = rating;

            const currentImage1Div = document.getElementById('currentImage1');
            currentImage1Div.innerHTML = image1 ? `<img src="<%= request.getContextPath() %>/${image1}" alt="Current Bike Image 1" class="review-image mb-2">` : '<p>No image uploaded</p>';

            const currentImage2Div = document.getElementById('currentImage2');
            currentImage2Div.innerHTML = image2 ? `<img src="<%= request.getContextPath() %>/${image2}" alt="Current Bike Image 2" class="review-image mb-2">` : '<p>No image uploaded</p>';

            console.log('Modal triggered for review ID:', reviewId); // Debug log
        });
    });

    const forms = document.querySelectorAll('form[id]');
    forms.forEach(form => {
        form.addEventListener('submit', function(event) {
            const feedback = form.querySelector('textarea[name="feedback"]')?.value.trim();
            const rating = form.querySelector('input[name="rating"]')?.value;

            if (!feedback) {
                event.preventDefault();
                alert('Please enter your feedback.');
                return;
            }

            if (!rating || rating < 1 || rating > 5) {
                event.preventDefault();
                alert('Please enter a rating between 1 and 5.');
                return;
            }
        });
    });
</script>

<!-- Footer -->
<!--
<footer class="bg-[#f76b64] text-white py-8">
    <div class="container mx-auto px-6 flex flex-col md:flex-row justify-between items-center">
        <div class="mb-6 md:mb-0">
            <h3 class="font-semibold text-lg">Quick Links</h3>
            <ul class="mt-4 space-y-2">
                <li><a href="#" class="hover:underline">About Us</a></li>
                <li><a href="#" class="hover:underline">Privacy Policy</a></li>
                <li><a href="#" class="hover:underline">Terms & Conditions</a></li>
            </ul>
        </div>
        <div class="mb-6 md:mb-0">
            <h3 class="font-semibold text-lg">Contact Info</h3>
            <ul class="mt-4 space-y-2">
                <li>Whatsapp</li>
                <li><a href="tel:+94703983620" class="hover:underline">+94 70 398 3620</a></li>
            </ul>
        </div>
        <div class="text-center md:text-right mt-6 md:mt-0">
            <p>© 2025 JOY-RIDE. All rights reserved.</p>
            <ul class="mt-4 space-y-2">
                <li><a href="#" class="hover:underline">Reviews</a></li>
            </ul>
        </div>
    </div>
</footer> -->
</body>
</html>