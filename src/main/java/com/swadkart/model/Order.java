package com.swadkart.model;

import java.sql.Timestamp;

public class Order {

	private long orderId;
	private long userId;
	private long restaurantId;
	private long addressId;
	private double totalAmount;
	private String orderStatus; // PLACED, PREPARING, OUT_FOR_DELIVERY, DELIVERED, CANCELLED
	private String paymentMethod; // COD, UPI, CARD
	private String paymentStatus; // PENDING, PAID, FAILED
	private Timestamp createdAt;

	public Order() {
	}

	public Order(long orderId, long userId, long restaurantId, long addressId, double totalAmount, String orderStatus,
			String paymentMethod, String paymentStatus, Timestamp createdAt) {
		this.orderId = orderId;
		this.userId = userId;
		this.restaurantId = restaurantId;
		this.addressId = addressId;
		this.totalAmount = totalAmount;
		this.orderStatus = orderStatus;
		this.paymentMethod = paymentMethod;
		this.paymentStatus = paymentStatus;
		this.createdAt = createdAt;
	}

	public long getOrderId() {
		return orderId;
	}

	public void setOrderId(long orderId) {
		this.orderId = orderId;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public long getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(long restaurantId) {
		this.restaurantId = restaurantId;
	}

	public long getAddressId() {
		return addressId;
	}

	public void setAddressId(long addressId) {
		this.addressId = addressId;
	}

	public double getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "Order [orderId=" + orderId + ", userId=" + userId + ", restaurantId=" + restaurantId + ", addressId="
				+ addressId + ", totalAmount=" + totalAmount + ", orderStatus=" + orderStatus + ", paymentMethod="
				+ paymentMethod + ", paymentStatus=" + paymentStatus + ", createdAt=" + createdAt + "]";
	}

}
