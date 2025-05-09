<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Payment Slip Upload</title>
  <link rel="stylesheet" href="Payment.css">
  <style>
    .total-payment {
      margin-top: 10px;
    }
    .total-payment label {
      display: block;
      margin-bottom: 5px;
      font-weight: bold;
      color: #555;
    }
    .total-payment p {
      margin: 0;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      background-color: #f9f9f9;
      font-size: 16px;
      color: #333;
    }
    .error-message {
      background-color: #f8d7da;
      color: #721c24;
      padding: 10px;
      border-radius: 5px;
      text-align: center;
      margin-bottom: 15px;
    }
    .success-message {
      background-color: #d4edda;
      color: #155724;
      padding: 15px;
      border-radius: 5px;
      text-align: center;
      margin-bottom: 15px;
      font-size: 18px;
      font-weight: bold;
    }
  </style>
</head>
<body>
<div class="container">
  <h2>Payment Slip Upload</h2>

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

  <%
    String successMessage = (String) request.getAttribute("successMessage");
    if (successMessage != null) {
  %>
  <div class="success-message">
    <%= successMessage %>
  </div>
  <%
    }
  %>

  <form id="paymentForm" action="UploadPaymentServlet" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="orderNumber" value="<%= request.getParameter("orderNumber") != null ? request.getParameter("orderNumber") : "" %>">
    <input type="hidden" name="rentalDays" value="<%= request.getParameter("rentalDays") != null ? request.getParameter("rentalDays") : "1" %>">
    <%
      String[] additionalServices = request.getParameterValues("additionalServices");
      if (additionalServices != null) {
        for (String service : additionalServices) {
    %>
    <input type="hidden" name="additionalServices" value="<%= service %>">
    <%
        }
      }
    %>
    <div class="form-group">
      <label for="email">Email Address</label>
      <input type="email" id="email" name="email" placeholder="Enter your email" required>
    </div>

    <div class="form-group">
      <label for="bikeId">Bike ID</label>
      <input type="text" id="bikeId" name="bikeId" value="<%= request.getAttribute("bikeId") != null ? request.getAttribute("bikeId") : (request.getParameter("bikeId") != null ? request.getParameter("bikeId") : "") %>" readonly required>
    </div>

    <div class="form-group">
      <label for="name">Name</label>
      <input type="text" id="name" name="name" value="<%= request.getAttribute("username") != null ? request.getAttribute("username") : (request.getParameter("username") != null ? request.getParameter("username") : "") %>" readonly required>
    </div>

    <div class="form-group">
      <label for="note">Additional Note</label>
      <textarea id="note" name="note" placeholder="Add any notes (optional)"></textarea>
      <%
        String totalPayment = request.getAttribute("totalPayment") != null ? (String) request.getAttribute("totalPayment") : request.getParameter("totalPayment");
        if (totalPayment != null && !totalPayment.isEmpty()) {
      %>
      <div class="total-payment">
        <label>Total Payment:</label>
        <p>$<%= totalPayment %></p>
        <input type="hidden" name="totalPayment" value="<%= totalPayment %>">
      </div>
      <%
        }
      %>
    </div>

    <div class="form-group">
      <label for="slip">Payment Slip</label>
      <input type="file" id="slip" name="slip" accept="image/*,.pdf" required>
      <small class="file-info">Accepted: Images and PDFs</small>
    </div>

    <button type="submit" id="submitBtn">Upload Payment</button>
  </form>
</div>

<script>
  // Debug: Log form values before submission
  document.getElementById('paymentForm').addEventListener('submit', function() {
    const orderNumber = this.querySelector('input[name="orderNumber"]').value;
    const email = this.querySelector('input[name="email"]').value;
    const username = this.querySelector('input[name="name"]').value;
    const totalPayment = this.querySelector('input[name="totalPayment"]').value;
    const additionalServices = this.querySelectorAll('input[name="additionalServices"]').length > 0 ?
            Array.from(this.querySelectorAll('input[name="additionalServices"]'))
                    .map(input => input.value)
                    .join(", ") : "None";
    console.log("Form Submission - orderNumber: " + orderNumber + ", email: " + email +
            ", username: " + username + ", totalPayment: " + totalPayment +
            ", additionalServices: " + additionalServices);
  });

  // Replace the current history entry with index.jsp immediately upon page load
  window.history.replaceState(null, null, 'index.jsp');

  // If the page is loaded with a success message, redirect to index.jsp after 3 seconds
  <% if (successMessage != null) { %>
  setTimeout(function() {
    window.location.href = 'index.jsp';
  }, 3000); // Redirect after 3 seconds
  <% } %>
</script>
</body>
</html>