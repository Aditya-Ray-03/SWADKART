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

@WebServlet("/dishes")
public class DishesServlet extends HttpServlet {

    private MenuDao menuDao;

    @Override
    public void init() throws ServletException {
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fetch 60 random items for the global discovery page
        List<MenuItem> allDishes = menuDao.getAllMenuItems(60);

        request.setAttribute("searchResults", allDishes);
        
        RequestDispatcher rd = request.getRequestDispatcher("dishes.jsp");
        rd.forward(request, response);
    }
}
