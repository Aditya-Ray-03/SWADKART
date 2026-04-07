package com.swadkart.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.swadkart.dao.UserDao;
import com.swadkart.model.User;
import com.swadkart.util.DBConnection;

/**
 * Data Access Object Implementation for User mappings.
 * Serves as the primary bridge between the database 'users' table 
 * and the Swiggy-like OTP Authentication Flow.
 */
public class UserDaoImpl implements UserDao {

    @Override
    public User getUserByPhone(String phone) {
        User user = null;
        String query = "SELECT * FROM users WHERE phone = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getLong("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                    user.setIsVerified(rs.getBoolean("is_verified"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setLastLogin(rs.getTimestamp("last_login"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }

    @Override
    public boolean registerUserPhone(String phone, String name, String email) {
        boolean success = false;
        String query = "INSERT INTO users(full_name, email, phone, role, is_verified, created_at, last_login) VALUES (?, ?, ?, ?, ?, NOW(), NOW())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, "USER");
            ps.setBoolean(5, true); 
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
    @Override
    public boolean updateUser(User user) {
        boolean success = false;
        String query = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setLong(4, user.getUserId());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}
