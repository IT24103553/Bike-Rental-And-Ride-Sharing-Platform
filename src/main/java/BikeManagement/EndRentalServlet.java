package BikeManagement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/EndRentalServlet")
public class EndRentalServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EndRentalServlet.class.getName());
    private final BikeAvailabilityManager bikeAvailabilityManager;

    public EndRentalServlet() {
        this.bikeAvailabilityManager = new BikeAvailabilityManagerImpl();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bikeName = request.getParameter("bikeName");
        if (bikeName == null || bikeName.trim().isEmpty()) {
            LOGGER.warning("Bike name is missing in EndRentalServlet");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Bike name is missing.");
            return;
        }

        LOGGER.info("Ending rental for bike: " + bikeName);

        // Clear session attributes
        request.getSession().removeAttribute("isRented_" + bikeName);
        request.getSession().removeAttribute("renterUsername_" + bikeName);
        request.getSession().removeAttribute("rentalEndTime_" + bikeName);
        LOGGER.info("Cleared session attributes for bike: " + bikeName);

        // Update bike availability to "Available"
        bikeAvailabilityManager.updateBikeAvailability(bikeName, "Available");
        LOGGER.info("Updated bike availability to Available for bike: " + bikeName);

        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write("Rental ended successfully for bike: " + bikeName);
    }
}