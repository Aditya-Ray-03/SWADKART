package com.swadkart.servlet;

import java.io.IOException;
import java.util.List;

import com.swadkart.dao.RestaurantDao;
import com.swadkart.dao.impl.RestaurantDaoImpl;
import com.swadkart.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Main servlet handling the Landing Page and /restaurants feeds.
 * Pulls all currently active and available restaurants from the database.
 */
@WebServlet("/restaurants")
public class RestaurantServlet extends HttpServlet {

    private RestaurantDao restaurantDao;

    /**
     * Mounts the Restaurant DAO.
     */
    @Override
    public void init() throws ServletException {
        restaurantDao = new RestaurantDaoImpl();
    }

    /**
     * Parses the incoming standard GET requests and fetches the primary 
     * generic view of all platform restaurants.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sortBy = request.getParameter("sortBy");
        
        // Fetch data from DAO for Home Screen or restaurant section
        List<Restaurant> restaurants = restaurantDao.getAllRestaurants(sortBy);

        // 2️⃣ Set data to request scope
        request.setAttribute("restaurantList", restaurants);
        request.setAttribute("currentSort", sortBy);

        // 3️⃣ Forward to JSP
        RequestDispatcher rd = request.getRequestDispatcher("restaurants.jsp");
        rd.forward(request, response);
    }
}