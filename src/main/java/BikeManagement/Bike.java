package BikeManagement;

public class Bike {
    private String name;
    private String photoPath;
    private String price;
    private String owner;
    private String availability;

    public Bike(String name, String photoPath, String price, String owner, String availability) {
        this.name = name;
        this.photoPath = photoPath;
        this.price = price;
        this.owner = owner;
        this.availability = availability;
    }

    public String getName() { return name; }
    public String getPhotoPath() { return photoPath; }
    public String getPrice() { return price; }
    public String getOwner() { return owner; }
    public String getAvailability() { return availability; }
}
