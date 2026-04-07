package com.swadkart.dao.impl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.swadkart.dao.CartDao;
import com.swadkart.model.CartItem;
import com.swadkart.util.DBConnection;

public class CartDaoImpl implements CartDao {

    @Override
    public void addToCart(long userId, long menuItemId, double price) {
        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);
            long cartId = -1;

            // 1️⃣ Check if cart exists
            String cartQuery = "SELECT cart_id FROM cart WHERE user_id = ?";
            try (PreparedStatement ps1 = con.prepareStatement(cartQuery)) {
                ps1.setLong(1, userId);
                try (ResultSet rs = ps1.executeQuery()) {
                    if (rs.next()) {
                        cartId = rs.getLong("cart_id");
                    }
                }
            }

            if (cartId == -1) {
                // create new cart
                String insertCart = "INSERT INTO cart(user_id, created_at, updated_at) VALUES (?, NOW(), NOW())";
                try (PreparedStatement ps2 = con.prepareStatement(insertCart, Statement.RETURN_GENERATED_KEYS)) {
                    ps2.setLong(1, userId);
                    ps2.executeUpdate();
                    try (ResultSet keys = ps2.getGeneratedKeys()) {
                        if (keys.next()) {
                            cartId = keys.getLong(1);
                        }
                    }
                }
            }

            if (cartId != -1) {
                // 2️⃣ Check if item already exists
                String checkItem = "SELECT quantity FROM cart_items WHERE cart_id = ? AND menu_item_id = ?";
                int quantity = 0;
                try (PreparedStatement ps3 = con.prepareStatement(checkItem)) {
                    ps3.setLong(1, cartId);
                    ps3.setLong(2, menuItemId);
                    try (ResultSet rs2 = ps3.executeQuery()) {
                        if (rs2.next()) {
                            quantity = rs2.getInt("quantity");
                        }
                    }
                }

                if (quantity > 0) {
                    // update quantity
                    String update = "UPDATE cart_items SET quantity = quantity + 1 WHERE cart_id = ? AND menu_item_id = ?";
                    try (PreparedStatement ps4 = con.prepareStatement(update)) {
                        ps4.setLong(1, cartId);
                        ps4.setLong(2, menuItemId);
                        ps4.executeUpdate();
                    }
                } else {
                    // insert new item
                    String insertItem = "INSERT INTO cart_items(cart_id, menu_item_id, quantity, price) VALUES (?, ?, 1, ?)";
                    try (PreparedStatement ps5 = con.prepareStatement(insertItem)) {
                        ps5.setLong(1, cartId);
                        ps5.setLong(2, menuItemId);
                        ps5.setDouble(3, price);
                        ps5.executeUpdate();
                    }
                }
                con.commit();
            } else {
                con.rollback();
            }
        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (SQLException se) { se.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (con != null) {
                try { con.close(); } catch (SQLException se) { se.printStackTrace(); }
            }
        }
    }

    @Override
    public List<CartItem> getCartItems(long userId) {
        List<CartItem> items = new java.util.ArrayList<>();
        String query = "SELECT ci.*, mi.name as item_name FROM cart_items ci " +
                       "JOIN cart c ON ci.cart_id = c.cart_id " +
                       "JOIN menu_items mi ON ci.menu_item_id = mi.item_id " +
                       "WHERE c.user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemId(rs.getLong("cart_item_id"));
                    item.setCartId(rs.getLong("cart_id"));
                    item.setMenuItemId(rs.getLong("menu_item_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setItemName(rs.getString("item_name"));
                    items.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public void updateQuantity(long userId, long menuItemId, int quantity) {
        String query = "UPDATE cart_items ci JOIN cart c ON ci.cart_id = c.cart_id " +
                       "SET ci.quantity = ? WHERE c.user_id = ? AND ci.menu_item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, quantity);
            ps.setLong(2, userId);
            ps.setLong(3, menuItemId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void removeItem(long userId, long menuItemId) {
        String query = "DELETE ci FROM cart_items ci JOIN cart c ON ci.cart_id = c.cart_id " +
                       "WHERE c.user_id = ? AND ci.menu_item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, userId);
            ps.setLong(2, menuItemId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void clearCart(long userId) {
        String query = "DELETE ci FROM cart_items ci JOIN cart c ON ci.cart_id = c.cart_id " +
                       "WHERE c.user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}