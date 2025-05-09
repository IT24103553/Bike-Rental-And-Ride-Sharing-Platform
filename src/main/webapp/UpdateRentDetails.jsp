<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.io.IOException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOY-RIDE | Update Rental Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { background-color: #f1f1f1; }
        .container { max-width: 500px; margin-top: 50px; }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
            background-color: #ffffff;
        }
        .card-header {
            background-color: #f76b64;
            color: white;
            border-top-left-radius: 12px;
            border-top-right-radius: 12px;
            border-bottom: none;
            padding: 1.25rem;
            font-size: 1.4rem;
            font-weight: 600;
        }
        .card-body { padding: 1.5rem 2rem; }
        .card-footer {
            border-top: none;
            padding: 1rem 2rem;
            background-color: #f9f9f9;
            border-bottom-left-radius: 12px;
            border-bottom-right-radius: 12px;
        }
        .card-footer .btn-secondary {
            background-color: #adb5bd;
            border: none;
            border-radius: 20px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: background-color 0.3s ease;
        }
        .card-footer .btn-secondary:hover { background-color: #95a5a6; }
        .card-footer .btn-update {
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 20px;
            padding: 0.5rem 1.5rem;
            font-weight: 500;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }
        .card-footer .btn-update:hover {
            background-color: #0056b3;
            transform: scale(1.03);
        }
        .form-group { margin-bottom: 1.25rem; }
        .card-body label {
            font-size: 1rem;
            font-weight: 500;
            color: #333;
            margin-bottom: 0.5rem;
            display: block;
        }
        .card-body input[type="number"], .card-body input[type="text"] {
            width: 100%;
            padding: 0.65rem;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 1rem;
            background-color: #f5f5f5;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }
        .card-body input[readonly] {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        .card-body input[type="number"]:focus {
            border-color: #f76b64;
            box-shadow: 0 0 0 0.2rem rgba(247, 107, 100, 0.25);
            outline: none;
        }
        .card-body .additional-services { margin-bottom: 1.25rem; }
        .card-body .additional-services label {
            font-weight: 500;
            color: #333;
        }
        .card-body .additional-services .checkbox-group {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            margin-top: 0.5rem;
        }
        .card-body .additional-services .checkbox-group label {
            font-weight: 400;
            color: #555;
            margin-bottom: 0;
            display: inline-block;
            margin-left: 0.25rem;
            cursor: pointer;
        }
        .card-body .additional-services input[type="checkbox"] {
            width: 1.1rem;
            height: 1.1rem;
            cursor: pointer;
        }
        .card-body .current-payment {
            padding: 0.75rem;
            border-radius: 6px;
            background-color: #e9f7ef;
            text-align: center;
            margin-bottom: 1.25rem;
        }
        .card-body .current-payment label {
            font-size: 1rem;
            font-weight: 500;
            color: #2e7d32;
        }
        .card-body .current-payment div {
            font-size: 1.2rem;
            font-weight: 600;
            color: #1b5e20;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header">
            Extend Rental: <%= URLDecoder.decode(request.getParameter("bikeName"), "UTF-8") %>
        </div>
        <form action="UpdateRentalServlet" method="POST">
            <div class="card-body">
                <input type="hidden" name="bikeName" value="<%= request.getParameter("bikeName") %>">
                <input type="hidden" name="pricePerHour" value="<%= request.getParameter("pricePerHour") %>" id="pricePerHour">
                <%
                    String paymentFilePath = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Payment.txt";
                    String rentalRequestFilePath = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/RentalRequests.txt";
                    double currentTotalPayment = 0.0;
                    String orderNumber = (String) session.getAttribute("orderNumber") != null ? (String) session.getAttribute("orderNumber") : "N/A";
                    String bikeName = request.getParameter("bikeName");
                    String username = (String) session.getAttribute("username");

                    // Log initial parameters
                    System.out.println("UpdateRentDetails: bikeName (raw): " + bikeName);
                    System.out.println("UpdateRentDetails: username: " + username);
                    System.out.println("UpdateRentDetails: session orderNumber: " + orderNumber);

                    if (bikeName == null || username == null) {
                        System.out.println("UpdateRentDetails: bikeName or username is null");
                    } else {
                        try {
                            String decodedBikeName = URLDecoder.decode(bikeName, "UTF-8");
                            System.out.println("UpdateRentDetails: decodedBikeName: " + decodedBikeName);

                            // Fetch order number from RentalRequests.txt
                            List<String> rentalLines = Files.readAllLines(Paths.get(rentalRequestFilePath));
                            System.out.println("UpdateRentDetails: Total lines in RentalRequests.txt: " + rentalLines.size());
                            for (String line : rentalLines) {
                                if (line.trim().isEmpty()) {
                                    System.out.println("UpdateRentDetails: Skipping empty line in RentalRequests.txt");
                                    continue;
                                }
                                System.out.println("UpdateRentDetails: Processing RentalRequests line: " + line);
                                String[] rentalData = line.split("\\s*\\|\\s*");
                                System.out.println("UpdateRentDetails: Rental data length: " + rentalData.length);
                                if (rentalData.length == 9) {
                                    System.out.println("UpdateRentDetails: Rental data - OrderNumber: " + rentalData[0] + ", BikeName: " + rentalData[1] + ", Username: " + rentalData[2] + ", Status: " + rentalData[4]);
                                    if (rentalData[1].trim().equals(decodedBikeName) &&
                                            rentalData[2].trim().equals(username) &&
                                            rentalData[4].trim().equalsIgnoreCase("Accepted")) {
                                        orderNumber = rentalData[0].trim(); // 1st column is order number
                                        System.out.println("UpdateRentDetails: Found matching rental - orderNumber: " + orderNumber);
                                        break;
                                    }
                                } else {
                                    System.out.println("UpdateRentDetails: Invalid RentalRequests format, expected 9 fields, got: " + rentalData.length + ", line: " + line);
                                }
                            }
                            if ("N/A".equals(orderNumber)) {
                                System.out.println("UpdateRentDetails: No matching rental request found for bike: " + decodedBikeName + ", username: " + username);
                            }

                            // Fetch current total payment from Payment.txt
                            List<String> paymentLines = Files.readAllLines(Paths.get(paymentFilePath));
                            System.out.println("UpdateRentDetails: Total lines in Payment.txt: " + paymentLines.size());
                            for (String line : paymentLines) {
                                if (line.trim().isEmpty()) {
                                    System.out.println("UpdateRentDetails: Skipping empty line in Payment.txt");
                                    continue;
                                }
                                System.out.println("UpdateRentDetails: Processing Payment line: " + line);
                                String[] paymentData = line.split("\\s*\\|\\s*");
                                if (paymentData.length == 9) {
                                    System.out.println("UpdateRentDetails: Payment data - OrderNumber: " + paymentData[0] + ", BikeID: " + paymentData[1] + ", Username: " + paymentData[2] + ", Status: " + paymentData[4] + ", totalPayment: " + paymentData[6]);
                                    if (paymentData[1].trim().equals(decodedBikeName) &&
                                            paymentData[2].trim().equals(username) &&
                                            paymentData[4].trim().equalsIgnoreCase("Accepted")) {
                                        try {
                                            currentTotalPayment = Double.parseDouble(paymentData[6].trim().replaceAll("[^0-9.]", "")); // 7th column is totalPayment
                                            System.out.println("UpdateRentDetails: Found currentTotalPayment: " + currentTotalPayment);
                                        } catch (NumberFormatException e) {
                                            System.out.println("UpdateRentDetails: NumberFormatException for payment: " + paymentData[6] + ". Using 0.0. Error: " + e.getMessage());
                                            currentTotalPayment = 0.0;
                                        }
                                        break;
                                    }
                                } else {
                                    System.out.println("UpdateRentDetails: Invalid Payment format, expected 9 fields, got: " + paymentData.length);
                                }
                            }
                            if (currentTotalPayment == 0.0) {
                                System.out.println("UpdateRentDetails: No valid payment found for bike: " + decodedBikeName + ", username: " + username);
                            }
                        } catch (IOException e) {
                            System.out.println("UpdateRentDetails: Error reading files: " + e.getMessage());
                            currentTotalPayment = 0.0; // Fallback to 0 if file read fails
                        }
                    }
                %>
                <input type="hidden" name="currentTotalPayment" id="currentTotalPayment" value="<%= currentTotalPayment %>">
                <input type="hidden" id="totalPaymentInput" name="updatedTotalPayment" value="0.00">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" value="<%= username != null ? username : "N/A" %>" readonly>
                </div>
                <div class="form-group">
                    <label for="orderNumber">Order Number</label>
                    <input type="text" id="orderNumber" name="orderNumber" value="<%= orderNumber %>" readonly>
                </div>
                <div class="form-group">
                    <label for="rentalDays">Rental Days</label>
                    <input type="number" id="rentalDays" name="rentalDays" min="1" value="<%= request.getParameter("rentalDays") %>" required>
                </div>
                <div class="form-group additional-services">
                    <label>Additional Services ($25 each)</label>
                    <div class="checkbox-group">
                        <div>
                            <input type="checkbox" id="helmet" name="additionalServices" value="Helmet" <%= request.getParameter("helmet") != null ? "checked" : "" %>>
                            <label for="helmet">Helmet</label>
                        </div>
                        <div>
                            <input type="checkbox" id="gloves" name="additionalServices" value="Gloves" <%= request.getParameter("gloves") != null ? "checked" : "" %>>
                            <label for="gloves">Gloves</label>
                        </div>
                        <div>
                            <input type="checkbox" id="rainJacket" name="additionalServices" value="RainJacket" <%= request.getParameter("rainJacket") != null ? "checked" : "" %>>
                            <label for="rainJacket">Rain Jacket</label>
                        </div>
                    </div>
                </div>
                <div class="form-group current-payment">
                    <label>Current Total Payment:</label>
                    <div>$<%= String.format("%.2f", currentTotalPayment) %></div>
                </div>
            </div>
            <div class="card-footer">
                <a href="profile.jsp" class="btn btn-secondary">Close</a>
                <button type="submit" class="btn btn-update">Confirm Update</button>
            </div>
        </form>
    </div>
</div>
<script>
    function updateTotalPayment() {
        const pricePerHour = parseFloat(document.getElementById('pricePerHour').value) || 0;
        const rentalDays = parseInt(document.getElementById('rentalDays').value) || 1;
        const additionalServices = document.querySelectorAll('input[name="additionalServices"]:checked').length;
        const basePayment = pricePerHour * 24 * rentalDays;
        const additionalCost = additionalServices * 25.0;
        const totalPayment = basePayment + additionalCost;
        const totalPaymentInput = document.getElementById('totalPaymentInput');
        if (totalPaymentInput) {
            totalPaymentInput.value = totalPayment.toFixed(2);
        }
    }

    document.getElementById('rentalDays').addEventListener('input', updateTotalPayment);
    document.querySelectorAll('input[name="additionalServices"]').forEach(checkbox => {
        checkbox.addEventListener('change', updateTotalPayment);
    });

    updateTotalPayment();
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>