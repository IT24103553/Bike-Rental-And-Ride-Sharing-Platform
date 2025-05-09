<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Rent Bike - JOY-RIDE</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://cdn.tailwindcss.com"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <style>
    body {
      background-color: #f0f0f0;
    }
    .container {
      max-width: 600px;
      margin: 50px auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    h2 {
      text-align: center;
      margin-bottom: 20px;
      color: #333;
    }
    .form-group {
      margin-bottom: 15px;
    }
    .form-group label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #555;
    }
    .form-group input[type="text"],
    .form-group input[type="number"] {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 16px;
    }
    .additional-services label {
      margin-right: 1rem;
    }
    #totalPayment {
      font-weight: bold;
      margin-top: 1rem;
      color: #28a745;
    }
    .btn-checkout, .btn-update {
      width: 100%;
      padding: 10px;
      border: none;
      border-radius: 5px;
      font-size: 16px;
      font-weight: bold;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    .btn-checkout {
      background-color: #f76b64;
      color: #fff;
    }
    .btn-checkout:hover {
      background-color: #fa8a76;
    }
    .btn-update {
      background-color: #007bff;
      color: #fff;
      margin-bottom: 10px;
    }
    .btn-update:hover {
      background-color: #0056b3;
    }
    .error-message {
      background-color: #f8d7da;
      color: #721c24;
      padding: 10px;
      border-radius: 5px;
      text-align: center;
      margin-bottom: 15px;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Rent Bike</h2>

  <%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null) {
  %>
  <div class="error-message">
    <%= errorMessage %>
  </div>
  <%
    }
  %>

  <form id="rentBikeForm" action="RentBikeServlet" method="POST">
    <input type="hidden" name="bikeName" value="<%= request.getAttribute("bikeName") != null ? request.getAttribute("bikeName") : "" %>">
    <input type="hidden" name="orderNumber" value="<%= request.getAttribute("orderNumber") != null ? request.getAttribute("orderNumber") : "" %>">

    <div class="form-group">
      <label for="bikeId">Bike ID</label>
      <input type="text" id="bikeId" name="bikeId" value="<%= request.getAttribute("bikeName") != null ? request.getAttribute("bikeName") : "" %>" readonly required>
    </div>

    <div class="form-group">
      <label for="username">Username</label>
      <input type="text" id="username" name="username" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>" readonly required>
    </div>

    <div class="form-group">
      <label for="orderNumber">Order Number</label>
      <input type="text" id="orderNumber" name="orderNumberDisplay" value="<%= request.getAttribute("orderNumber") != null ? request.getAttribute("orderNumber") : "" %>" readonly required>
    </div>

    <div class="form-group">
      <label for="rentalDays">Rental Days</label>
      <input type="number" id="rentalDays" name="rentalDays" placeholder="Enter number of days" min="1" value="<%= request.getAttribute("rentalDays") != null ? request.getAttribute("rentalDays") : "1" %>" required>
    </div>

    <div class="form-group additional-services">
      <label>Additional Services ($25 each)</label><br>
      <%
        String[] selectedServices = (String[]) request.getAttribute("additionalServices");
      %>
      <input type="checkbox" id="helmet" name="additionalServices" value="Helmet" <%= selectedServices != null && java.util.Arrays.asList(selectedServices).contains("Helmet") ? "checked" : "" %>>
      <label for="helmet">Helmet</label>
      <input type="checkbox" id="gloves" name="additionalServices" value="Gloves" <%= selectedServices != null && java.util.Arrays.asList(selectedServices).contains("Gloves") ? "checked" : "" %>>
      <label for="gloves">Gloves</label>
      <input type="checkbox" id="rainJacket" name="additionalServices" value="RainJacket" <%= selectedServices != null && java.util.Arrays.asList(selectedServices).contains("RainJacket") ? "checked" : "" %>>
      <label for="rainJacket">Rain Jacket</label>
    </div>

    <div class="form-group">
      <label>Total Payment:</label>
      <div id="totalPayment">$<%= request.getAttribute("totalPayment") != null ? String.format("%.2f", (Double) request.getAttribute("totalPayment")) : "0.00" %></div>
      <input type="hidden" id="totalPaymentInput" name="totalPayment" value="<%= request.getAttribute("totalPayment") != null ? String.format("%.2f", (Double) request.getAttribute("totalPayment")) : "0.00" %>">
    </div>

    <button type="submit" class="btn-update">Update Total</button>
  </form>

  <form action="RentBikeServlet" method="POST">
    <input type="hidden" name="action" value="checkout">
    <input type="hidden" name="bikeName" value="<%= request.getAttribute("bikeName") != null ? request.getAttribute("bikeName") : "" %>">
    <input type="hidden" name="username" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : "" %>">
    <input type="hidden" name="orderNumber" value="<%= request.getAttribute("orderNumber") != null ? request.getAttribute("orderNumber") : "" %>">
    <input type="hidden" name="rentalDays" value="<%= request.getAttribute("rentalDays") != null ? request.getAttribute("rentalDays") : "1" %>">
    <%
      if (selectedServices != null) {
        for (String service : selectedServices) {
    %>
    <input type="hidden" name="additionalServices" value="<%= service %>">
    <%
        }
      }
    %>
    <input type="hidden" name="totalPayment" value="<%= request.getAttribute("totalPayment") != null ? String.format("%.2f", (Double) request.getAttribute("totalPayment")) : "0.00" %>">
    <button type="submit" class="btn-checkout">Proceed to Checkout</button>
  </form>
</div>

<script>
  // Replace the history entry to ensure the back button goes to BikeDetailsServlet
  window.history.replaceState(null, null, window.location.href);

  // Add event listener for the back button
  window.onpopstate = function(event) {
    // Redirect to BikeDetailsServlet with the bikeName
    const bikeName = "<%= request.getAttribute("bikeName") != null ? request.getAttribute("bikeName") : "" %>";
    window.location.href = "BikeDetailsServlet?bikeName=" + encodeURIComponent(bikeName);
  };

  // Push a dummy state to ensure the back button triggers onpopstate
  window.history.pushState(null, null, window.location.href);
</script>
</body>
</html>