package com.swadkart.dao.impl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.swadkart.dao.RestaurantDao;
import com.swadkart.model.Restaurant;
import com.swadkart.util.DBConnection;

public class RestaurantDaoImpl implements RestaurantDao {

    @Override
    public List<Restaurant> getAllRestaurants() {
        return getAllRestaurants(null);
    }

    @Override
    public List<Restaurant> getAllRestaurants(String sortBy) {
        List<Restaurant> list = new ArrayList<>();
        String query = "SELECT * FROM restaurants WHERE is_open = TRUE";
        
        if ("rating".equalsIgnoreCase(sortBy)) {
            query += " ORDER BY avg_rating DESC";
        } else if ("newest".equalsIgnoreCase(sortBy)) {
            query += " ORDER BY created_at DESC";
        }
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Restaurant r = mapResultSetToRestaurant(rs);
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Restaurant getRestaurantById(long restaurantId) {
        Restaurant r = null;
        String query = "SELECT * FROM restaurants WHERE restaurant_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    r = mapResultSetToRestaurant(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return r;
    }

    @Override
    public List<Restaurant> getRestaurantsByType(String type) {
        List<Restaurant> list = new ArrayList<>();
        String query = "SELECT * FROM restaurants WHERE restaurant_type=? AND is_open=TRUE";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Restaurant r = mapResultSetToRestaurant(rs);
                    list.add(r);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Restaurant mapResultSetToRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId(rs.getLong("restaurant_id"));
        r.setName(rs.getString("name"));
        r.setAddress(rs.getString("address"));
        r.setLatitude(rs.getDouble("latitude"));
        r.setLongitude(rs.getDouble("longitude"));
        r.setEmail(rs.getString("email"));
        r.setPhone(rs.getString("phone"));
        r.setAvgRating(rs.getDouble("avg_rating"));
        r.setCuisineType(rs.getString("cuisine_type"));
        r.setOpeningTime(rs.getTime("opening_time"));
        r.setClosingTime(rs.getTime("closing_time"));
        r.setIsOpen(rs.getBoolean("is_open"));
        r.setImageUrl(rs.getString("image_url"));
        r.setRestaurantType(rs.getString("restaurant_type"));
        r.setCreatedAt(rs.getTimestamp("created_at"));
        return r;
    }
}