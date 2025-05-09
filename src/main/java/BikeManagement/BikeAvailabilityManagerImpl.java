package BikeManagement;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class BikeAvailabilityManagerImpl implements BikeAvailabilityManager {
    private static final String BIKES_FILE_PATH = "/Users/samadhithjayasena/Library/CloudStorage/OneDrive-SriLankaInstituteofInformationTechnology/IntelliJ IDEA/Website/src/main/resources/Bikes.txt";
    private static final Logger LOGGER = Logger.getLogger(BikeAvailabilityManagerImpl.class.getName());

    @Override
    public void updateBikeAvailability(String bikeName, String availability) {
        List<String> bikeLines;
        try {
            bikeLines = new ArrayList<>(Files.readAllLines(Paths.get(BIKES_FILE_PATH)));
        } catch (IOException e) {
            LOGGER.severe("Failed to read bikes file: " + e.getMessage());
            return;
        }

        boolean bikeFound = false;
        for (int i = 0; i < bikeLines.size(); i++) {
            String line = bikeLines.get(i).trim();
            if (line.isEmpty()) continue;
            String[] bikeData = line.split("\\s*\\|\\s*");
            if (bikeData.length < 5) continue;
            if (bikeData[0].equals(bikeName)) {
                bikeData[4] = availability;
                bikeLines.set(i, String.join(" | ", bikeData));
                bikeFound = true;
                break;
            }
        }

        if (!bikeFound) {
            LOGGER.warning("Bike not found: " + bikeName);
            return;
        }

        try (BufferedWriter writer = new BufferedWriter(new FileWriter(BIKES_FILE_PATH))) {
            for (String line : bikeLines) {
                if (!line.trim().isEmpty()) {
                    writer.write(line);
                    writer.newLine();
                }
            }
        } catch (IOException e) {
            LOGGER.severe("Failed to update bikes file: " + e.getMessage());
        }
    }
}