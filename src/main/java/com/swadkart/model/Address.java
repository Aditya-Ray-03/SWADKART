package com.swadkart.model;

public class Address {
	private long addressId;
	private long userId;
	private String flatNo;
	private String floorNo;
	private String street;
	private String landmark;
	private String city;
	private String pincode;
	private double latitude;
	private double longitude;
	private String googleMapLink;
	private boolean isDefault;

	public Address() {
	}

	public Address(long addressId, long userId, String flatNo, String floorNo, String street, String landmark,
			String city, String pincode, double latitude, double longitude, String googleMapLink, boolean isDefault) {
		this.addressId = addressId;
		this.userId = userId;
		this.flatNo = flatNo;
		this.floorNo = floorNo;
		this.street = street;
		this.landmark = landmark;
		this.city = city;
		this.pincode = pincode;
		this.latitude = latitude;
		this.longitude = longitude;
		this.googleMapLink = googleMapLink;
		this.isDefault = isDefault;
	}

	public long getAddressId() {
		return addressId;
	}

	public void setAddressId(long addressId) {
		this.addressId = addressId;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public String getFlatNo() {
		return flatNo;
	}

	public void setFlatNo(String flatNo) {
		this.flatNo = flatNo;
	}

	public String getFloorNo() {
		return floorNo;
	}

	public void setFloorNo(String floorNo) {
		this.floorNo = floorNo;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getLandmark() {
		return landmark;
	}

	public void setLandmark(String landmark) {
		this.landmark = landmark;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getPincode() {
		return pincode;
	}

	public void setPincode(String pincode) {
		this.pincode = pincode;
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

	public String getGoogleMapLink() {
		return googleMapLink;
	}

	public void setGoogleMapLink(String googleMapLink) {
		this.googleMapLink = googleMapLink;
	}

	public boolean isDefault() {
		return isDefault;
	}

	public void setIsDefault(boolean isDefault) {
		this.isDefault = isDefault;
	}

	@Override
	public String toString() {
		return "Address [addressId=" + addressId + ", userId=" + userId + ", flatNo=" + flatNo + ", floorNo=" + floorNo
				+ ", street=" + street + ", landmark=" + landmark + ", city=" + city + ", pincode=" + pincode
				+ ", latitude=" + latitude + ", longitude=" + longitude + ", google_map_link=" + googleMapLink
				+ ", isDefault=" + isDefault + "]";
	}

}
