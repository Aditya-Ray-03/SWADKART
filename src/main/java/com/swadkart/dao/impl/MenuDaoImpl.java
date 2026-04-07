package com.swadkart.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.swadkart.dao.MenuDao;
import com.swadkart.model.MenuItem;
import com.swadkart.util.DBConnection;

public class MenuDaoImpl implements MenuDao {

    @Override
    public List<MenuItem> getMenuByRestaurantId(long restaurantId) {
        return getMenuByRestaurantId(restaurantId, null);
    }

    @Override
    public List<MenuItem> getMenuByRestaurantId(long restaurantId, String keyword) {
        List<MenuItem> list = new ArrayList<>();
        String query = "SELECT * FROM menu_items WHERE restaurant_id = ? AND is_available = TRUE";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            query += " AND LOWER(name) LIKE LOWER(?)";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, restaurantId);
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(2, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuItem item = mapResultSetToMenuItem(rs);
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<MenuItem> getMenuItemsByKeyword(String keyword) {
        List<MenuItem> list = new ArrayList<>();
        // Search anywhere in the name (case-insensitive depending on DB, but standard LIKE is often fine. MySQL is case-insensitive by default)
        String query = "SELECT * FROM menu_items WHERE LOWER(name) LIKE LOWER(?) AND is_available = TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuItem item = mapResultSetToMenuItem(rs);
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<MenuItem> getAllMenuItems(int limit) {
        List<MenuItem> list = new ArrayList<>();
        String query = "SELECT * FROM menu_items WHERE is_available = TRUE ORDER BY RAND() LIMIT ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MenuItem item = mapResultSetToMenuItem(rs);
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public MenuItem getMenuItemById(long itemId) {
        String query = "SELECT * FROM menu_items WHERE item_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, itemId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToMenuItem(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private MenuItem mapResultSetToMenuItem(ResultSet rs) throws java.sql.SQLException {
        MenuItem item = new MenuItem();
        item.setItemId(rs.getLong("item_id"));
        item.setRestaurantId(rs.getLong("restaurant_id"));
        item.setCategoryId(rs.getLong("category_id"));
        item.setName(rs.getString("name"));
        item.setDescription(rs.getString("description"));
        item.setPrice(rs.getDouble("price"));
        item.setImageUrl(rs.getString("image_url"));
        item.setIsAvailable(rs.getBoolean("is_available"));
        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setFoodType(rs.getString("food_type"));
        return item;
    }
}