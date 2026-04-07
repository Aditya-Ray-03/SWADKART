package com.swadkart.servlet;

import java.io.IOException;

import com.swadkart.dao.CartDao;
import com.swadkart.dao.impl.CartDaoImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.swadkart.model.User;
import com.swadkart.model.MenuItem;
import com.swadkart.dao.MenuDao;
import com.swadkart.dao.impl.MenuDaoImpl;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private CartDao cartDao;
    private MenuDao menuDao;

    @Override
    public void init() {
        cartDao = new CartDaoImpl();
        menuDao = new MenuDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "add";

        long userId = user.getUserId();
        String restaurantId = request.getParameter("restaurantId");
        String menuItemIdStr = request.getParameter("menuItemId");
        String quantityStr = request.getParameter("quantity");

        System.out.println("CartAction: " + action + ", User: " + userId + ", Item: " + menuItemIdStr + ", Qty: " + quantityStr);

        try {
            if ("add".equals(action)) {
                if (menuItemIdStr != null) {
                    long menuItemId = Long.parseLong(menuItemIdStr);
                    // SECURITY FIX: Fetch price from DB, do NOT trust request parameter
                    MenuItem item = menuDao.getMenuItemById(menuItemId);
                    if (item != null) {
                        cartDao.addToCart(userId, menuItemId, item.getPrice());
                    } else {
                        throw new Exception("Invalid Menu Item");
                    }
                }
            } else if ("remove".equals(action)) {
                if (menuItemIdStr != null) {
                    long menuItemId = Long.parseLong(menuItemIdStr);
                    cartDao.removeItem(userId, menuItemId);
                }
            } else if ("update".equals(action)) {
                if (menuItemIdStr != null && quantityStr != null) {
                    long menuItemId = Long.parseLong(menuItemIdStr);
                    int quantity = Integer.parseInt(quantityStr);
                    if (quantity <= 0) {
                        cartDao.removeItem(userId, menuItemId);
                    } else {
                        cartDao.updateQuantity(userId, menuItemId, quantity);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Error in CartServlet action: " + e.getMessage());
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\":false, \"error\":\"" + e.getMessage() + "\"}");
                return;
            }
        }

        String isAjax = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(isAjax)) {
            java.util.List<com.swadkart.model.CartItem> items = cartDao.getCartItems(userId);
            double total = 0;
            int count = 0;
            for (com.swadkart.model.CartItem item : items) {
                total += (item.getPrice() * item.getQuantity());
                count += item.getQuantity();
            }
            response.setContentType("application/json");
            response.getWriter().write("{\"success\":true, \"cartCount\":" + count + ", \"cartTotal\":" + total + "}");
            return;
        }

        if (restaurantId != null && !restaurantId.isEmpty()) {
            response.sendRedirect("menu?restaurantId=" + restaurantId);
        } else {
            response.sendRedirect("checkout.jsp");
        }
    }
}