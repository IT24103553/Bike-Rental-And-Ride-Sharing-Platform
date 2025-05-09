<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE - Bike Details</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0==" crossorigin="anonymous">
  <style>
    body { background-color: #f0f0f0; }
    .btn-primary { background-color: #f76b64; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
    .btn-primary:hover { background-color: #fa8a76; transform: scale(1.05); }
    .btn-danger { background-color: #dc3545; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
    .btn-danger:hover { background-color: #c82333; transform: scale(1.05); }
    .btn-success { background-color: #28a745; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
    .btn-success:hover { background-color: #218838; transform: scale(1.05); }
    .btn-info { background-color: #17a2b8; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
    .btn-info:hover { background-color: #138496; transform: scale(1.05); }
    .btn-warning { background-color: #ffc107; border: none; padding: 0.5rem 1.5rem; font-size: 1rem; font-weight: 700; border-radius: 50px; transition: transform 0.3s ease, background-color 0.3s ease; }
    .btn-warning:hover { background-color: #e0a800; transform: scale(1.05); }
    .countdown-section { background-color: #f9f9f9; border: 1px solid #ddd; border-radius: 8px; padding: 15px; margin-top: 10px; text-align: center; }
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

<!-- Bike Details Section -->
<section class="container mx-auto px-6 py-16">
  <%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");
    if (errorMessage != null) {
  %>
  <div class="alert alert-danger" role="alert">
    <%= errorMessage %>
  </div>
  <%
    }
    if (successMessage != null) {
  %>
  <div class="alert alert-success" role="alert">
    <%= successMessage %>
  </div>
  <%
    }
  %>

  <%
    String[] bikeData = (String[]) request.getAttribute("bikeData");
    if (bikeData != null) {
      String bikeName = bikeData[0];
      String ownerUsername = bikeData[5];
      boolean isOwner = username != null && username.equals(ownerUsername);
      Boolean isRented = (Boolean) session.getAttribute("isRented_" + bikeName);
      String renterUsername = (String) session.getAttribute("renterUsername_" + bikeName);
      Long rentalEndTime = (Long) session.getAttribute("rentalEndTime_" + bikeName);
      boolean rented = isRented != null && isRented && rentalEndTime != null && rentalEndTime > System.currentTimeMillis();
  %>
  <div class="bg-white shadow-lg rounded-lg overflow-hidden flex flex-col max-w-md mx-auto">
    <div class="h-64 overflow-hidden">
      <img src="image/<%= bikeData[1] %>" alt="<%= bikeName %>" class="w-full h-full object-cover">
    </div>
    <div class="p-4 flex flex-col">
      <h2 class="text-2xl font-bold mb-3"><%= bikeName %></h2>
      <p class="text-gray-700 text-sm mb-1">Price: $<%= bikeData[2] %>/hour</p>
      <p class="text-gray-700 text-sm mb-1">Owner: <%= bikeData[3] %></p>
      <p class="text-gray-700 text-sm mb-3">Availability:
        <span class="<%= bikeData[4].equals("Available") ? "text-green-600" : "text-red-600" %>">
          <%= bikeData[4] %>
        </span>
      </p>
      <div class="flex space-x-3">
        <%
          if (isOwner) {
        %>
        <button class="btn-primary text-white" data-bs-toggle="modal" data-bs-target="#updateBikeModal">Update</button>
        <form action="DeleteBikeServlet" method="POST" onsubmit="return confirm('Are you sure you want to delete this bike?');">
          <input type="hidden" name="bikeName" value="<%= URLEncoder.encode(bikeName, "UTF-8") %>">
          <button type="submit" class="btn-danger text-white">Delete</button>
        </form>
        <a href="BikeRequestsServlet?bikeName=<%= URLEncoder.encode(bikeName, "UTF-8") %>" class="btn-info text-white">Bike Requests</a>
        <%
        } else {
          boolean isRentedByCurrentUser = username != null && username.equals(renterUsername);
          if (isRentedByCurrentUser) {
        %>
        <p class="text-red-600 font-semibold">You have already rented this bike.</p>
        <% } else if (bikeData[4].equals("Available")) { %>
        <a href="RentBikeServlet?bikeName=<%= URLEncoder.encode(bikeName, "UTF-8") %>" class="btn-success text-white">Rent Now</a>
        <% } else { %>
        <form action="JoinQueueServlet" method="POST">
          <input type="hidden" name="bikeName" value="<%= URLEncoder.encode(bikeName, "UTF-8") %>">
          <button type="submit" class="btn-warning text-white">Join Queue</button>
        </form>
        <% } %>
        <a href="ReviewServlet?bikeName=<%= URLEncoder.encode(bikeName, "UTF-8") %>" class="btn-info text-white">Reviews & Feedback</a>
        <%
          }
        %>
      </div>

      <!-- Countdown Section (Visible when bike is rented) -->
      <%
        if (rented) {
      %>
      <div class="countdown-section">
        <h3 class="text-xl font-semibold mb-3">Rental Status</h3>
        <p>Rented by: <%= renterUsername != null ? renterUsername : "Unknown" %></p>
        <p id="countdown-<%= URLEncoder.encode(bikeName, "UTF-8") %>">Time Left: Calculating...</p>
        <script>
          function startCountdown(rentalEndTime, elementId, bikeName) {
            const countdownElement = document.getElementById(elementId);
            if (!countdownElement) {
              console.error('Countdown element not found for bike:', bikeName);
              return;
            }
            if (!rentalEndTime || isNaN(rentalEndTime) || rentalEndTime <= Date.now()) {
              console.error('Invalid rental end time:', rentalEndTime);
              countdownElement.textContent = "Rental period has ended.";
              fetch('EndRentalServlet', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'bikeName=' + encodeURIComponent(bikeName)
              })
                      .then(response => response.text())
                      .then(data => {
                        console.log('EndRentalServlet response:', data);
                        setTimeout(() => window.location.reload(), 1000);
                      })
                      .catch(error => console.error('Error calling EndRentalServlet:', error));
              return;
            }

            console.log('Starting countdown for bike:', bikeName, 'with end time:', rentalEndTime);

            function updateCountdown() {
              const now = Date.now();
              const timeRemaining = Math.max(0, rentalEndTime - now);

              if (timeRemaining <= 0) {
                countdownElement.textContent = "Rental period has ended.";
                fetch('EndRentalServlet', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                  body: 'bikeName=' + encodeURIComponent(bikeName)
                })
                        .then(response => {
                          if (!response.ok) throw new Error('Failed to end rental: ' + response.statusText);
                          return response.text();
                        })
                        .then(data => {
                          console.log('EndRentalServlet response:', data);
                          setTimeout(() => window.location.reload(), 1000);
                        })
                        .catch(error => {
                          console.error('Error ending rental:', error);
                          countdownElement.textContent = "Error ending rental: " + error.message;
                        });
                return false;
              }

              const days = Math.floor(timeRemaining / (1000 * 60 * 60 * 24));
              const hours = Math.floor((timeRemaining % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
              const minutes = Math.floor((timeRemaining % (1000 * 60 * 60)) / (1000 * 60));
              const seconds = Math.floor((timeRemaining % (1000 * 60)) / 1000);

              const dayText = days === 1 ? "day" : "days";
              countdownElement.textContent = `Time Left: ${days} ${dayText} ${hours} hours ${minutes} minutes ${seconds} seconds`;
              return true;
            }

            if (!updateCountdown()) return;

            const intervalId = setInterval(updateCountdown, 1000);
            window.addEventListener('unload', () => clearInterval(intervalId));
          }

          const rentalEndTimeValue = <%= rentalEndTime != null ? rentalEndTime : "null" %>;
          if (rentalEndTimeValue) {
            startCountdown(rentalEndTimeValue, 'countdown-<%= URLEncoder.encode(bikeName, "UTF-8") %>', '<%= bikeName %>');
          } else {
            console.error('rentalEndTime is null for bike:', '<%= bikeName %>');
            document.getElementById('countdown-<%= URLEncoder.encode(bikeName, "UTF-8") %>').textContent = "Rental end time not set.";
          }
        </script>
      </div>
      <%
        }
      %>
    </div>
  </div>

  <!-- Update Bike Modal (Only shown for the owner) -->
  <%
    if (isOwner) {
  %>
  <div class="modal fade" id="updateBikeModal" tabindex="-1" aria-labelledby="updateBikeModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title text-2xl font-bold" id="updateBikeModalLabel">Update Bike</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form id="updateBikeForm" action="UpdateBikeServlet" method="POST" enctype="multipart/form-data" onsubmit="handleUpdate(event)">
            <input type="hidden" name="originalBikeName" value="<%= URLEncoder.encode(bikeName, "UTF-8") %>">
            <input type="hidden" name="bikeName" value="<%= URLEncoder.encode(bikeName, "UTF-8") %>">
            <div class="mb-4">
              <label for="bikeNameInput" class="block text-gray-700 font-semibold mb-2">Bike Name</label>
              <input type="text" class="form-control" id="bikeNameInput" name="bikeNameInput" value="<%= bikeName %>" required>
            </div>
            <div class="mb-4">
              <label for="bikePhoto" class="block text-gray-700 font-semibold mb-2">Bike Photo</label>
              <input type="file" class="form-control" id="bikePhoto" name="bikePhoto" accept="image/*">
              <input type="hidden" name="currentPhotoPath" value="<%= bikeData[1] %>">
              <small class="text-gray-500">Current photo: <%= bikeData[1] %></small>
            </div>
            <div class="mb-4">
              <label for="bikePrice" class="block text-gray-700 font-semibold mb-2">Bike Price (per hour)</label>
              <input type="number" class="form-control" id="bikePrice" name="bikePrice" step="0.01" min="0" value="<%= bikeData[2] %>" required>
            </div>
            <div class="mb-4">
              <label for="ownerName" class="block text-gray-700 font-semibold mb-2">Bike Owner Name</label>
              <input type="text" class="form-control" id="ownerName" name="ownerName" value="<%= bikeData[3] %>" required>
            </div>
            <div class="mb-4">
              <label for="availability" class="block text-gray-700 font-semibold mb-2">Bike Availability</label>
              <select class="form-control" id="availability" name="availability" required>
                <option value="Available" <%= bikeData[4].equals("Available") ? "selected" : "" %>>Available</option>
                <option value="Not Available" <%= bikeData[4].equals("Not Available") ? "selected" : "" %>>Not Available</option>
              </select>
            </div>
            <div class="text-center">
              <button type="submit" class="btn-primary text-white">Update Bike</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <%
    }
  %>
  <%
  } else {
  %>
  <p class="text-center text-gray-700">Bike details not available.</p>
  <%
    }
  %>
</section>

<!-- JavaScript to handle form submission and redirect -->
<script>
  function handleUpdate(event) {
    event.preventDefault();
    const form = document.getElementById('updateBikeForm');
    const bikeName = encodeURIComponent(form.querySelector('input[name="bikeNameInput"]').value);
    const formData = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      body: formData
    })
            .then(response => {
              if (response.ok) {
                return response.text().then(text => {
                  alert('Bike updated successfully');
                  window.location.href = 'BikeDetailsServlet?bikeName=' + bikeName;
                });
              } else {
                return response.text().then(text => { throw new Error(text || 'Update failed'); });
              }
            })
            .catch(error => {
              console.error('Error updating bike:', error);
              alert('Failed to update bike: ' + error.message);
            });
  }

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
        <li><a href="Review.jsp" class="hover:underline">Reviews</a></li>
      </ul>
    </div>
  </div>
</footer>
</body>
</html>