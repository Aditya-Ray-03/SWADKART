<%-- Recompile Cache Buster v2.0.1 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.swadkart.model.Restaurant" %>
<%@ page import="com.swadkart.model.User, com.swadkart.dao.AddressDao, com.swadkart.dao.impl.AddressDaoImpl, com.swadkart.dao.OrderDao, com.swadkart.dao.impl.OrderDaoImpl, com.swadkart.model.Address, com.swadkart.model.Order, java.util.List, com.swadkart.model.CartItem, com.swadkart.dao.CartDao, com.swadkart.dao.impl.CartDaoImpl" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
            justify-content: center;
        }
        .filter-btn {
            padding: 8px 20px;
            border: 2px solid var(--primary-color);
            background: transparent;
            color: var(--primary-color);
            border-radius: 20px;
            cursor: pointer;
            font-weight: 600;
            transition: var(--transition);
        }
        .filter-btn:hover, .filter-btn.active {
            background: var(--primary-color);
            color: white;
        }
    </style>
</head>
<body>

    <!-- SMART STICKY HEADER -->
    <header class="sticky-header" id="mainHeader">
        <a href="index.jsp" class="logo">Swad<span>Kart</span></a>
        
        <form action="searchMenu" method="GET" class="nav-search">
            <input type="text" name="query" placeholder="Search for food..." required>
            <i class="fa-solid fa-magnifying-glass"></i>
        </form>

        <div class="nav-actions">
            <% 
                User user = (User) session.getAttribute("loggedInUser");
                AddressDao addressDao = new AddressDaoImpl();
                OrderDao orderDao = new OrderDaoImpl();
                CartDao cartDao = new CartDaoImpl();
                
                List<Address> addresses = (user != null) ? addressDao.getAddressesByUserId(user.getUserId()) : null;
                List<Order> orders = (user != null) ? orderDao.getOrdersByUserId(user.getUserId()) : null;
                List<CartItem> cartItems = (user != null) ? cartDao.getCartItems(user.getUserId()) : new java.util.ArrayList<>();
                
                double cartTotal = 0;
                for(CartItem ci : cartItems) cartTotal += (ci.getPrice() * ci.getQuantity());

                if (user != null) { 
            %>
                <div style="display: flex; gap: 10px; align-items: center;">
                    <div class="user-pill" id="cartPill" style="padding: 8px 15px; border-radius: 20px; border: 1px solid #ddd; background: white; cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="toggleCart()">
                        <i class="fa-solid fa-cart-shopping" style="color: var(--primary-color);"></i>
                        <span id="navCartCount" style="font-weight: 700; color: var(--text-dark); background: var(--primary-color); color: white; border-radius: 50%; width: 22px; height: 22px; display: flex; align-items: center; justify-content: center; font-size: 11px;"><%= cartItems.size() %></span>
                    </div>
                    <div class="user-pill" onclick="toggleDrawer()" style="cursor: pointer;">
                        <span class="user-name"><i class="fa-regular fa-circle-user"></i> <%= user.getFullName().split(" ")[0] %></span>
                    </div>
                </div>
            <% } else { %>
                <a href="login" class="floating-btn">Sign Up <i class="fa-solid fa-arrow-right"></i></a>
            <% } %>
        </div>
    </header>

    <script>
        // OPTIMIZED HEADER SCROLL LOGIC
        let ticking = false;
        function updateHeader() {
            const header = document.getElementById('mainHeader');
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
            ticking = false;
        }

        window.addEventListener('scroll', () => {
            if (!ticking) {
                window.requestAnimationFrame(updateHeader);
                ticking = true;
            }
        });
        const isLoggedIn = <%= user != null ? "true" : "false" %>;
    </script>

    <div class="container">
        <h2 class="section-title">Discover Premium Restaurants</h2>
        
        <!-- FILTER BAR & SORTING -->
        <div class="filter-bar" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 20px; margin-bottom: 30px; background: white; padding: 20px; border-radius: 15px; box-shadow: var(--shadow-sm);">
            <div style="display: flex; gap: 10px; flex-wrap: wrap; align-items: center;">
                <span style="font-size: 14px; font-weight: 700; color: #888; text-transform: uppercase; margin-right: 10px;">Filter:</span>
                <button class="filter-btn active" onclick="filterRestaurants('ALL', this)">All</button>
                <button class="filter-btn" onclick="filterRestaurants('VEG', this)">Veg Only</button>
                <button class="filter-btn" onclick="filterRestaurants('PURE_VEG', this)">Pure Veg</button>
                <button class="filter-btn" onclick="filterRestaurants('NON_VEG', this)">Non-Veg Allowed</button>
            </div>

            <div style="display: flex; gap: 20px; align-items: center; flex-wrap: wrap;">
                <div style="display: flex; gap: 10px; align-items: center;">
                    <span style="font-size: 14px; font-weight: 700; color: #888; text-transform: uppercase;">Sort:</span>
                    <select onchange="window.location.href='restaurants?sortBy=' + this.value" 
                            style="padding: 10px 15px; border-radius: 10px; border: 1px solid #ddd; outline: none; font-size: 14px; cursor: pointer; background: #f8f9fb; font-weight: 600;">
                        <option value="default" <%= "default".equals(request.getAttribute("currentSort")) ? "selected" : "" %>>Relevance</option>
                        <option value="rating" <%= "rating".equals(request.getAttribute("currentSort")) ? "selected" : "" %>>Top Rated</option>
                        <option value="newest" <%= "newest".equals(request.getAttribute("currentSort")) ? "selected" : "" %>>Newest First</option>
                    </select>
                </div>
                
                <form action="searchMenu" method="GET" style="position: relative; width: 100%; max-width: 250px;">
                    <input type="text" name="query" placeholder="Search for dishes..." required 
                           style="width: 100%; padding: 12px 45px 12px 15px; border-radius: 25px; border: 1px solid #ddd; outline: none; transition: var(--transition); font-size: 14px;">
                    <button type="submit" style="position: absolute; right: 5px; top: 5px; bottom: 5px; width: 35px; background: var(--primary-color); border: none; color: white; border-radius: 50%; cursor: pointer;">
                        <i class="fa-solid fa-magnifying-glass" style="font-size: 14px;"></i>
                    </button>
                </form>
            </div>
        </div>
        
        <div class="grid" id="restaurant-grid">
        <%
            List<Restaurant> list = (List<Restaurant>) request.getAttribute("restaurantList");
            SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");

            if (list != null && !list.isEmpty()) {
                int imgIdx = 1;
                for (Restaurant r : list) {
                    // Start from DB image, fallback to generated local pool
                    String imgUrl = r.getImageUrl();
                    if (imgUrl == null || imgUrl.trim().isEmpty()) {
                        imgUrl = "images/restaurant/img" + imgIdx + ".jpg";
                        imgIdx = (imgIdx % 10) + 1; // Cycle 1 through 10
                    }
                    
                    String statusClass = r.isOpen() ? "open" : "closed";
                    String statusText = r.isOpen() ? "Open Now" : "Closed";
                    
                    String restType = r.getRestaurantType() != null ? r.getRestaurantType() : "ALL";
        %>
            <!-- RESTAURANT CARD -->
            <a href="menu?restaurantId=<%= r.getRestaurantId() %>" class="card-link restaurant-item" data-type="<%= restType.toUpperCase() %>">
                <div class="card">
                    <div class="card-img-wrapper">
                        <img src="<%= imgUrl %>" alt="<%= r.getName() %>" class="card-img">
                        <span class="badge <%= r.isOpen() ? "open" : "closed" %>"><%= r.isOpen() ? "Open" : "Closed" %></span>
                    </div>
                    <div class="card-content">
                        <h3 class="card-title"><%= r.getName() %></h3>
                        <p class="card-subtitle">
                            <i class="fa-solid fa-location-dot"></i> <%= r.getAddress() %>
                        </p>
                        <div class="card-meta">
                            <span class="cuisine"><i class="fa-solid fa-utensils"></i> <%= r.getCuisineType() != null ? r.getCuisineType() : "Multi-Cuisine" %></span>
                            <span class="rating"><i class="fa-solid fa-star"></i> <%= r.getAvgRating() %></span>
                        </div>
                    </div>
                </div>
            </a>
        <%
                }
            } else {
        %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 50px;">
                <i class="fa-solid fa-store-slash" style="font-size: 60px; color: #ccc; margin-bottom: 20px;"></i>
                <h3 style="color: var(--text-muted);">No restaurants available at the moment.</h3>
            </div>
        <%
            }
        %>
        </div>
    </div>

    <!-- FILTER SCRIPT -->
    <script>
        function filterRestaurants(type, btnElement) {
            // Update active button state
            document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
            btnElement.classList.add('active');

            // Filter items
            const items = document.querySelectorAll('.restaurant-item');
            items.forEach(item => {
                const itemType = item.getAttribute('data-type').replace('-', '_');
                const filterType = type.replace('-', '_');

                if (filterType === 'ALL' || itemType === filterType) {
                    item.style.display = 'flex';
                } else {
                    item.style.display = 'none';
                }
            });
        }
    </script>


    <!-- DRAWER OVERLAY -->
    <div class="drawer-overlay" id="drawerOverlay" onclick="toggleDrawer()"></div>

    <!-- PROFILE DRAWER -->
    <div class="profile-drawer" id="profileDrawer">
        <% if (user != null) { %>
        <div class="drawer-header">
            <h2>My Profile</h2>
            <div style="display: flex; gap: 15px; align-items: center;">
                <button class="close-drawer" onclick="openEditModal()" style="background: none; border: none; color: var(--primary-color); cursor: pointer; font-size: 18px;"><i class="fa-solid fa-user-pen"></i></button>
                <button class="close-drawer" onclick="toggleDrawer()"><i class="fa-solid fa-xmark"></i></button>
            </div>
        </div>
        <div class="drawer-content">
            <div class="user-profile-info">
                <div class="user-avatar-large">
                    <i class="fa-solid fa-user"></i>
                </div>
                <span class="user-role-badge"><%= user.getRole() %></span>
                <h3 style="font-size: 22px; margin-bottom: 5px; color: var(--text-dark);"><%= user.getFullName() %></h3>
                <p style="color: #888; font-size: 14px;">Member since <%= user.getCreatedAt().toString().split(" ")[0] %></p>
            </div>

            <span class="drawer-section-title">Personal Details</span>
            <div class="info-list">
                <div class="info-item">
                    <i class="fa-solid fa-envelope"></i>
                    <div>
                        <span class="info-label">Email Address</span>
                        <% if (user.getEmail() == null || user.getEmail().isEmpty()) { %>
                            <button onclick="openEmailModal()" class="drawer-res-link" style="background: none; border: none; padding: 0; font-weight: 600; cursor: pointer;">+ Add Email</button>
                        <% } else { %>
                            <span class="info-value" style="word-break: break-all;"><%= user.getEmail() %></span>
                        <% } %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fa-solid fa-phone"></i>
                    <div>
                        <span class="info-label">Phone Number</span>
                        <span class="info-value"><%= user.getPhone() %></span>
                    </div>
                </div>
                <div class="info-item" style="border-bottom: none;">
                    <i class="fa-solid fa-shield-halved"></i>
                    <div>
                        <span class="info-label">Status</span>
                        <span class="info-value" style="color: #2e7d32;"><i class="fa-solid fa-circle-check"></i> Verified Member</span>
                    </div>
                </div>
            </div>

            <span class="drawer-section-title" style="margin-top: 30px;">Saved Addresses</span>
            <div class="info-list">
                <% if (addresses != null && !addresses.isEmpty()) { 
                    for (Address addr : addresses) { %>
                    <div class="info-item" style="padding: 12px 0;">
                        <i class="fa-solid fa-location-dot"></i>
                        <div>
                            <span class="info-label"><%= addr.getFlatNo() != null ? addr.getFlatNo() + ", " : "" %><%= addr.getStreet() %></span>
                            <span class="info-value" style="font-size: 13px; color: #666;"><%= addr.getCity() %> - <%= addr.getPincode() %></span>
                        </div>
                    </div>
                <% } } else { %>
                    <p style="font-size: 13px; color: #888;">No addresses saved yet.</p>
                <% } %>
                <button onclick="openAddressModal()" class="drawer-res-link" style="background: none; border: none; padding: 0; font-size: 12px; margin-top: 10px; display: inline-block; cursor: pointer;">+ Add New Address</button>
            </div>

            <span class="drawer-section-title" style="margin-top: 30px;">Recent Orders</span>
            <div class="info-list">
                <% if (orders != null && !orders.isEmpty()) { 
                    int count = 0;
                    for (Order ord : orders) { 
                        if (count++ >= 3) break; %>
                    <div class="info-item" style="padding: 12px 0;">
                        <i class="fa-solid fa-bag-shopping"></i>
                        <div>
                            <span class="info-label">Order #<%= ord.getOrderId() %></span>
                            <span class="info-value" style="font-size: 13px; color: var(--primary-color);">&#8377;<%= ord.getTotalAmount() %> • <%= ord.getOrderStatus() %></span>
                            <button onclick="trackOrder('<%= ord.getOrderId() %>', '<%= ord.getOrderStatus() %>')" class="drawer-res-link" style="background: none; border: none; padding: 0; font-size: 11px; margin-top: 5px; cursor: pointer;">Track Progress</button>
                        </div>
                    </div>
                <% } } else { %>
                    <p style="font-size: 13px; color: #888;">No recent orders.</p>
                <% } %>
                <a href="#" class="info-item" style="text-decoration: none; color: inherit; border-bottom: none; margin-top: 10px;">
                    <i class="fa-solid fa-clock-rotate-left"></i>
                    <span class="info-value">View Full History</span>
                </a>
            </div>
        </div>
        <div class="drawer-footer">
            <a href="logout" class="drawer-logout-btn">
                <i class="fa-solid fa-right-from-bracket"></i> Sign Out
            </a>
        </div>
        <% } %>
    </div>

    <script>
        function toggleDrawer() {
            const drawer = document.getElementById('profileDrawer');
            const overlay = document.getElementById('drawerOverlay');
            if (drawer && overlay) {
                drawer.classList.toggle('active');
                overlay.classList.toggle('active');
                
                if (drawer.classList.contains('active')) {
                    document.body.style.overflow = 'hidden';
                } else {
                    document.body.style.overflow = '';
                }
            }
        }

        /* --- EDIT PROFILE LOGIC --- */
        function openEditModal() {
            document.getElementById('editModal').classList.add('active');
        }
        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
        }
        function saveProfile(event) {
            event.preventDefault();
            const formData = new FormData(document.getElementById('editProfileForm'));
            const params = new URLSearchParams(formData);

            fetch('updateProfile', {
                method: 'POST',
                body: params
            }).then(response => {
                if (response.ok) {
                    location.reload();
                } else {
                    alert('Failed to update profile. Please try again.');
                }
            });
        }

        /* --- TRACK ORDER LOGIC --- */
        function trackOrder(id, status) {
            document.getElementById('orderTrackingTitle').innerText = 'Tracking Order #' + id;
            const steps = ['PLACED', 'PREPARING', 'OUT_FOR_DELIVERY', 'DELIVERED'];
            const currentIdx = steps.indexOf(status);

            const stepperHtml = steps.map((s, idx) => {
                let stateClass = '';
                if (idx < currentIdx) stateClass = 'completed';
                else if (idx === currentIdx) stateClass = 'active';
                
                return '<div class="step ' + stateClass + '">' +
                       '<div class="step-circle">' + (idx < currentIdx ? '<i class="fa-solid fa-check"></i>' : (idx + 1)) + '</div>' +
                       '<div class="step-line"></div>' +
                       '<div class="step-label">' + s.replace(/_/g, ' ') + '</div>' +
                       '</div>';
            }).join('');

            document.getElementById('stepperContainer').innerHTML = stepperHtml;
            document.getElementById('trackModal').classList.add('active');
        }

        function closeTrackModal() {
            document.getElementById('trackModal').classList.remove('active');
        }

        /* --- ADDRESS MODAL LOGIC --- */
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
                    alert('Failed to save address. Please try again.');
                }
            });
        }

        /* --- EMAIL OTP LOGIC --- */
        function openEmailModal() {
            document.getElementById('emailStep1').style.display = 'block';
            document.getElementById('emailStep2').style.display = 'none';
            document.getElementById('emailModal').classList.add('active');
        }
        function closeEmailModal() {
            document.getElementById('emailModal').classList.remove('active');
        }
        
        function sendEmailOtp() {
            const email = document.getElementById('newEmailInput').value;
            if (!email) { alert('Please enter an email'); return; }

            fetch('updateProfile', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=sendEmailOtp&email=' + encodeURIComponent(email)
            }).then(response => {
                if (response.ok) {
                    document.getElementById('emailStep1').style.display = 'none';
                    document.getElementById('emailStep2').style.display = 'block';
                }
            });
        }

        function verifyEmailOtp() {
            const otp = Array.from(document.querySelectorAll('.otp-digit-input')).map(i => i.value).join('');
            if (otp.length < 4) { alert('Enter full OTP'); return; }

            fetch('updateProfile', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=verifyEmailOtp&otp=' + otp
            }).then(response => {
                if (response.ok) {
                    document.getElementById('emailSuccess').style.display = 'block';
                    setTimeout(() => location.reload(), 1500);
                } else {
                    alert('Invalid OTP. Please try again.');
                }
            });
        }

        // Auto focus next OTP input
        document.querySelectorAll('.otp-digit-input').forEach((input, idx, inputs) => {
            input.addEventListener('input', () => {
                if (input.value && idx < inputs.length - 1) inputs[idx+1].focus();
            });
        });

        function updateCartQty(itemId, qty, btnElement) {
            const params = new URLSearchParams();
            params.append('action', 'update');
            params.append('menuItemId', itemId);
            params.append('quantity', qty);

            fetch('cart', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: params
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    if (qty <= 0) {
                        location.reload(); 
                    } else {
                        if (document.getElementById('navCartCount')) {
                            document.getElementById('navCartCount').innerText = data.cartCount;
                        }
                        if (document.getElementById('drawerSubtotal')) {
                            document.getElementById('drawerSubtotal').innerHTML = '&#8377;' + data.cartTotal;
                        }
                        const card = btnElement.closest('.cart-item-card');
                        if (card) {
                            const qtySpan = card.querySelector('.item-qty');
                            if (qtySpan) qtySpan.innerText = qty;
                            const unitPrice = parseFloat(card.getAttribute('data-unit-price'));
                            const totalPriceSpan = card.querySelector('.item-total-price');
                            if (totalPriceSpan && !isNaN(unitPrice)) {
                                totalPriceSpan.innerText = (unitPrice * qty).toFixed(1);
                            }
                            const buttons = card.querySelectorAll('.qty-btn');
                            if (buttons.length >= 2) {
                                buttons[0].setAttribute('onclick', "updateCartQty('" + itemId + "', " + (qty - 1) + ", this)");
                                buttons[1].setAttribute('onclick', "updateCartQty('" + itemId + "', " + (qty + 1) + ", this)");
                            }
                        } else {
                            location.reload();
                        }
                    }
                }
            });
        }
    </script>

    <!-- NEW ADDRESS MODAL -->
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
                <button type="submit" class="save-profile-btn" style="margin-top: 25px;">Save Address</button>
            </form>
        </div>
    </div>

    <!-- EMAIL OTP MODAL -->
    <div class="edit-modal-overlay" id="emailModal">
        <div class="edit-modal-content" style="max-width: 450px;">
            <div class="edit-modal-header">
                <h2>Verify Email</h2>
                <button class="close-modal" onclick="closeEmailModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            
            <!-- Step 1: Input Email -->
            <div id="emailStep1">
                <div class="form-group" style="margin-top: 20px;">
                    <label>Enter your email address</label>
                    <input type="email" id="newEmailInput" placeholder="name@example.com" required style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px;">
                </div>
                <button onclick="sendEmailOtp()" class="save-profile-btn" style="margin-top: 20px;">Send OTP</button>
            </div>

            <!-- Step 2: Verification -->
            <div id="emailStep2" style="display: none;">
                <div class="otp-container">
                    <p style="color: #666; font-size: 14px;">We've sent a 4-digit code to your email.</p>
                    <div class="otp-digit-group">
                        <input type="text" class="otp-digit-input" maxlength="1">
                        <input type="text" class="otp-digit-input" maxlength="1">
                        <input type="text" class="otp-digit-input" maxlength="1">
                        <input type="text" class="otp-digit-input" maxlength="1">
                    </div>
                    <p class="resend-otp">Didn't receive it? <a href="#" class="resend-link" onclick="sendEmailOtp()">Resend</a></p>
                    <p id="emailSuccess" class="email-success-p">Security Verified! Updating profile...</p>
                </div>
                <button onclick="verifyEmailOtp()" class="save-profile-btn">Verify & Save</button>
            </div>
        </div>
    </div>

    <!-- EDIT PROFILE MODAL -->
    <div class="edit-modal-overlay" id="editModal">
        <div class="edit-modal-content">
            <div class="edit-modal-header">
                <h2>Edit Profile</h2>
                <button class="close-modal" onclick="closeEditModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <form class="edit-form" id="editProfileForm" onsubmit="saveProfile(event)">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="<%= (user != null) ? user.getFullName() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" value="<%= (user != null) ? user.getEmail() : "" %>" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" value="<%= (user != null) ? user.getPhone() : "" %>" required>
                </div>
                <button type="submit" class="save-profile-btn">Save Changes</button>
            </form>
        </div>
    </div>

    <!-- TRACK ORDER MODAL -->
    <div class="edit-modal-overlay" id="trackModal">
        <div class="edit-modal-content" style="max-width: 550px;">
            <div class="edit-modal-header">
                <h2 id="orderTrackingTitle">Order Tracking</h2>
                <button class="close-modal" onclick="closeTrackModal()"><i class="fa-solid fa-xmark"></i></button>
            </div>
            <div class="tracking-stepper" id="stepperContainer">
                <!-- Dynamically injected -->
            </div>
            <div style="margin-top: 30px; text-align: center; color: #666; font-size: 14px;">
                <p>Status: <strong id="currentStatusText" style="color: var(--primary-color);">Your food is being prepared with love!</strong></p>
            </div>
        </div>
    </div>

    <!-- SIDE CART DRAWER -->
    <div class="edit-modal-overlay" id="cartOverlay" onclick="toggleCart()"></div>
    <div class="cart-drawer" id="cartDrawer">
        <div class="cart-header">
            <h2 style="margin:0; font-size: 20px; font-weight: 800;">My Cart</h2>
            <button class="close-modal" onclick="toggleCart()" style="position:static; background:none; border:none; font-size:24px; cursor:pointer;"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="cart-content" id="cartDrawerContent">
            <% if (cartItems == null || cartItems.isEmpty()) { %>
                <div style="text-align:center; padding:50px 20px; color:#999;">
                    <i class="fa-solid fa-basket-shopping" style="font-size:40px; margin-bottom:15px; opacity:0.3;"></i>
                    <p>Your cart is empty.<br>Add some delicious food!</p>
                </div>
            <% } else { 
                for (CartItem ci : cartItems) { %>
                <div class="cart-item-card" data-unit-price="<%= ci.getPrice() %>">
                    <div class="cart-item-info">
                        <div class="cart-item-name" style="font-size: 14px;"><%= ci.getItemName() %></div>
                        <div class="cart-item-price">&#8377;<span class="item-total-price"><%= ci.getPrice() * ci.getQuantity() %></span></div>
                        <div class="cart-item-controls">
                            <button class="qty-btn" onclick="updateCartQty('<%= ci.getMenuItemId() %>', <%= ci.getQuantity() - 1 %>, this)">-</button>
                            <span class="item-qty" style="font-weight: 700; min-width: 20px; text-align:center;"><%= ci.getQuantity() %></span>
                            <button class="qty-btn" onclick="updateCartQty('<%= ci.getMenuItemId() %>', <%= ci.getQuantity() + 1 %>, this)">+</button>
                        </div>
                    </div>
                    <button onclick="updateCartQty('<%= ci.getMenuItemId() %>', 0, this)" style="background:none; border:none; color:#ff4757; cursor:pointer;"><i class="fa-solid fa-trash-can"></i></button>
                </div>
            <% } } %>
        </div>
        <div class="cart-footer">
            <div class="bill-row"><span>Subtotal</span><span id="drawerSubtotal">&#8377;<%= cartTotal %></span></div>
            <div class="bill-row" style="margin-bottom:20px; font-size: 11px;">Excl. taxes and delivery</div>
            <button onclick="window.location.href='checkout'" class="checkout-btn" <%= (cartItems == null || cartItems.isEmpty()) ? "disabled style='opacity:0.5; cursor:not-allowed;'" : "" %>>
                Checkout <i class="fa-solid fa-arrow-right" style="margin-left:8px;"></i>
            </button>
        </div>
    </div>


    <%@ include file="footer.jsp" %>


</body>
</html>