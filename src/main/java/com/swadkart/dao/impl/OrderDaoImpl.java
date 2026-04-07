package com.swadkart.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.swadkart.dao.OrderDao;
import com.swadkart.model.Order;
import com.swadkart.model.CartItem;
import com.swadkart.util.DBConnection;

public class OrderDaoImpl implements OrderDao {

    @Override
    public List<Order> getOrdersByUserId(long userId) {
        List<Order> list = new ArrayList<>();
        String query = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    order.setOrderId(rs.getLong("order_id"));
                    order.setUserId(rs.getLong("user_id"));
                    order.setRestaurantId(rs.getLong("restaurant_id"));
                    order.setAddressId(rs.getLong("address_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Order getOrderById(long orderId) {
        Order order = null;
        String query = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new Order();
                    order.setOrderId(rs.getLong("order_id"));
                    order.setUserId(rs.getLong("user_id"));
                    order.setRestaurantId(rs.getLong("restaurant_id"));
                    order.setAddressId(rs.getLong("address_id"));
                    order.setTotalAmount(rs.getDouble("total_amount"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setPaymentMethod(rs.getString("payment_method"));
                    order.setPaymentStatus(rs.getString("payment_status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    @Override
    public long placeOrder(Order order, List<CartItem> items) {
        long orderId = -1;
        String query = "INSERT INTO orders(user_id, restaurant_id, address_id, total_amount, order_status, payment_method, payment_status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        String itemQuery = "INSERT INTO order_items(order_id, menu_item_id, quantity, price, total_price) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement ps = con.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, order.getUserId());
                ps.setLong(2, order.getRestaurantId());
                ps.setLong(3, order.getAddressId());
                ps.setDouble(4, order.getTotalAmount());
                ps.setString(5, "PLACED");
                ps.setString(6, order.getPaymentMethod());
                ps.setString(7, "PAID");

                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) throw new Exception("Creating order failed.");

                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        orderId = generatedKeys.getLong(1);
                    } else {
                        throw new Exception("Creating order failed, no ID obtained.");
                    }
                }

                try (PreparedStatement itemPs = con.prepareStatement(itemQuery)) {
                    for (CartItem item : items) {
                        itemPs.setLong(1, orderId);
                        itemPs.setLong(2, item.getMenuItemId());
                        itemPs.setInt(3, item.getQuantity());
                        itemPs.setDouble(4, item.getPrice());
                        itemPs.setDouble(5, item.getPrice() * item.getQuantity());
                        itemPs.addBatch();
                    }
                    itemPs.executeBatch();
                }
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
        return orderId;
    }
}
