<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE | Search Members</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<div class="container mx-auto px-6 py-16">
    <h1 class="text-4xl font-bold text-center mb-8">Search Members</h1>
    <div class="bg-white shadow-lg rounded-lg p-6 max-w-lg mx-auto">
        <form action="SearchMembersServlet" method="post">
            <div class="mb-4">
                <label for="searchQuery" class="block text-lg font-semibold mb-2">Search by Username or NIC Number</label>
                <input type="text" id="searchQuery" name="searchQuery" placeholder="Enter username or NIC number" class="w-full px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#f76b64]" required>
            </div>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
            <span style="color: red; font-size: 0.9em; display: block; margin-bottom: 10px;"><%= errorMessage %></span>
            <% } %>
            <div class="flex justify-between">
                <button type="submit" class="bg-[#f76b64] text-white px-4 py-2 rounded-lg font-bold hover:bg-[#fa8a76] transition">Search</button>
                <a href="index.jsp" class="bg-gray-500 text-white px-4 py-2 rounded-lg font-bold hover:bg-gray-600 transition">Back to Home</a>
            </div>
        </form>
    </div>

    <!-- Display Search Results -->
    <%
        java.util.List<String[]> searchResults = (java.util.List<String[]>) request.getAttribute("searchResults");
        if (searchResults != null && !searchResults.isEmpty()) {
    %>
    <div class="mt-8 bg-white shadow-lg rounded-lg p-6 max-w-2xl mx-auto">
        <h2 class="text-2xl font-semibold mb-4">Search Results</h2>
        <table class="w-full border-collapse">
            <thead>
            <tr class="bg-gray-200">
                <th class="border px-4 py-2">NIC Number</th>
                <th class="border px-4 py-2">City</th>
            </tr>
            </thead>
            <tbody>
            <% for (String[] user : searchResults) { %>
            <tr>
                <td class="border px-4 py-2"><%= user[4] %></td> <!-- NIC Number -->
                <td class="border px-4 py-2"><%= user[3] %></td> <!-- City -->
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>
</body>
</html>