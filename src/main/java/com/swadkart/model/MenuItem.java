package com.swadkart.model;

import java.sql.Timestamp;

public class MenuItem {
	private long itemId;
	private long restaurantId;
	private long categoryId;
	private String name;
	private String description;
	private double price;
	private String imageUrl;
	private boolean isAvailable;
	private Timestamp createdAt;
	private String foodType;

	public MenuItem() {
	}

	public MenuItem(long itemId, long restaurantId, long categoryId, String name, String description, double price,
			String imageUrl, boolean isAvailable, Timestamp createdAt, String foodType) {
		this.itemId = itemId;
		this.restaurantId = restaurantId;
		this.categoryId = categoryId;
		this.name = name;
		this.description = description;
		this.price = price;
		this.imageUrl = imageUrl;
		this.isAvailable = isAvailable;
		this.createdAt = createdAt;
		this.foodType = foodType;
	}

	public long getItemId() {
		return itemId;
	}

	public void setItemId(long itemId) {
		this.itemId = itemId;
	}

	public long getRestaurantId() {
		return restaurantId;
	}

	public void setRestaurantId(long restaurantId) {
		this.restaurantId = restaurantId;
	}

	public long getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(long categoryId) {
		this.categoryId = categoryId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public double getPrice() {
		return price;
	}

	public void setPrice(double price) {
		this.price = price;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public boolean isAvailable() {
		return isAvailable;
	}

	public void setIsAvailable(boolean isAvailable) {
		this.isAvailable = isAvailable;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public String getFoodType() {
		return foodType;
	}

	public void setFoodType(String foodType) {
		this.foodType = foodType;
	}

	@Override
	public String toString() {
		return "MenuItem [itemId=" + itemId + ", restaurantId=" + restaurantId + ", categoryId=" + categoryId
				+ ", name=" + name + ", description=" + description + ", price=" + price + ", imageUrl=" + imageUrl
				+ ", isAvailable=" + isAvailable + ", createdAt=" + createdAt + ", foodType=" + foodType + "]";
	}

}
