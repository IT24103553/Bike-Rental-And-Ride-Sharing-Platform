<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE | Forgot Password</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    .container {
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background: linear-gradient(135deg, #f76b64, #fa8a76);
    }
    .form-container {
      background: white;
      padding: 2rem;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      width: 100%;
      max-width: 400px;
    }
    .form-container h1 {
      text-align: center;
      margin-bottom: 1.5rem;
      color: #f76b64;
    }
    .form-container input {
      width: 100%;
      padding: 0.75rem;
      margin-bottom: 1rem;
      border: 1px solid #ddd;
      border-radius: 5px;
      outline: none;
      transition: border-color 0.3s ease;
    }
    .form-container input:focus {
      border-color: #f76b64;
    }
    .form-container button {
      width: 100%;
      padding: 0.75rem;
      background-color: #f76b64;
      color: white;
      border: none;
      border-radius: 5px;
      font-weight: bold;
      cursor: pointer;
      transition: background-color 0.3s ease;
    }
    .form-container button:hover {
      background-color: #fa8a76;
    }
    .error-message {
      color: red;
      text-align: center;
      display: block;
      margin-bottom: 1rem;
    }
    .success-message {
      color: green;
      text-align: center;
      display: block;
      margin-bottom: 1rem;
    }
    .back-link {
      text-align: center;
      margin-top: 1rem;
    }
    .back-link a {
      color: #f76b64;
      text-decoration: none;
    }
    .back-link a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
<div class="container">
  <div class="form-container">
    <h1>Reset Password</h1>
    <form action="ForgotPasswordServlet" method="post">
      <input type="email" name="email" placeholder="Enter your email" required value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
      <input type="text" name="nic" placeholder="Enter your NIC number" required value="<%= request.getParameter("nic") != null ? request.getParameter("nic") : "" %>">
      <input type="password" name="newPassword" placeholder="Enter new password" required>
      <input type="password" name="confirmNewPassword" placeholder="Confirm new password" required>
      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        String successMessage = (String) request.getAttribute("successMessage");
        if (errorMessage != null) {
      %>
      <span class="error-message"><%= errorMessage %></span>
      <% } %>
      <% if (successMessage != null) { %>
      <span class="success-message"><%= successMessage %></span>
      <% } %>
      <button type="submit">Reset Password</button>
    </form>
    <div class="back-link">
      <a href="Login.jsp">Back to Login</a>
    </div>
  </div>
</div>
</body>
</html>
