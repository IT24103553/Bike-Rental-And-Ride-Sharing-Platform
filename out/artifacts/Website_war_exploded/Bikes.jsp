<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE - Bikes</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            background-color: #f0f0f0;
        }

        .btn-primary {
            background-color: #f76b64;
            border: none;
            padding: 0.75rem 2rem;
            font-size: 1.25rem;
            font-weight: 700;
            border-radius: 50px;
            transition: transform 0.3s ease, background-color 0.3s ease;
        }

        .btn-primary:hover {
            background-color: #fa8a76;
            transform: scale(1.05);
        }

        .card {
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: scale(1.03);
        }

        .form-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .bike-listings {
            max-height: 1200px;
            overflow-y: auto;
            padding-right: 1rem;
        }

        /* Navigation Bar Adjustments from index.jsp */
        .dropdown-menu {
            min-width: 150px;
        }
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
<body>
<!-- Navigation Bar -->
<nav class="bg-[#f76b64] shadow-lg">
    <div class="container mx-auto px-6 py-4 flex justify-between items-center">
        <a href="index.jsp" class="text-4xl font-extrabold text-black">JOY-RIDE</a>
        <div class="hidden lg:flex items-center w-full max-w-lg">
            <label for="searchInput" class="sr-only">Search bikes or rides</label>
            <input type="text" id="searchInput" placeholder="Search bikes or rides..."
                   class="w-full px-4 py-2 rounded-l-lg focus:outline-none"/>
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
                <button class="bg-transparent text-white px-2 py-2 rounded-lg hover:bg-gray-200 transition"
                        type="button" id="profileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
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
            <a href="Login.jsp" class="bg-white text-[#f76b64] px-4 py-2 rounded-lg hover:bg-gray-200 transition">Login/Sign
                Up</a>
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
        <input type="text" id="mobileSearchInput" placeholder="Search..."
               class="w-full px-4 py-2 rounded-lg focus:outline-none"/>
        <a href="index.jsp" class="block text-white hover:underline">Home</a>
        <a href="#" class="block text-white hover:underline">About</a>
        <a href="#" class="block text-white hover:underline">Services</a>
        <a href="BikeListServlet" class="block text-white hover:underline">Bikes</a>
        <a href="#" class="block text-white hover:underline">Contact</a>
        <% if (username != null) { %>
        <div class="dropdown">
            <button class="bg-transparent text-white px-2 py-2 rounded-lg hover:bg-gray-200 transition block w-full text-left"
                    type="button" id="mobileProfileDropdown" data-bs-toggle="dropdown" aria-expanded="false">
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
        <a href="Login.jsp"
           class="block bg-white text-[#f76b64] text-center px-4 py-2 rounded-lg hover:bg-gray-200 transition">Login/Sign
            Up</a>
        <% } %>
    </div>
</nav>

<!-- Bikes Section -->
<section class="container mx-auto px-6 py-16">
    <div class="flex justify-between items-center mb-8">
        <h2 class="text-3xl font-bold">Available Bikes</h2>
        <%
            if (username != null) {
        %>
        <button class="btn-primary text-white" data-bs-toggle="modal" data-bs-target="#addBikeModal">Add Bikes</button>
        <%
        } else {
        %>
        <a href="Login.jsp" class="btn-primary text-white">Add Bikes</a>
        <%
            }
        %>
    </div>

    <!-- Display Error Message if Any -->
    <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (errorMessage != null) {
    %>
    <div class="alert alert-danger" role="alert">
        <%= errorMessage %>
    </div>
    <%
        }
    %>

    <!-- Display Success Message if Any -->
    <%
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
    %>
    <div class="alert alert-success" role="alert">
        <%= successMessage %>
    </div>
    <%
            session.removeAttribute("successMessage"); // Clear the message after displaying
        }
    %>

    <!-- Debug Information -->
    <%
        List<String[]> bikeDataList = (List<String[]>) request.getAttribute("bikeDataList");
    %>
    <p class="text-gray-600 mb-4">Total bikes loaded: <%= bikeDataList != null ? bikeDataList.size() : 0 %></p>

    <!-- Add Bike Modal (Only accessible if logged in) -->
    <div class="modal fade" id="addBikeModal" tabindex="-1" aria-labelledby="addBikeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content form-container">
                <div class="modal-header">
                    <h5 class="modal-title text-2xl font-bold" id="addBikeModalLabel">Add a New Bike</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="AddBikeServlet" method="POST" enctype="multipart/form-data">
                        <div class="mb-4">
                            <label for="bikeName" class="block text-gray-700 font-semibold mb-2">Bike Name</label>
                            <input type="text" class="form-control" id="bikeName" name="bikeName"
                                   placeholder="Enter bike name" required>
                        </div>
                        <div class="mb-4">
                            <label for="bikePhoto" class="block text-gray-700 font-semibold mb-2">Bike Photo</label>
                            <input type="file" class="form-control" id="bikePhoto" name="bikePhoto" accept="image/*"
                                   required>
                        </div>
                        <div class="mb-4">
                            <label for="bikePrice" class="block text-gray-700 font-semibold mb-2">Bike Price (per
                                hour)</label>
                            <input type="number" class="form-control" id="bikePrice" name="bikePrice" step="0.01"
                                   min="0" placeholder="Enter price" required>
                        </div>
                        <div class="mb-4">
                            <label for="ownerName" class="block text-gray-700 font-semibold mb-2">Bike Owner
                                Name</label>
                            <input type="text" class="form-control" id="ownerName" name="ownerName"
                                   placeholder="Enter owner name" required>
                        </div>
                        <div class="mb-4">
                            <label for="availability" class="block text-gray-700 font-semibold mb-2">Bike
                                Availability</label>
                            <select class="form-control" id="availability" name="availability" required>
                                <option value="Available">Available</option>
                                <option value="Not Available">Not Available</option>
                            </select>
                        </div>
                        <div class="text-center">
                            <button type="submit" class="btn-primary text-white">Create Bike</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Dynamic Bike Listings -->
    <div class="bike-listings">
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            <%
                if (bikeDataList != null && !bikeDataList.isEmpty()) {
                    for (String[] bikeData : bikeDataList) {
            %>
            <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col card">
                <div class="h-60 overflow-hidden">
                    <img src="image/<%= bikeData[1] %>" alt="<%= bikeData[0] %>"
                         class="w-full h-full object-cover">
                </div>
                <div class="p-4 flex flex-col flex-grow">
                    <h3 class="text-xl font-semibold"><%= bikeData[0] %>
                    </h3>
                    <p class="text-gray-700 mt-2">Price: $<%= bikeData[2] %>/hour</p>
                    <p class="text-gray-700">Owner: <%= bikeData[3] %>
                    </p>
                    <p class="text-gray-700">Availability:
                        <span class="<%= bikeData[4].equals("Available") ? "text-green-600" : "text-red-600" %>">
                            <%= bikeData[4] %>
                        </span>
                    </p>
                    <%
                        if (username != null) {
                    %>
                    <a href="BikeDetailsServlet?bikeName=<%= java.net.URLEncoder.encode(bikeData[0], "UTF-8") %>"
                       class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 font-bold hover:bg-[#fa8a76] transition text-center">
                        Bike Details
                    </a>
                    <%
                    } else {
                    %>
                    <a href="Login.jsp"
                       class="bg-[#f76b64] text-white px-4 py-2 rounded-lg mt-4 font-bold hover:bg-[#fa8a76] transition text-center">
                        Bike Details (Login Required)
                    </a>
                    <%
                        }
                    %>
                </div>
            </div>
            <%
                }
            } else {
            %>
            <p class="text-center text-gray-700">No bikes available at the moment.</p>
            <%
                }
            %>
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
                <!--<li><a href="Review.jsp" class="hover:underline">Reviews</a></li>  -->
            </ul>
        </div>
    </div>
</footer>
</body>
</html>