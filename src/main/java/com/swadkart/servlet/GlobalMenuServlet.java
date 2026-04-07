package com.swadkart.servlet;

import java.io.IOException;
import java.util.List;

import com.swadkart.dao.MenuDao;
import com.swadkart.dao.impl.MenuDaoImpl;
import com.swadkart.model.MenuItem;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/searchMenu")
public class GlobalMenuServlet extends HttpServlet {

    private MenuDao menuDao;

    /**
     * Bootstraps the Servlet with the Menu Data Access Object.
     */
    @Override
    public void init() throws ServletException {
        menuDao = new MenuDaoImpl();
    }

    /**
     * Intercepts GET requests for global searches. Parses the 'query' parameter
     * and fetches items matching the keyword seamlessly across all integrated restaurants.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Get search query from URL
        String query = request.getParameter("query");

        if (query == null || query.trim().isEmpty()) {
            response.sendRedirect("index.jsp");
            return;
        }

        // 2️⃣ Fetch ALL items matching keyword across all restaurants
        List<MenuItem> searchResults = menuDao.getMenuItemsByKeyword(query.trim());

        // 3️⃣ Send to JSP
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("searchQuery", query.trim()); 

        RequestDispatcher rd = request.getRequestDispatcher("search-results.jsp");
        rd.forward(request, response);
    }
}
