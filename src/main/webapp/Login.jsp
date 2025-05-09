<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE | Login & Sign Up</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
  <link rel="stylesheet" type="text/css" href="login.css">
</head>
<body>
<div class="container<%= request.getAttribute("formType") != null && "signup".equals(request.getAttribute("formType")) ? " active" : "" %>" id="container">
  <!-- Sign Up Form -->
  <div class="form-container sign-up">
    <form action="registerServlet" method="post" class="form-content">
      <h1>Create Account</h1>
      <div class="social-icons">
        <a href="#" class="icon"><i class="fa-brands fa-google-plus-g"></i></a>
        <a href="#" class="icon"><i class="fa-brands fa-facebook-f"></i></a>
        <a href="#" class="icon"><i class="fa-brands fa-github"></i></a>
        <a href="#" class="icon"><i class="fa-brands fa-linkedin-in"></i></a>
      </div>
      <span>or use your email for registration</span>
      <input type="hidden" name="formType" value="signup">
      <input type="text" name="username" placeholder="Name" required value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
      <input type="email" name="email" placeholder="Email" required value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
      <input type="text" name="city" placeholder="City Name" required value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>">
      <input type="text" name="nic" placeholder="NIC Number" required value="<%= request.getParameter("nic") != null ? request.getParameter("nic") : "" %>">
      <input type="password" name="password" placeholder="Password" required>
      <input type="password" name="confirm_password" placeholder="Confirm Password" required>
      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        String formType = (String) request.getAttribute("formType");
        if (errorMessage != null && "signup".equals(formType)) {
      %>
      <span class="error-message"><%= errorMessage %></span>
      <% } %>
      <button type="submit">Sign Up</button>
    </form>
  </div>

  <!-- Sign In Form -->
  <div class="form-container sign-in">
    <form action="loginServlet" method="post" class="form-content">
      <h1>Sign In</h1>
      <div class="social-icons">
        <a href="#" class="icon"><i class="fa-brands fa-google-plus-g"></i></a>
        <a href="#" class="icon"><i class="fa-brands fa-facebook-f"></i></a>
        <a href="#" class="icon"><i class="fa-brands fa-github"></i></a>
        <a href="#" class="icon"><i class="fa-brands fa-linkedin-in"></i></a>
      </div>
      <span>or use your email and password</span>
      <input type="hidden" name="formType" value="signin">
      <input type="email" name="email" placeholder="Email" required value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
      <input type="password" name="password" placeholder="Password" required>
      <%
        if (errorMessage != null && "signin".equals(formType)) {
      %>
      <span class="error-message"><%= errorMessage %></span>
      <% } %>
      <a href="ForgotPassword.jsp" class="text-sm hover:underline">Forgot Your Password?</a>
      <button type="submit">Sign In</button>
    </form>
  </div>

  <!-- Toggle Panels -->
  <div class="toggle-container">
    <div class="toggle">
      <div class="toggle-panel toggle-left">
        <h1>Welcome Back!</h1>
        <p>Enter your details to access all site features</p>
        <button class="hidden" id="login">Sign In</button>
      </div>
      <div class="toggle-panel toggle-right">
        <h1>Hello, JOYRIDERS!</h1>
        <p>Register to unlock all site features</p>
        <button class="hidden" id="register">Sign Up</button>
      </div>
    </div>
  </div>
</div>

<script src="login.js"></script>
</body>
</html>