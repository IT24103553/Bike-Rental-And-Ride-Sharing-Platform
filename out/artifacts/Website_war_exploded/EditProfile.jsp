<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE | Edit Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-6 py-16">
    <h1 class="text-4xl font-bold text-center mb-8">Edit Profile</h1>
    <div class="bg-white shadow-lg rounded-lg p-6 max-w-md mx-auto">
        <form action="EditProfileServlet" method="post">
            <div class="mb-4">
                <label for="username" class="block text-lg font-semibold mb-2">Username</label>
                <input type="text" id="username" name="username" value="<%= session.getAttribute("username") %>" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
            </div>
            <div class="mb-4">
                <label for="email" class="block text-lg font-semibold mb-2">Email</label>
                <input type="email" id="email" name="email" value="<%= session.getAttribute("email") %>" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
            </div>
            <div class="mb-4">
                <label for="city" class="block text-lg font-semibold mb-2">City</label>
                <input type="text" id="city" name="city" value="<%= session.getAttribute("city") %>" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
            </div>
            <div class="mb-4">
                <label for="nic" class="block text-lg font-semibold mb-2">NIC Number</label>
                <input type="text" id="nic" name="nic" value="<%= session.getAttribute("nic") %>" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
            </div>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                String successMessage = (String) request.getAttribute("successMessage");
                if (errorMessage != null) {
            %>
            <span style="color: red; font-size: 0.9em; display: block; margin-bottom: 10px;"><%= errorMessage %></span>
            <% } %>
            <% if (successMessage != null) { %>
            <span style="color: green; font-size: 0.9em; display: block; margin-bottom: 10px;"><%= successMessage %></span>
            <% } %>
            <div class="flex justify-between">
                <button type="submit" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg font-bold hover:bg-[#fa8a76] transition">Save Changes</button>
                <a href="profile.jsp" class="bg-gray-500 text-white px-4 py-2 rounded-lg font-bold hover:bg-gray-600 transition">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>