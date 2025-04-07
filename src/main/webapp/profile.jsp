<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JOY-RIDE | Profile</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-6 py-16">
  <h1 class="text-4xl font-bold text-center mb-8">User Profile</h1>
  <div class="bg-white shadow-lg rounded-lg p-6 max-w-md mx-auto">
    <h2 class="text-2xl font-semibold mb-4">Profile Details</h2>
    <p class="text-lg mb-2"><strong>Username:</strong> <%= session.getAttribute("username") %></p>
    <p class="text-lg mb-2"><strong>Email:</strong> <%= session.getAttribute("email") %></p>
    <p class="text-lg mb-2"><strong>City:</strong> <%= session.getAttribute("city") %></p>
    <p class="text-lg mb-6"><strong>NIC Number:</strong> <%= session.getAttribute("nic") %></p>
    <div class="flex justify-between">
      <a href="EditProfile.jsp" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg font-bold hover:bg-[#fa8a76] transition">Edit Profile</a>
      <a href="DeleteAccountServlet" class="bg-red-600 text-white px-4 py-2 rounded-lg font-bold hover:bg-red-700 transition" onclick="return confirm('Are you sure you want to delete your account? This action cannot be undone.');">Delete Account</a>
    </div>
    <a href="index.jsp" class="block text-center mt-4 text-[#f76b64] hover:underline">Back to Home</a>
  </div>
</div>
</body>
</html>