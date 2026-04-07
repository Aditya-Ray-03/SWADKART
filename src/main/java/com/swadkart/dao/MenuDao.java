package com.swadkart.dao;

import java.util.List;

import com.swadkart.model.MenuItem;

public interface MenuDao {

    List<MenuItem> getMenuByRestaurantId(long restaurantId);
    
    // Context-aware search (filtered by restaurant)
    List<MenuItem> getMenuByRestaurantId(long restaurantId, String keyword);
    
    // New global search method
    List<MenuItem> getMenuItemsByKeyword(String keyword);

    MenuItem getMenuItemById(long itemId);

}
