package com.swadkart.model;

import java.sql.Timestamp;

public class User {

	private long userId;
	private String fullName;
	private String email;
	private String phone;
	private String role; // USER,ADMIN,Delivery
	private boolean isVerified;
	private Timestamp createdAt;
	private Timestamp lastLogin;

	public User() {
	}

	public User(long userId, String fullName, String email, String phone, String role, boolean isVerified,
			Timestamp createdAt, Timestamp lastLogin) {
		this.userId = userId;
		this.fullName = fullName;
		this.email = email;
		this.phone = phone;
		this.role = role;
		this.isVerified = isVerified;
		this.createdAt = createdAt;
		this.lastLogin = lastLogin;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
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

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public boolean isVerified() {
		return isVerified;
	}

	public void setIsVerified(boolean isVerified) {
		this.isVerified = isVerified;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Timestamp lastLogin) {
		this.lastLogin = lastLogin;
	}

	@Override
	public String toString() {
		return "Users [userId=" + userId + ", fullName=" + fullName + ", email=" + email + ", phone=" + phone
				+ ", role=" + role + ", isVerified=" + isVerified + ", createdAt=" + createdAt + ", lastLogin="
				+ lastLogin + "]";
	}

}
