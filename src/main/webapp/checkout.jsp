<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swadkart.model.User, com.swadkart.model.CartItem, com.swadkart.model.Address, com.swadkart.dao.AddressDao, com.swadkart.dao.impl.AddressDaoImpl, java.util.List, com.swadkart.dao.MenuDao, com.swadkart.dao.impl.MenuDaoImpl, com.swadkart.model.MenuItem" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="checkout-page">
    <%
        User user = (User) session.getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        List<CartItem> cartItems = (List<CartItem>) request.getAttribute("cartItems");
        AddressDao addressDao = new AddressDaoImpl();
        List<Address> userAddresses = addressDao.getAddressesByUserId(user.getUserId());
        
        MenuDao menuDao = new MenuDaoImpl();
        long restaurantId = 0;
        if (cartItems != null && !cartItems.isEmpty()) {
            MenuItem firstItem = menuDao.getMenuItemById(cartItems.get(0).getMenuItemId());
            if (firstItem != null) {
                restaurantId = firstItem.getRestaurantId();
            }
        }
    %>

    <div class="container">
        <header style="margin-bottom: 40px; display: flex; align-items: center; justify-content: space-between;">
            <a href="restaurants" style="text-decoration: none; color: var(--text-dark); font-weight: 700; font-size: 24px;">
                <span style="color: var(--primary-color);">Swad</span>Kart
            </a>
            <div style="font-size: 14px; color: #666;"><i class="fa-solid fa-shield-check"></i> 100% Secure Checkout</div>
        </header>

        <div class="checkout-grid">
            <div class="checkout-main">
                <% if (request.getAttribute("errorMessage") != null) { %>
                    <div style="background: #fff5f5; border-left: 4px solid #ff4757; color: #ff4757; padding: 15px; border-radius: 8px; margin-bottom: 25px; font-size: 14px; display: flex; align-items: center; gap: 10px;">
                        <i class="fa-solid fa-circle-exclamation"></i>
                        <%= request.getAttribute("errorMessage") %>
                    </div>
                <% } %>
                <!-- ADDRESS SECTION -->
                <div class="checkout-section">
                    <h2 class="checkout-title"><i class="fa-solid fa-location-dot" style="color: var(--primary-color);"></i> Delivery Address</h2>
                    
                    <% if (userAddresses != null && !userAddresses.isEmpty()) { %>
                        <div class="address-selection-grid">
                            <% for (Address addr : userAddresses) { %>
                                <div class="address-card" onclick="selectAddress(this, '<%= addr.getAddressId() %>')">
                                    <i class="fa-solid fa-circle-check check-icon"></i>
                                    <div style="font-weight: 700; margin-bottom: 5px;"><%= addr.getFlatNo() %>, <%= addr.getFloorNo() != null ? addr.getFloorNo() : "" %></div>
                                    <div style="font-size: 13px; color: #666; line-height: 1.4;">
                                        <%= addr.getStreet() %><br>
                                        <%= addr.getCity() %> - <%= addr.getPincode() %><br>
                                        <span style="color: var(--primary-color); font-weight: 600; font-size: 11px;">LANDMARK: <%= addr.getLandmark() %></span>
                                    </div>
                                </div>
                            <% } %>
                            <div class="address-card" onclick="openAddressModal()" style="border-style: dashed; display: flex; flex-direction: column; align-items: center; justify-content: center; color: #888;">
                                <i class="fa-solid fa-plus-circle" style="font-size: 24px; margin-bottom: 8px;"></i>
                                <span style="font-size: 13px; font-weight: 600;">Add New Address</span>
                            </div>
                        </div>
                    <% } else { %>
                        <div style="padding: 40px; text-align: center; background: #fafafa; border-radius: 12px; border: 2px dashed #eee;">
                            <i class="fa-solid fa-map-location-dot" style="font-size: 40px; color: #ddd; margin-bottom: 15px;"></i>
                            <p style="color: #888; margin-bottom: 20px;">You haven't saved any addresses yet.</p>
                            <button onclick="openAddressModal()" class="btn-primary" style="padding: 10px 25px; border-radius: 8px;">+ Add Delivery Address</button>
                        </div>
                    <% } %>
                </div>

                <!-- PAYMENT SECTION -->
                <div class="checkout-section">
                    <h2 class="checkout-title"><i class="fa-solid fa-credit-card" style="color: var(--primary-color);"></i> Payment Method</h2>
                    <div class="address-selection-grid">
                        <div class="address-card selected" onclick="selectPayment(this, 'COD')">
                            <i class="fa-solid fa-circle-check check-icon"></i>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i class="fa-solid fa-hand-holding-dollar" style="font-size: 20px; color: #2ecc71;"></i>
                                <div>
                                    <div style="font-weight: 700;">Cash on Delivery</div>
                                    <div style="font-size: 11px; color: #888;">Pay when you receive</div>
                                </div>
                            </div>
                        </div>
                        <div class="address-card" onclick="selectPayment(this, 'ONLINE')">
                            <i class="fa-solid fa-circle-check check-icon"></i>
                            <div style="display: flex; align-items: center; gap: 12px;">
                                <i class="fa-solid fa-building-columns" style="font-size: 20px; color: #3498db;"></i>
                                <div>
                                    <div style="font-weight: 700;">Online Payment</div>
                                    <div style="font-size: 11px; color: #27ae60;">Secure SwadPay</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="checkout-sidebar">
                <div class="checkout-section" style="position: sticky; top: 30px;">
                    <h2 class="checkout-title" style="font-size: 18px; border-bottom: 1.5px solid var(--primary-color); padding-bottom: 15px; opacity: 0.8;">Order Summary</h2>
                    
                    <div class="cart-items-list" style="margin-bottom: 25px;">
                        <% 
                           double subtotal = 0;
                           if (cartItems != null) {
                               for (CartItem item : cartItems) {
                                   subtotal += (item.getPrice() * item.getQuantity());
                        %>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 12px; font-size: 14px;">
                                <span style="color: #555;"><span style="font-weight: 700; color: var(--text-dark);"><%= item.getQuantity() %>x</span> Item #<%= item.getMenuItemId() %></span>
                                <span style="font-weight: 600;">&#8377;<%= item.getPrice() * item.getQuantity() %></span>
                            </div>
                        <% } } %>
                    </div>

                    <div style="border-top: 1.5px solid var(--primary-color); padding-top: 25px; opacity: 0.8;">
                        <div class="bill-row"><span>Item Total</span><span>&#8377;<%= subtotal %></span></div>
                        <div class="bill-row"><span>Delivery Fee</span><span>&#8377;40</span></div>
                        <div class="bill-row"><span>Taxes & Charges</span><span>&#8377;<%= Math.round(subtotal * 0.05) %></span></div>
                        <div class="bill-row bill-total"><span>Total Pay</span><span>&#8377;<%= subtotal + 40 + Math.round(subtotal * 0.05) %></span></div>
                    </div>

                    <form action="checkout" method="POST" id="finalOrderForm">
                        <input type="hidden" name="addressId" id="selectedAddressId">
                        <input type="hidden" name="paymentMethod" id="selectedPaymentMethod" value="COD">
                        <input type="hidden" name="totalAmount" value="<%= subtotal + 40 + Math.round(subtotal * 0.05) %>">
                        <input type="hidden" name="restaurantId" value="<%= restaurantId %>">
                        
                        <button type="submit" class="checkout-btn" style="width: 100%; margin-top: 30px;" onclick="validateAndSubmit(event)">
                            Place Order <i class="fa-solid fa-arrow-right" style="margin-left: 8px;"></i>
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- REUSE ADDRESS MODAL FROM PREVIOUS WORK -->
    <!-- SWADPAY PREMIUM MODAL -->
    <div class="edit-modal-overlay" id="swadPayModal">
        <div class="edit-modal-content" style="max-width: 450px; text-align: center; border-bottom: 5px solid var(--primary-color);">
            <div style="margin-bottom: 25px;">
                <span style="font-size: 28px; font-weight: 800;"><span style="color: var(--primary-color);">Swad</span>Pay</span>
                <div style="font-size: 12px; color: #888; margin-top: 5px;">Secure Payment Gateway</div>
            </div>
            
            <div id="paymentInitial" style="display: block;">
                <div style="background: #f8f9fa; padding: 20px; border-radius: 12px; margin-bottom: 25px;">
                    <div style="font-size: 14px; color: #666; margin-bottom: 8px;">Order Amount</div>
                    <div style="font-size: 32px; font-weight: 800; color: var(--text-dark);">&#8377;<span id="modalPayAmount">0</span></div>
                </div>
                
                <div style="display: grid; gap: 15px; margin-bottom: 30px;">
                    <button class="payment-option-btn active" onclick="setSubPayment(this, 'CARD')">
                        <i class="fa-solid fa-credit-card"></i> Credit / Debit Card
                    </button>
                    <button class="payment-option-btn" onclick="setSubPayment(this, 'UPI')">
                        <i class="fa-solid fa-mobile-screen-button"></i> Google Pay / PhonePe / UPI
                    </button>
                    <button class="payment-option-btn" onclick="setSubPayment(this, 'NB')">
                        <i class="fa-solid fa-building-columns"></i> Net Banking
                    </button>
                </div>
                
                <button onclick="processSwadPay()" class="checkout-btn" style="width: 100%;">
                    Pay Securely Now <i class="fa-solid fa-shield-halved" style="margin-left: 8px;"></i>
                </button>
            </div>
            
            <div id="paymentProcessing" style="display: none; padding: 40px 0;">
                <div class="payment-loader"></div>
                <h3 style="margin-top: 30px; font-size: 18px; font-weight: 700;">Verifying Your Payment...</h3>
                <p style="color: #888; font-size: 14px; margin-top: 10px;">Please do not refresh or close this window.</p>
                <div class="progress-bar-container" style="margin-top: 25px;">
                    <div class="progress-bar-fill" id="paymentProgress"></div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .payment-option-btn {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background: white;
            cursor: pointer;
            font-weight: 600;
            color: #555;
            transition: all 0.3s ease;
            text-align: left;
        }
        .payment-option-btn i { font-size: 18px; color: var(--primary-color); opacity: 0.7; }
        .payment-option-btn.active {
            border-color: var(--primary-color);
            background: #fff9f0;
            color: var(--primary-color);
        }
        .payment-loader {
            width: 60px;
            height: 60px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid var(--primary-color);
            border-radius: 50%;
            margin: 0 auto;
            animation: spin 1s linear infinite;
        }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .progress-bar-container {
            width: 100%;
            height: 6px;
            background: #eee;
            border-radius: 3px;
            overflow: hidden;
        }
        .progress-bar-fill {
            width: 0%;
            height: 100%;
            background: var(--primary-color);
            transition: width 0.3s ease;
        }
    </style>
    <!-- MODAL FOR ADDRESS -->
    <div class="edit-modal-overlay" id="addressModal">
        <div class="edit-modal-content address-modal-content">
            <div class="edit-modal-header">
                <h2>Add New Address</h2>
                <button class="close-modal" onclick="closeAddressModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form class="edit-form" id="addAddressForm" onsubmit="saveAddress(event)">
                <div class="address-form-grid">
                    <div class="form-group">
                        <label>Flat / House No.</label>
                        <input type="text" name="flatNo" required placeholder="e.g. 101">
                    </div>
                    <div class="form-group">
                        <label>Floor No.</label>
                        <input type="text" name="floorNo" placeholder="e.g. 1st Floor">
                    </div>
                    <div class="form-group full-width">
                        <label>Street / Area</label>
                        <input type="text" name="street" required placeholder="e.g. MG Road, Near Central Mall">
                    </div>
                    <div class="form-group full-width">
                        <label>Landmark</label>
                        <input type="text" name="landmark" placeholder="e.g. Opposite Park">
                    </div>
                    <div class="form-group">
                        <label>City</label>
                        <input type="text" name="city" required placeholder="e.g. Mumbai">
                    </div>
                    <div class="form-group">
                        <label>Pincode</label>
                        <input type="text" name="pincode" required placeholder="400001">
                    </div>
                </div>
                <button type="submit" class="save-profile-btn" style="margin-top: 25px;">Save & Use Address</button>
            </form>
        </div>
    </div>

    <script>
        function selectAddress(element, id) {
            // Only affect address cards within the address section
            element.closest('.address-selection-grid').querySelectorAll('.address-card').forEach(card => card.classList.remove('selected'));
            element.classList.add('selected');
            document.getElementById('selectedAddressId').value = id;
        }

        function selectPayment(element, method) {
            // Only affect payment cards within the payment section
            element.closest('.address-selection-grid').querySelectorAll('.address-card').forEach(card => card.classList.remove('selected'));
            element.classList.add('selected');
            document.getElementById('selectedPaymentMethod').value = method;
        }

        function setSubPayment(btn, type) {
            document.querySelectorAll('.payment-option-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        }

        function validateAndSubmit(event) {
            event.preventDefault();
            const addrId = document.getElementById('selectedAddressId').value;
            if (!addrId) {
                alert('Please select a delivery address first!');
                return;
            }

            const paymentMethod = document.getElementById('selectedPaymentMethod').value;
            if (paymentMethod === 'ONLINE') {
                const total = document.querySelector('input[name="totalAmount"]').value;
                document.getElementById('modalPayAmount').innerText = total;
                document.getElementById('swadPayModal').classList.add('active');
                document.getElementById('paymentInitial').style.display = 'block';
                document.getElementById('paymentProcessing').style.display = 'none';
            } else {
                document.getElementById('finalOrderForm').submit();
            }
        }

        function processSwadPay() {
            document.getElementById('paymentInitial').style.display = 'none';
            document.getElementById('paymentProcessing').style.display = 'block';
            
            let progress = 0;
            const interval = setInterval(() => {
                progress += Math.random() * 20;
                if (progress > 100) progress = 100;
                document.getElementById('paymentProgress').style.width = progress + '%';
                
                if (progress === 100) {
                    clearInterval(interval);
                    setTimeout(() => {
                        document.getElementById('finalOrderForm').submit();
                    }, 500);
                }
            }, 500);
        }

        function validateAndSubmit(event) {
            const addrId = document.getElementById('selectedAddressId').value;
            if (!addrId) {
                event.preventDefault();
                alert('Please select a delivery address first!');
            }
        }

        function openAddressModal() {
            document.getElementById('addressModal').classList.add('active');
        }
        function closeAddressModal() {
            document.getElementById('addressModal').classList.remove('active');
        }
        function saveAddress(event) {
            event.preventDefault();
            const formData = new FormData(document.getElementById('addAddressForm'));
            const params = new URLSearchParams(formData);

            fetch('addAddress', {
                method: 'POST',
                body: params
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Failed to save address.');
                }
            });
        }
    </script>
    <%@ include file="footer.jsp" %>
</body>
</html>
