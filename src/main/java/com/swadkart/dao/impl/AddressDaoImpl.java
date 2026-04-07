package com.swadkart.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.swadkart.dao.AddressDao;
import com.swadkart.model.Address;
import com.swadkart.util.DBConnection;

public class AddressDaoImpl implements AddressDao {

    @Override
    public List<Address> getAddressesByUserId(long userId) {
        List<Address> list = new ArrayList<>();
        String query = "SELECT * FROM addresses WHERE user_id = ? ORDER BY is_default DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address addr = mapResultSetToAddress(rs);
                    list.add(addr);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Address getDefaultAddress(long userId) {
        Address addr = null;
        String query = "SELECT * FROM addresses WHERE user_id = ? AND is_default = true LIMIT 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    addr = mapResultSetToAddress(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return addr;
    }

    @Override
    public boolean addAddress(Address addr) {
        boolean success = false;
        String query = "INSERT INTO addresses (user_id, flat_no, floor_no, street, landmark, city, pincode, latitude, longitude, google_map_link, is_default) " +
                       "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setLong(1, addr.getUserId());
            ps.setString(2, addr.getFlatNo());
            ps.setString(3, addr.getFloorNo());
            ps.setString(4, addr.getStreet());
            ps.setString(5, addr.getLandmark());
            ps.setString(6, addr.getCity());
            ps.setString(7, addr.getPincode());
            ps.setDouble(8, addr.getLatitude());
            ps.setDouble(9, addr.getLongitude());
            ps.setString(10, addr.getGoogleMapLink());
            ps.setBoolean(11, addr.isDefault());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                success = true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    private Address mapResultSetToAddress(ResultSet rs) throws Exception {
        Address addr = new Address();
        addr.setAddressId(rs.getLong("address_id"));
        addr.setUserId(rs.getLong("user_id"));
        addr.setFlatNo(rs.getString("flat_no"));
        addr.setFloorNo(rs.getString("floor_no"));
        addr.setStreet(rs.getString("street"));
        addr.setLandmark(rs.getString("landmark"));
        addr.setCity(rs.getString("city"));
        addr.setPincode(rs.getString("pincode"));
        addr.setLatitude(rs.getDouble("latitude"));
        addr.setLongitude(rs.getDouble("longitude"));
        addr.setGoogleMapLink(rs.getString("google_map_link"));
        addr.setIsDefault(rs.getBoolean("is_default"));
        return addr;
    }
}
