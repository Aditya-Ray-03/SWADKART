package com.swadkart.dao;

import com.swadkart.model.User;

public interface UserDao {
    User getUserByPhone(String phone);
    boolean registerUserPhone(String phone, String name, String email);
    boolean updateUser(User user);
}
