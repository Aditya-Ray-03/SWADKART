package com.swadkart.servlet;

import java.io.IOException;
import java.util.List;

import com.swadkart.dao.CartDao;
import com.swadkart.dao.OrderDao;
import com.swadkart.dao.impl.CartDaoImpl;
import com.swadkart.dao.impl.OrderDaoImpl;
import com.swadkart.model.CartItem;
import com.swadkart.model.Order;
import com.swadkart.model.User;
import com.swadkart.model.MenuItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CartDao cartDao;
    private OrderDao orderDao;
    private com.swadkart.dao.MenuDao menuDao;

    @Override
    public void init() {
        cartDao = new CartDaoImpl();
        orderDao = new OrderDaoImpl();
        menuDao = new com.swadkart.dao.impl.MenuDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        List<CartItem> cartItems = cartDao.getCartItems(user.getUserId());
        if (cartItems.isEmpty()) {
            response.sendRedirect("restaurants");
            return;
        }

        request.setAttribute("cartItems", cartItems);
        request.getRequestDispatcher("checkout.jsp").forward(request, response);
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

        long userId = user.getUserId();
        long addressId;
        try {
            addressId = Long.parseLong(request.getParameter("addressId"));
        } catch (NumberFormatException | NullPointerException e) {
            request.setAttribute("errorMessage", "Invalid delivery address selected.");
            doGet(request, response);
            return;
        }
        String paymentMethod = request.getParameter("paymentMethod");
        // FIX: Recalculate total amount server-side to prevent client-side manipulation
        List<CartItem> cartItems = cartDao.getCartItems(userId);
        if (cartItems.isEmpty()) {
            response.sendRedirect("restaurants");
            return;
        }

        double calculatedTotal = 0.0;
        for (CartItem item : cartItems) {
            calculatedTotal += item.getPrice() * item.getQuantity();
        }
        
        // Match standard checkout.jsp calculation: Subtotal + ₹40 Delivery + 5% Taxes
        double finalTotal = (calculatedTotal + 40 + Math.round(calculatedTotal * 0.05));
        
        long restaurantId;
        try {
            String restIdParam = request.getParameter("restaurantId");
            restaurantId = (restIdParam != null && !restIdParam.isEmpty()) ? Long.parseLong(restIdParam) : 0;
        } catch (NumberFormatException e) {
            restaurantId = 0;
        }

        if (restaurantId <= 0) {
            // Fallback to first item's restaurant if parameter is missing or invalid
            if (!cartItems.isEmpty()) {
                com.swadkart.model.MenuItem firstItem = menuDao.getMenuItemById(cartItems.get(0).getMenuItemId());
                restaurantId = (firstItem != null) ? firstItem.getRestaurantId() : 1;
            } else {
                restaurantId = 1;
            }
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setRestaurantId(restaurantId);
        order.setAddressId(addressId);
        order.setTotalAmount(finalTotal); // Using server-calculated total with fees/taxes
        order.setOrderStatus("PLACED");
        order.setPaymentMethod(paymentMethod);
        order.setPaymentStatus("ONLINE".equalsIgnoreCase(paymentMethod) ? "PAID" : "PENDING");

        long orderId = orderDao.placeOrder(order, cartItems);

        if (orderId > 0) {
            cartDao.clearCart(userId);
            response.sendRedirect("order-success.jsp?orderId=" + orderId);
        } else {
            request.setAttribute("errorMessage", "Failed to place order. Please try again.");
            doGet(request, response);
        }
    }
}
