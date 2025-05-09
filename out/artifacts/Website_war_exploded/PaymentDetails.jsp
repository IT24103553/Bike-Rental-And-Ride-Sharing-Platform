<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.BufferedReader, java.io.FileReader, java.util.*, java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE - Payment Details</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-9ndCyUaIbzAi2FUVXJi0CjmCapSmO7SnpJef0486qhLnuZ2cdeRhO02iuK6FUUVM" crossorigin="anonymous">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js" integrity="sha384-geWF76RCwLtnZ8qwWowPQNguL3RmwHVBC9FhGdlKrxdiJJigb/j/68SIy3Te4Bkz" crossorigin="anonymous"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0==" crossorigin="anonymous">
  <style>
    body { background-color: #f0f0f0; }
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
    }
    .sidebar a:hover {
      background-color: #1a306f;
      border-left: 4px solid #3B82F6;
      padding-left: 25px;
    }
    .sidebar a i { margin-right: 10px; }
    .content { margin-left: 250px; padding: 20px; }
    .custom-table {
      border-collapse: separate;
      border-spacing: 0;
      border-radius: 10px;
      overflow: hidden;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .custom-table thead { background-color: #1E3A8A; color: white; }
    .custom-table th, .custom-table td { padding: 1rem; text-align: left; border-bottom: 1px solid #ddd; }
    .custom-table tbody tr { background-color: white; transition: background-color 0.3s ease; }
    .custom-table tbody tr:hover { background-color: #f1f1f1; }
    .custom-table th { font-weight: 700; }
    .btn-custom {
      border: none;
      padding: 0.5rem 1.5rem;
      font-size: 1rem;
      font-weight: 700;
      border-radius: 50px;
      transition: transform 0.3s ease, background-color 0.3s ease;
      width: 100px;
    }
    .btn-primary { background-color: #0d6efd; }
    .btn-primary:hover { background-color: #0b5ed7; transform: scale(1.05); }
    .btn-danger { background-color: #dc3545; }
    .btn-danger:hover { background-color: #c82333; transform: scale(1.05); }
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
    <h1>Welcome to Payment Details!</h1>
    <% String username = (String) session.getAttribute("username"); %>
    <p>Hi<%= username != null ? ", " + username : "" %>! Manage payment records here.</p>
  </div>

  <h2 class="text-3xl font-bold mb-6">Payment Records</h2>

  <%
    String PAYMENT_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Payment.txt";

    // List to store payment details
    List<String[]> payments = new ArrayList<>();
    try (BufferedReader paymentReader = new BufferedReader(new FileReader(PAYMENT_FILE_PATH))) {
      String line;
      while ((line = paymentReader.readLine()) != null) {
        if (line.trim().isEmpty()) continue;
        String[] parts = line.split(" \\| ");
        if (parts.length >= 9) {
          payments.add(new String[]{
                  parts[0].trim(), // Order Number
                  parts[1].trim(), // Bike Name
                  parts[2].trim(), // User Name
                  parts[3].trim(), // Email
                  parts[4].trim(), // Status
                  parts[5].trim(), // Rental Days
                  parts[6].trim(), // Total Amount
                  parts[7].trim()  // Additional Services
                  // parts[8] (Payment Slip) is skipped for now
          });
        } else {
  %>
  <div class="alert alert-warning" role="alert">
    Warning: Skipping invalid payment entry: <%= line %>
  </div>
  <%          continue;
  }
  }
  } catch (Exception e) {
  %>
  <div class="alert alert-danger" role="alert">Error loading payment data: <%= e.getMessage() %></div>
  <% return; } %>

  <!-- Attractive Table -->
  <div class="overflow-x-auto">
    <table class="custom-table w-full">
      <thead>
      <tr>
        <th>Order Number</th>
        <th>Bike Name</th>
        <th>User Name</th>
        <th>Email</th>
        <th>Status</th>
        <th>Rental Days</th>
        <th>Total Amount</th>
        <th>Additional Services</th>
        <th>Actions</th>
      </tr>
      </thead>
      <tbody>
      <% if (payments.isEmpty()) { %>
      <tr>
        <td colspan="9" class="text-center">No payment records found.</td>
      </tr>
      <% } else { %>
      <% for (String[] payment : payments) { %>
      <tr>
        <td><%= payment[0] != null ? payment[0] : "N/A" %></td>
        <td><%= payment[1] != null ? payment[1] : "N/A" %></td>
        <td><%= payment[2] != null ? payment[2] : "N/A" %></td>
        <td><%= payment[3] != null ? payment[3] : "N/A" %></td>
        <td><%= payment[4] != null ? payment[4] : "N/A" %></td>
        <td><%= payment[5] != null ? payment[5] : "N/A" %></td>
        <td><%= payment[6] != null ? payment[6] : "N/A" %></td>
        <td><%= payment[7] != null ? payment[7] : "N/A" %></td>
        <td>
          <a href="UpdatePayment.jsp?orderNumber=<%= URLEncoder.encode(payment[0], StandardCharsets.UTF_8) %>" class="btn btn-primary btn-custom text-white mr-2">Update</a>
          <a href="DeletePaymentServlet?orderNumber=<%= URLEncoder.encode(payment[0], StandardCharsets.UTF_8) %>" class="btn btn-danger btn-custom text-white" onclick="return confirm('Are you sure you want to delete this payment record?');">Delete</a>
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