<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE | Change Password</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">
<div class="container mx-auto px-6 py-16">
  <h1 class="text-4xl font-bold text-center mb-8">Change Password</h1>
  <div class="bg-white shadow-lg rounded-lg p-6 max-w-lg mx-auto">
    <form action="ChangePasswordServlet" method="post">
      <div class="mb-4">
        <label for="currentPassword" class="block text-lg font-semibold mb-2">Current Password</label>
        <input type="password" id="currentPassword" name="currentPassword" placeholder="Enter current password" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
      </div>
      <div class="mb-4">
        <label for="newPassword" class="block text-lg font-semibold mb-2">New Password</label>
        <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
      </div>
      <div class="mb-4">
        <label for="confirmNewPassword" class="block text-lg font-semibold mb-2">Confirm New Password</label>
        <input type="password" id="confirmNewPassword" name="confirmNewPassword" placeholder="Confirm new password" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
      </div>
      <%
        String errorMessage = (String) request.getAttribute("errorMessage");
        String successMessage = (String) request.getAttribute("successMessage");
        if (errorMessage != null) {
      %>
      <span style="color: red; font-size: 0.9em; display: block; margin-bottom: 10px; text-align: center;"><%= errorMessage %></span>
      <% } %>
      <% if (successMessage != null) { %>
      <span style="color: green; font-size: 0.9em; display: block; margin-bottom: 10px; text-align: center;"><%= successMessage %></span>
      <% } %>
      <div class="flex justify-between">
        <button type="submit" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg font-bold hover:bg-[#fa8a76] transition">Change Password</button>
        <a href="index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded-lg font-bold hover:bg-gray-600 transition">Back to Home</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>