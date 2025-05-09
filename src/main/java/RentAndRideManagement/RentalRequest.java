package RentAndRideManagement;

public class RentalRequest {
    private String requestId;
    private String bikeId;
    private String renterUsername;
    private String email;
    private String status;
    private String rentalDays;
    private String totalPayment;
    private String additionalServices;
    private String fileName;

    public RentalRequest(String requestId, String bikeId, String renterUsername, String email, String status, String rentalDays, String totalPayment, String additionalServices, String fileName) {
        this.requestId = requestId;
        this.bikeId = bikeId;
        this.renterUsername = renterUsername;
        this.email = email;
        this.status = status;
        this.rentalDays = rentalDays;
        this.totalPayment = totalPayment;
        this.additionalServices = additionalServices;
        this.fileName = fileName;
    }

    public String getRequestId() {
        return requestId;
    }

    public String getBikeId() {
        return bikeId;
    }

    public String getRenterUsername() {
        return renterUsername;
    }

    public String getEmail() {
        return email;
    }

    public String getStatus() {
        return status;
    }

    public String getRentalDays() {
        return rentalDays;
    }

    public String getTotalPayment() {
        return totalPayment;
    }

    public String getAdditionalServices() {
        return additionalServices;
    }

    public String getFileName() {
        return fileName;
    }
}