package com.swadkart.dao;

import java.util.List;
import com.swadkart.model.Order;
import com.swadkart.model.CartItem;

public interface OrderDao {
    List<Order> getOrdersByUserId(long userId);
    Order getOrderById(long orderId);
    long placeOrder(Order order, List<CartItem> items);
}
