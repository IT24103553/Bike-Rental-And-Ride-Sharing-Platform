<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.BufferedReader, java.io.FileReader, java.util.*, java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
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
    body { background-color: #f0f0f0; font-family: 'Arial', sans-serif; }
    .sidebar {
      background: linear-gradient(180deg, #1E3A8A, #0F1D4A);
      width: 250px;
      height: 100vh;
      position: fixed;
      top: 0;
      left: 0;
      padding-top: 20px;
      box-shadow: 2px 0 10px rgba(0, 0, 0, 0.2);
      transition: width 0.3s ease;
    }
    .sidebar:hover { width: 260px; }
    .sidebar .logo {
      text-align: center;
      margin-bottom: 2rem;
      transition: transform 0.3s ease;
    }
    .sidebar .logo:hover { transform: scale(1.05); }
    .sidebar a {
      color: white;
      padding: 15px 20px;
      display: flex;
      align-items: center;
      font-size: 1.1rem;
      transition: all 0.3s ease;
      border-left: 4px solid transparent;
      text-decoration: none;
    }
    .sidebar a:hover {
      background-color: #1a306f;
      border-left: 4px solid #3B82F6;
      padding-left: 25px;
    }
    .sidebar a i { margin-right: 10px; }
    .content { margin-left: 250px; padding: 20px; }
    .welcome-message {
      background: linear-gradient(90deg, #1E3A8A, #3B82F6);
      color: white;
      padding: 2rem;
      border-radius: 15px;
      text-align: center;
      margin-bottom: 2rem;
      animation: fadeIn 1.5s ease-in-out;
      box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
    }
    .welcome-message h1 {
      font-size: 2.5rem;
      font-weight: 800;
      margin-bottom: 0.5rem;
      text-transform: uppercase;
      letter-spacing: 2px;
    }
    .welcome-message p { font-size: 1.2rem; opacity: 0.9; }
    .custom-table {
      width: 100%;
      border-collapse: separate;
      border-spacing: 0;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
      background-color: white;
    }
    .custom-table thead {
      background-color: #1E3A8A;
      color: white;
    }
    .custom-table th {
      padding: 1rem;
      text-align: center;
      font-weight: 700;
      border-bottom: 2px solid #ddd;
    }
    .custom-table td {
      padding: 1rem;
      text-align: center;
      border-bottom: 1px solid #ddd;
    }
    .custom-table tbody tr:nth-child(even) {
      background-color: #f9f9f9;
    }
    .custom-table tbody tr:hover {
      background-color: #e0e7ff;
      transition: background-color 0.3s ease;
    }
    .btn-custom {
      border: none;
      padding: 0.5rem 1.5rem;
      font-size: 0.9rem;
      font-weight: 600;
      border-radius: 20px;
      transition: transform 0.3s ease, background-color 0.3s ease;
      width: 90px;
      cursor: pointer;
    }
    .btn-primary { background-color: #0d6efd; color: white; }
    .btn-primary:hover { background-color: #0b5ed7; transform: scale(1.05); }
    .btn-danger { background-color: #dc3545; color: white; }
    .btn-danger:hover { background-color: #c82333; transform: scale(1.05); }
    @keyframes fadeIn {
      from { opacity: 0; transform: translateY(20px); }
      to { opacity: 1; transform: translateY(0); }
    }
  </style>
</head>
<body>
<!-- Side Navigation Bar -->
<div class="sidebar">
  <div class="logo">
    <a href="index.jsp" class="text-3xl font-extrabold text-white">JOY-RIDE</a>
  </div>
  <a href="profile.jsp"><i class="fas fa-user mr-2"></i> Profile</a>
  <a href="AdminDashboard.jsp"><i class="fas fa-tachometer-alt mr-2"></i> Dashboard</a>
  <a href="Users.jsp"><i class="fas fa-users mr-2"></i> Users</a>
  <a href="AdminManagement.jsp"><i class="fas fa-user-shield mr-2"></i> Admin Management</a>
  <a href="AdminBikeDetails.jsp"><i class="fas fa-motorcycle mr-2"></i> Bikes</a>
  <a href="AdminReviews.jsp"><i class="fas fa-star mr-2"></i> Reviews & Feedback</a>
  <a href="RentDetails.jsp"><i class="fas fa-file-alt mr-2"></i> Rent Details</a>
  <a href="PaymentDetails.jsp"><i class="fas fa-credit-card mr-2"></i> Payment Details</a>
  <a href="LogoutServlet"><i class="fas fa-sign-out-alt mr-2"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="content">
  <%
    // Check if the user is an admin
    Boolean isAdmin = (Boolean) session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
  %>
  <div class="alert alert-danger" role="alert">
    Access Denied: You must be an admin to view this page. Please <a href="Login.jsp">log in</a> as an admin.
  </div>
  <% return; } %>

  <div class="welcome-message">
    <h1>WELCOME TO BIKE MANAGEMENT!</h1>
    <% String username = (String) session.getAttribute("username"); %>
    <p>Hi<%= username != null ? ", " + username : "" %>! Manage bike details here.</p>
  </div>

  <h2 class="text-3xl font-bold mb-6">Bike Details</h2>

  <%
    String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";

    // List to store bike details
    List<String[]> bikesList = new ArrayList<>();
    try (BufferedReader bikeReader = new BufferedReader(new FileReader(BIKES_FILE_PATH))) {
      String line;
      while ((line = bikeReader.readLine()) != null) {
        if (line.trim().isEmpty()) continue;
        String[] parts = line.split(" \\| ");
        if (parts.length > 0) {
          // Ensure at least 4 fields, fill with "N/A" if fewer
          String[] bikeData = new String[4];
          bikeData[0] = parts.length > 0 ? parts[0].trim() : "N/A"; // Bike Name
          bikeData[1] = parts.length > 1 ? parts[1].trim() : "N/A"; // Photo
          bikeData[2] = parts.length > 2 ? parts[2].trim() : "N/A"; // Rent/Hour
          bikeData[3] = parts.length > 3 ? parts[3].trim() : "N/A"; // Owner/Status
          bikesList.add(bikeData);
        }
      }
    } catch (Exception e) {
  %>
  <div class="alert alert-danger" role="alert">Error loading bike data: <%= e.getMessage() %></div>
  <% return; } %>

  <!-- Beautiful Table -->
  <div class="overflow-x-auto">
    <table class="custom-table">
      <thead>
      <tr>
        <th>Bike Name</th>
        <th>Photo</th>
        <th>Rent/Hour (in dollars)</th>
        <th>Owner/Status</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <% if (bikesList.isEmpty()) { %>
      <tr>
        <td colspan="5" class="text-center">No bikes found.</td>
      </tr>
      <% } else { %>
      <%
        String[] sampleBikes = {
                "Honda, Activa, 6g|Activa-on-Rent-in-Bangalore.webp|200|Samadhith Jayasena",
                "TVS, 125|125-cc-yamaha-scooty-with-50-6-kmpl-mileage-and-5-2-liter-tank-capacity-308.jpg|300|Samadhith Jayasena",
                "Royal Enfield, Classic|5.jpg|350|Iman Udaraka|Available|Iman Udaraka",
                "Yamaha, Motor|2.jpg|400|Iman Udaraka|Available|Iman Udaraka",
                "Verge|verge-ts-pro-electric-motorbike-first-ride-front-gear-webp|250|Iman Udaraka|Available|Iman Udaraka",
                "Damon|Tacta-Dicanto-Dakar-Rally-electric-motorcycle-webp|350|Iman Udaraka|Available|Iman Udaraka",
                "Maverick|6.jpg|475|Mohommed Shafkhan|Available|Mohommed Shafkhan"
        };
        for (String bikeLine : sampleBikes) {
          String[] parts = bikeLine.split("\\|");
          String[] bikeData = new String[4];
          bikeData[0] = parts.length > 0 ? parts[0].trim() : "N/A"; // Bike Name
          bikeData[1] = parts.length > 1 ? parts[1].trim() : "N/A"; // Photo
          bikeData[2] = parts.length > 2 ? parts[2].trim() : "N/A"; // Rent/Hour
          bikeData[3] = parts.length > 3 ? parts[3].trim() : "N/A"; // Owner/Status
      %>
      <tr>
        <td><%= bikeData[0] %></td>
        <td><%= bikeData[1] %></td>
        <td><%= bikeData[2] %></td>
        <td><%= bikeData[3] %></td>
        <td>
          <a href="UpdateBike.jsp?bikeName=<%= URLEncoder.encode(bikeData[0], StandardCharsets.UTF_8) %>" class="btn btn-primary btn-custom">Update</a>
          <a href="DeleteBikeServlet?bikeName=<%= URLEncoder.encode(bikeData[0], StandardCharsets.UTF_8) %>" class="btn btn-danger btn-custom" onclick="return confirm('Are you sure you want to delete this bike?');">Delete</a>
        </td>
      </tr>
      <% } %>
      <% } %>
      </tbody>
    </table>
  </div>
</div>
</body>
</html>