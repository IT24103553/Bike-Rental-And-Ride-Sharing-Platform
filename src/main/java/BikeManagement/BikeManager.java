package BikeManagement;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class BikeManager {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";

    // Method to update bike availability
    public static void updateBikeAvailability(String bikeName, String status) throws IOException {
        List<String> bikeLines = readBikeData();
        for (int i = 0; i < bikeLines.size(); i++) {
            String line = bikeLines.get(i).trim();
            if (line.isEmpty()) continue;
            String[] bikeData = line.split("\\s*\\|\\s*");
            if (bikeData.length != 6) continue;
            if (bikeData[0].equals(bikeName)) {
                bikeData[4] = status; // Update availability
                bikeLines.set(i, String.join(" | ", bikeData));
                break;
            }
        }
        writeBikeData(bikeLines);
    }

    // Method to read bike data
    private static List<String> readBikeData() throws IOException {
        return Files.readAllLines(Paths.get(BIKES_FILE_PATH));
    }

    // Method to write bike data
    private static void writeBikeData(List<String> bikeLines) throws IOException {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(BIKES_FILE_PATH))) {
            for (String line : bikeLines) {
                if (!line.trim().isEmpty()) {
                    writer.write(line);
                    writer.newLine();
                }
            }
        }
    }
}