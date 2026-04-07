package com.swadkart.model;

public class MenuCategory {
	private long categoryId;
	private long restaurantId;
	private String name;
	private boolean isActive;// isActive: true → visible, false → hidden

	public MenuCategory() {
	}

	public MenuCategory(long categoryId, long restaurantId, String name, boolean isActive) {
		this.categoryId = categoryId;
		this.restaurantId = restaurantId;
		this.name = name;
		this.isActive = isActive;
	}

	public long getCategoryId() {
		return categoryId;
	}

	public void setCategoryId(long categoryId) {
		this.categoryId = categoryId;
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

	public boolean isActive() {
		return isActive;
	}

	public void setIsActive(boolean isActive) {
		this.isActive = isActive;
	}

	@Override
	public String toString() {
		return "MenuCategory [categoryId=" + categoryId + ", restaurantId=" + restaurantId + ", name=" + name
				+ ", isActive=" + isActive + "]";
	}

}
