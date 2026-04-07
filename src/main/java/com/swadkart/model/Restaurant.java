package com.swadkart.model;

import java.sql.Time;
import java.sql.Timestamp;

public class Restaurant {
	private long restaurantId;
	private String name;
	private String address;
	private double latitude;
	private double longitude;
	private String email;
	private String phone;
	private double avgRating;
	private String cuisineType;
	private Time openingTime;
	private Time closingTime;
	private boolean isOpen;
	private String imageUrl;
	private String restaurantType; // restaurantType: VEG, NON_VEG, PURE_VEG
	private Timestamp createdAt;

	public Restaurant() {
	}

	public Restaurant(long restaurantId, String name, String address, double latitude, double longitude, String email,
			String phone, double avgRating, String cuisineType, Time openingTime, Time closingTime, boolean isOpen,
			String imageUrl, String restaurantType, Timestamp createdAt) {
		this.restaurantId = restaurantId;
		this.name = name;
		this.address = address;
		this.latitude = latitude;
		this.longitude = longitude;
		this.email = email;
		this.phone = phone;
		this.avgRating = avgRating;
		this.cuisineType = cuisineType;
		this.openingTime = openingTime;
		this.closingTime = closingTime;
		this.isOpen = isOpen;
		this.imageUrl = imageUrl;
		this.restaurantType = restaurantType;
		this.createdAt = createdAt;
	}

	public long getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(long restaurantId) {
		this.restaurantId = restaurantId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public double getAvgRating() {
		return avgRating;
	}

	public void setAvgRating(double avgRating) {
		this.avgRating = avgRating;
	}

	public String getCuisineType() {
		return cuisineType;
	}

	public void setCuisineType(String cuisineType) {
		this.cuisineType = cuisineType;
	}

	public Time getOpeningTime() {
		return openingTime;
	}

	public void setOpeningTime(Time openingTime) {
		this.openingTime = openingTime;
	}

	public Time getClosingTime() {
		return closingTime;
	}

	public void setClosingTime(Time closingTime) {
		this.closingTime = closingTime;
	}

	public boolean isOpen() {
		return isOpen;
	}

	public void setIsOpen(boolean isOpen) {
		this.isOpen = isOpen;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getRestaurantType() {
		return restaurantType;
	}

	public void setRestaurantType(String restaurantType) {
		this.restaurantType = restaurantType;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	@Override
	public String toString() {
		return "Restaurant [restaurantId=" + restaurantId + ", name=" + name + ", address=" + address + ", latitude="
				+ latitude + ", longitude=" + longitude + ", email=" + email + ", phone=" + phone + ", avgRating="
				+ avgRating + ", cuisineType=" + cuisineType + ", openingTime=" + openingTime + ", closingTime="
				+ closingTime + ", isOpen=" + isOpen + ", imageUrl=" + imageUrl + ", restaurantType=" + restaurantType
				+ ", createdAt=" + createdAt + "]";
	}

}
