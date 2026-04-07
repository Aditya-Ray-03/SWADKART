package com.swadkart.dao;

import java.util.List;
import com.swadkart.model.CartItem;

public interface CartDao {

    void addToCart(long userId, long menuItemId, double price);
    List<CartItem> getCartItems(long userId);
    void updateQuantity(long userId, long menuItemId, int quantity);
    void removeItem(long userId, long menuItemId);
    void clearCart(long userId);
}