package com.swadkart.model;

public class CartItem {
	private long cartItemId;
	private long cartId;
	private long menuItemId;
	private int quantity;
	private double price;
	private String itemName;

	public CartItem() {
	}

	public CartItem(long cartItemId, long cartId, long menuItemId, int quantity, double price, String itemName) {
		this.cartItemId = cartItemId;
		this.cartId = cartId;
		this.menuItemId = menuItemId;
		this.quantity = quantity;
		this.price = price;
		this.itemName = itemName;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public long getCartItemId() {
		return cartItemId;
	}

	public void setCartItemId(long cartItemId) {
		this.cartItemId = cartItemId;
	}

	public long getCartId() {
		return cartId;
	}

	public void setCartId(long cartId) {
		this.cartId = cartId;
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

	@Override
	public String toString() {
		return "CartItem [cartItemId=" + cartItemId + ", cartId=" + cartId + ", menuItemId=" + menuItemId
				+ ", quantity=" + quantity + ", price=" + price + "]";
	}

}
