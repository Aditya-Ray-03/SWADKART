package com.swadkart.servlet;

import java.io.IOException;

import com.swadkart.dao.AddressDao;
import com.swadkart.dao.impl.AddressDaoImpl;
import com.swadkart.model.Address;
import com.swadkart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addAddress")
public class AddressServlet extends HttpServlet {
    private AddressDao addressDao;

    @Override
    public void init() throws ServletException {
        addressDao = new AddressDaoImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String flatNo = req.getParameter("flatNo");
        String floorNo = req.getParameter("floorNo");
        String street = req.getParameter("street");
        String landmark = req.getParameter("landmark");
        String city = req.getParameter("city");
        String pincode = req.getParameter("pincode");

        Address addr = new Address();
        addr.setUserId(user.getUserId());
        addr.setFlatNo(flatNo);
        addr.setFloorNo(floorNo);
        addr.setStreet(street);
        addr.setLandmark(landmark);
        addr.setCity(city);
        addr.setPincode(pincode);
        addr.setIsDefault(false); // New addresses are not default by default

        boolean success = addressDao.addAddress(addr);

        if (success) {
            resp.setStatus(HttpServletResponse.SC_OK);
        } else {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
