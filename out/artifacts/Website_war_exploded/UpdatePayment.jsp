<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE | Update Payment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #f4f4f4; }
        .container { max-width: 600px; margin-top: 50px; }
        .card { border-radius: 10px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); }
        .card-header { background-color: #f76b64; color: white; font-weight: 600; border-top-left-radius: 10px; border-top-right-radius: 10px; }
        .form-group label { font-weight: 500; color: #333; }
        .form-group .value { font-size: 1.1rem; font-weight: 600; color: #2e7d32; }
        .form-group .additional-payment { color: #d9534f; font-weight: 500; }
        .btn-update { background-color: #007bff; color: white; border-radius: 20px; }
        .btn-update:hover { background-color: #0056b3; }
        .error-message { background-color: #f8d7da; color: #721c24; padding: 10px; border-radius: 5px; margin-top: 10px; text-align: center; }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header p-3">Update Payment for <%= request.getAttribute("bikeName") != null ? request.getAttribute("bikeName") : "Unknown" %></div>
        <div class="card-body p-4">
            <form action="UpdatePaymentServlet" method="POST" enctype="multipart/form-data">
                <input type="hidden" name="bikeName" value="<%= request.getAttribute("bikeName") != null ? request.getAttribute("bikeName") : "" %>">
                <input type="hidden" name="currentTotalPayment" value="<%= request.getAttribute("currentTotalPayment") != null ? request.getAttribute("currentTotalPayment") : "0.0" %>">
                <input type="hidden" name="updatedTotalPayment" value="<%= request.getAttribute("updatedTotalPayment") != null ? request.getAttribute("updatedTotalPayment") : "0.0" %>">

                <div class="form-group mb-3">
                    <label>Current Total Payment:</label>
                    <div class="value">
                        $<%= new DecimalFormat("#.##").format(request.getAttribute("currentTotalPayment") != null && request.getAttribute("currentTotalPayment") instanceof String ?
                            Double.parseDouble((String) request.getAttribute("currentTotalPayment")) : 0.0) %>
                    </div>
                </div>
                <div class="form-group mb-3">
                    <label>Updated Total Payment:</label>
                    <div class="value">
                        $<%= new DecimalFormat("#.##").format(request.getAttribute("updatedTotalPayment") != null && request.getAttribute("updatedTotalPayment") instanceof String ?
                            Double.parseDouble((String) request.getAttribute("updatedTotalPayment")) : 0.0) %>
                    </div>
                </div>
                <%
                    double currentPayment = request.getAttribute("currentTotalPayment") != null && request.getAttribute("currentTotalPayment") instanceof String ?
                            Double.parseDouble((String) request.getAttribute("currentTotalPayment")) : 0.0;
                    double updatedPayment = request.getAttribute("updatedTotalPayment") != null && request.getAttribute("updatedTotalPayment") instanceof String ?
                            Double.parseDouble((String) request.getAttribute("updatedTotalPayment")) : 0.0;
                    double additionalPayment = updatedPayment - currentPayment;
                %>
                <div class="form-group mb-4">
                    <label>Additional Payment Required:</label>
                    <div class="additional-payment">
                        $<%= new DecimalFormat("#.##").format(additionalPayment) %>
                    </div>
                </div>
                <div class="form-group mb-4">
                    <label for="bankSlip">Upload Bank Slip Image:</label>
                    <input type="file" id="bankSlip" name="bankSlip" accept="image/*" required class="form-control">
                </div>
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
                <button type="submit" class="btn btn-update px-4 py-2">Submit Payment</button>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>