<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, BikeManagement.ReviewsManagement.PublicReview, java.io.BufferedReader, java.io.FileReader" %>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE - All Reviews</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0==" crossorigin="anonymous">
  <style>
    body { background-color: #f0f0f0; }
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

<!-- All Reviews Section -->
<section class="container mx-auto px-6 py-16">
  <h2 class="text-3xl font-bold mb-6 text-center">All User Reviews</h2>

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
  <%
    }

    // Display reviews grouped by bikeName
    if (reviewsByBike.isEmpty()) {
  %>
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
      </div>
      <% } %>
    </div>
    <% } %>
  </div>
  <% } %>
</section>

<!-- JavaScript for menu toggle -->
<script>
  const menuToggle = document.getElementById('menu-toggle');
  const mobileMenu = document.getElementById('mobile-menu');
  menuToggle.addEventListener('click', () => mobileMenu.classList.toggle('hidden'));
</script>

<!-- Footer -->
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
        <li><a href="AllReviews.jsp" class="hover:underline">Reviews</a></li>
      </ul>
    </div>
  </div>
</footer>
</body>
</html>