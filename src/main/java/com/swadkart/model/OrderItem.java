package com.swadkart.model;

public class OrderItem {
	private long orderItemId;
	private long orderId;
	private long menuItemId;
	private int quantity;
	private double price;
	private double totalPrice;

	public OrderItem() {
	}

	public OrderItem(long orderItemId, long orderId, long menuItemId, int quantity, double price, double totalPrice) {
		this.orderItemId = orderItemId;
		this.orderId = orderId;
		this.menuItemId = menuItemId;
		this.quantity = quantity;
		this.price = price;
		this.totalPrice = totalPrice;
	}

	public long getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(long orderItemId) {
		this.orderItemId = orderItemId;
	}

	public long getOrderId() {
		return orderId;
	}

	public void setOrderId(long orderId) {
		this.orderId = orderId;
	}

	public long getMenuItemId() {
		return menuItemId;
	}

	public void setMenuItemId(long menuItemId) {
		this.menuItemId = menuItemId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public double getTotalPrice() {
		return totalPrice;
	}

	public void setTotalPrice(double totalPrice) {
		this.totalPrice = totalPrice;
	}

	@Override
	public String toString() {
		return "OrderItem [orderItemId=" + orderItemId + ", orderId=" + orderId + ", menuItemId=" + menuItemId
				+ ", quantity=" + quantity + ", price=" + price + ", totalPrice=" + totalPrice + "]";
	}

}
