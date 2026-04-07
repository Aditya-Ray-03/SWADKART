package com.swadkart.dao;

import java.util.List;
import com.swadkart.model.Restaurant;

public interface RestaurantDao {

    List<Restaurant> getAllRestaurants();
    
    List<Restaurant> getAllRestaurants(String sortBy);

    Restaurant getRestaurantById(long restaurantId);

    List<Restaurant> getRestaurantsByType(String type);
}