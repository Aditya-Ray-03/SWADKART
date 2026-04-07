package com.swadkart.dao;

import java.util.List;
import com.swadkart.model.Address;

public interface AddressDao {
    List<Address> getAddressesByUserId(long userId);
    Address getDefaultAddress(long userId);
    boolean addAddress(Address addr);
}
