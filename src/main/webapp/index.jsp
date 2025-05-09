<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE - Bike Rental & Ride Sharing</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    #hero {
      transition: background-image 1s ease-in-out;
      position: relative;
      min-height: 600px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    .dropdown-menu {
      min-width: 150px;
    }
    .hero-overlay {
      position: absolute;
      inset: 0;
      background: linear-gradient(to bottom, rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.4));
    }
    .welcome-message {
      font-size: 3.3rem; /* Increased from 3rem (~10%) */
      font-weight: 800;
      color: #fff;
      text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.5);
      margin-bottom: 1.5rem;
      opacity: 0;
      animation: fadeInDown 1s ease forwards;
    }
    .hero-heading {
      font-size: 3.8rem; /* Increased from 3.5rem (~8.5%) */
      font-weight: 900;
      color: #fff;
      text-shadow: 3px 3px 6px rgba(0, 0, 0, 0.5);
      margin-bottom: 1.5rem;
      opacity: 0;
      animation: fadeInDown 1s ease forwards 0.5s;
    }
    .hero-subtext {
      font-size: 1.25rem; /* Increased from 1.125rem (~11%) */
      color: #f0f0f0;
      margin-bottom: 2rem;
      opacity: 0;
      animation: fadeInUp 1s ease forwards 1s;
    }
    .hero-cta {
      background-color: #f76b64;
      color: #fff;
      padding: 0.85rem 2.2rem; /* Increased from 0.75rem 2rem */
      font-size: 1.375rem; /* Increased from 1.25rem (~10%) */
      font-weight: 700;
      border-radius: 50px;
      transition: transform 0.3s ease, background-color 0.3s ease;
      opacity: 0;
      animation: fadeInUp 1s ease forwards 1.5s;
    }
    .hero-cta:hover {
      background-color: #fa8a76;
      transform: scale(1.05);
    }

    /* Animations */
    @keyframes fadeInDown {
      0% {
        opacity: 0;
        transform: translateY(-20px);
      }
      100% {
        opacity: 1;
        transform: translateY(0);
      }
    }
    @keyframes fadeInUp {
      0% {
        opacity: 0;
        transform: translateY(20px);
      }
      100% {
        opacity: 1;
        transform: translateY(0);
      }
    }

    /* Navigation Bar Adjustments */
    nav .text-4xl {
      font-size: 2.75rem; /* Increased from ~2.5rem (text-4xl) to ~2.75rem (~10%) */
    }
    nav ul li a {
      font-size: 1.125rem; /* Increased from default ~1rem (~12.5%) */
    }
    nav .bg-white.text-#f76b64 {
      padding: 0.55rem 1.2rem; /* Increased from 0.5rem 1rem */
      font-size: 1.125rem; /* Increased from default ~1rem (~12.5%) */
    }
    #mobile-menu a, #mobile-menu button {
      font-size: 1.125rem; /* Increased from default ~1rem (~12.5%) */
    }
  </style>
</head>
<body class="bg-gray-100">
<!-- Navigation Bar -->
<nav class="bg-[#f76b64] shadow-lg">
  <div class="container mx-auto px-6 py-4 flex justify-between items-center">
    <a href="index.jsp" class="text-4xl font-extrabold text-black">JOY-RIDE</a>
    <div class="hidden lg:flex items-center w-full max-w-lg">
      <input type="text" placeholder="Search bikes or rides..." class="w-full px-4 py-2 rounded-l-lg focus:outline-none" />
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
      <%
        String username = (String) session.getAttribute("username");
        if (username != null) {
      %>
      <div class="dropdown">
        <button class="bg-transparent text-white px-2 py-2 rounded-lg hover:bg-gray-200 transition" type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
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
      <a href="Login.jsp" class="bg-white text-[#f76b64] px-4 py-2 rounded-lg hover:bg-gray-200 transition">Login/Sign Up</a>
      <% } %>
    </div>
    <button id="menu-toggle" class="lg:hidden text-white focus:outline-none">
      <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
      </svg>
    </button>
  </div>
  <div id="mobile-menu" class="lg:hidden hidden bg-[#f76b64] p-4 space-y-4">
    <input type="text" placeholder="Search..." class="w-full px-4 py-2 rounded-lg focus:outline-none" />
    <a href="index.jsp" class="block text-white hover:underline">Home</a>
    <a href="#" class="block text-white hover:underline">About</a>
    <a href="#" class="block text-white hover:underline">Services</a>
    <a href="BikeListServlet" class="block text-white hover:underline">Bikes</a>
    <a href="#" class="block text-white hover:underline">Contact</a>
    <% if (username != null) { %>
    <div class="dropdown">
      <button class="bg-transparent text-white px-2 py-2 rounded-lg hover:bg-gray-200 transition block w-full text-left" type="button" id="mobileProfileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
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
    <a href="Login.jsp" class="block bg-white text-[#f76b64] text-center px-4 py-2 rounded-lg hover:bg-gray-200 transition">Login/Sign Up</a>
    <% } %>
  </div>
</nav>

<!-- Hero Section -->
<section id="hero" class="relative bg-cover bg-center bg-no-repeat text-white">
  <div class="hero-overlay">
    <img src="image/1.jpg" alt="Scooter-old" class="w-full h-full object-cover">
  </div>
  <div class="container mx-auto px-6 relative z-10 flex flex-col items-center justify-center min-h-[600px] text-center">
    <div class="max-w-3xl">
      <% if (username != null) { %>
      <h1 class="welcome-message">Welcome, <%= username %>!</h1>
      <% } %>
      <h1 class="hero-heading">Bike Rental and Ride Sharing Platform</h1>
      <p class="hero-subtext">JOY-RIDE offers a seamless, user-friendly experience. Book rides, manage fleets, and enjoy hassle-free operations.</p>
      <a href="BikeListServlet" class="hero-cta">Book a Ride</a>
    </div>
  </div>
</section>

<!-- Background Image Slider Script -->
<script>
  const images = ['image/1.jpg', 'image/2.jpg', 'image/3.jpg'];
  let index = 0;
  const heroSection = document.getElementById('hero');

  function changeBackground() {
    heroSection.style.backgroundImage = `url('${images[index]}')`;
    index = (index + 1) % images.length;
  }

  setInterval(changeBackground, 6000);
  changeBackground();

  // Prevent back navigation from index.jsp by replacing history and handling popstate
  window.history.replaceState(null, null, 'index.jsp');
  window.history.pushState(null, null, 'index.jsp');
  window.onpopstate = function(event) {
    window.history.pushState(null, null, 'index.jsp');
    window.location.href = 'index.jsp';
  };
</script>

<!-- Featured Bikes Section -->
<section class="container mx-auto px-6 py-16">
  <h2 class="text-3xl font-bold text-center mb-8">Featured Bikes & Ride Options</h2>
  <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col">
      <div class="h-60 overflow-hidden">
        <img src="image/6.jpg" alt="Electric Scooter" class="w-full h-full object-cover">
      </div>
      <div class="p-4 flex flex-col flex-grow">
        <h3 class="text-xl font-semibold">Electric Scooter</h3>
        <p class="text-gray-700 mt-2 flex-grow">Electric bike for a smooth ride.</p>
        <a href="BikeListServlet" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 font-bold hover:bg-[#fa8a76] transition text-center">Rent Now</a>
      </div>
    </div>
    <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col">
      <div class="h-60 overflow-hidden">
        <img src="image/5.jpg" alt="Scooter-Dio" class="w-full h-full object-cover">
      </div>
      <div class="p-4 flex flex-col flex-grow">
        <h3 class="text-xl font-semibold">Scooter-Dio</h3>
        <p class="text-gray-700 mt-2 flex-grow">Classic scooter for urban commuting.</p>
        <a href="BikeListServlet" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 font-bold hover:bg-[#fa8a76] transition text-center">Rent Now</a>
      </div>
    </div>
    <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col">
      <div class="h-60 overflow-hidden">
        <img src="image/4.jpg" alt="Motor Bike" class="w-full h-full object-cover">
      </div>
      <div class="p-4 flex flex-col flex-grow">
        <h3 class="text-xl font-semibold">Motor Bike</h3>
        <p class="text-gray-700 mt-2 flex-grow">Standard bike for all-purpose use.</p>
        <a href="BikeListServlet" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 font-bold hover:bg-[#fa8a76] transition text-center">Rent Now</a>
      </div>
    </div>
  </div>
</section>

<!-- Mobile Menu Toggle Script -->
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
        <li><a href="AdminReviews.jsp" class="hover:underline">Privacy Policy</a></li>
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