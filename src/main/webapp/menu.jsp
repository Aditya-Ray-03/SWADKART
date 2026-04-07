<%-- Recompile Cache Buster v2.0.1 --%>
<%@ page import="java.util.List, com.swadkart.model.MenuItem, com.swadkart.model.Restaurant, com.swadkart.model.User, com.swadkart.dao.AddressDao, com.swadkart.dao.impl.AddressDaoImpl, com.swadkart.dao.OrderDao, com.swadkart.dao.impl.OrderDaoImpl, com.swadkart.model.Address, com.swadkart.model.Order, com.swadkart.model.CartItem, com.swadkart.dao.CartDao, com.swadkart.dao.impl.CartDaoImpl" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .filter-bar {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
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
    <% 
        User user = (User) session.getAttribute("loggedInUser");
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        
        // Safe DAO inits
        AddressDao addressDao = new AddressDaoImpl();
        OrderDao orderDao = new OrderDaoImpl();
        CartDao cartDao = new com.swadkart.dao.impl.CartDaoImpl();
        
        List<Address> addresses = (user != null) ? addressDao.getAddressesByUserId(user.getUserId()) : null;
        List<Order> orders = (user != null) ? orderDao.getOrdersByUserId(user.getUserId()) : null;
        List<CartItem> cartItems = (user != null) ? cartDao.getCartItems(user.getUserId()) : new java.util.ArrayList<>();
        
        double cartTotal = 0;
        if (cartItems != null) {
            for(CartItem ci : cartItems) cartTotal += (ci.getPrice() * ci.getQuantity());
        }
    %>

    <!-- SMART STICKY HEADER -->
    <header class="sticky-header" id="mainHeader">
        <a href="index.jsp" class="logo">Swad<span>Kart</span></a>
        
        <form action="menu" method="GET" class="nav-search">
            <input type="hidden" name="restaurantId" value="<%= restaurant != null ? restaurant.getRestaurantId() : "" %>">
            <input type="text" name="query" placeholder="Search in this menu..." value="<%= request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : "" %>" required>
            <i class="fa-solid fa-magnifying-glass"></i>
        </form>

        <div class="nav-actions">
            <% if (user != null) { %>
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

        // Global Auth State
        const isLoggedIn = <%= user != null ? "true" : "false" %>;
    </script>

    <%
        if (restaurant != null) {
            String coverImg = restaurant.getImageUrl();
            if (coverImg == null || coverImg.trim().isEmpty()) {
                coverImg = "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=1920&q=80";
            }
    %>
    <!-- PREMIUM RESTAURANT HERO -->
    <div class="restaurant-hero">
        <img src="<%=coverImg%>" alt="<%=restaurant.getName()%>" class="restaurant-hero-img">
        <div class="restaurant-hero-overlay"></div>
        <div class="restaurant-hero-content">
            <div class="glass-badge">
                <i class="fa-solid fa-medal"></i> Top Rated Partner
            </div>
            <h1 class="restaurant-hero-title"><%=restaurant.getName()%></h1>
            
            <div class="restaurant-details-grid">
                <div class="detail-item">
                    <i class="fa-solid fa-location-dot"></i>
                    <span><%=restaurant.getAddress()%></span>
                </div>
                <div class="detail-item">
                    <i class="fa-solid fa-star"></i>
                    <span style="font-weight: 700;"><%=restaurant.getAvgRating()%></span>
                    <span style="font-size: 13px; opacity: 0.8;">(500+ Ratings)</span>
                </div>
                <div class="detail-item">
                    <i class="fa-solid fa-clock"></i>
                    <span>30-40 mins</span>
                </div>
                <div class="detail-item">
                    <i class="fa-solid fa-utensils"></i>
                    <span><%=restaurant.getCuisineType()%></span>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container" style="max-width: 900px;">
        <% String activeQuery = (String) request.getAttribute("searchQuery"); %>
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h2 class="section-title" style="text-align: left; margin: 0;">
                <%= activeQuery != null ? "Search Results" : "Menu Top Picks" %>
            </h2>
            <% if (activeQuery != null) { %>
                <a href="menu?restaurantId=<%= restaurant.getRestaurantId() %>" style="color: var(--primary-color); text-decoration: none; font-size: 14px; font-weight: 700;">
                    <i class="fa-solid fa-xmark"></i> Clear Search
                </a>
            <% } %>
        </div>
        
        <% if (activeQuery != null) { %>
            <p style="margin-top: -15px; margin-bottom: 20px; color: #666;">Showing results for "<span style="color: var(--primary-color); font-weight: 700;"><%= activeQuery %></span>"</p>
        <% } %>
        
        <!-- MENU FILTER BAR -->
        <div class="filter-bar">
            <button class="filter-btn active" onclick="filterMenu('ALL', this)">All Items</button>
            <button class="filter-btn" onclick="filterMenu('VEG', this)">Veg Only</button>
            <button class="filter-btn" onclick="filterMenu('NON_VEG', this)">Non-Veg Only</button>
        </div>
        
        <div style="display: grid; gap: 20px;" id="menu-grid">
        <%
        List<MenuItem> list = (List<MenuItem>) request.getAttribute("menuList");

        if (list != null && !list.isEmpty()) {
            int imgIdx = 1;
            for (MenuItem item : list) {
                String foodType = item.getFoodType() != null ? item.getFoodType() : "VEG";
                String itemName = item.getName() != null ? item.getName().toUpperCase() : "";
                
                // Fail-Safe Name-Aware logic: also check name for "VEG", "SALAD", "PANEER"
                boolean isVeg = (item.getFoodType() == null || item.getFoodType().trim().isEmpty() || 
                                 item.getFoodType().toUpperCase().contains("VEG") ||
                                 itemName.contains("VEG") || itemName.contains("SALAD") || itemName.contains("PANEER"));
                
                String typeClass = isVeg ? "veg" : "non-veg";
                // For filtering, if name-aware says it's veg, force "VEG" type
                String filterType = isVeg ? "VEG" : foodType.toUpperCase();
                
                String itemImg = item.getImageUrl();
                if (itemImg == null || itemImg.trim().isEmpty()) {
                    itemImg = "images/menuItem/menu_img" + imgIdx + ".jpg";
                    imgIdx = (imgIdx % 10) + 1; // Cycle 1 through 10
                }
        %>
            <!-- MENU CARD -->
            <div class="menu-card menu-item" data-type="<%= filterType %>">
                <img src="<%=itemImg%>" alt="<%=item.getName()%>" class="menu-img">
                <div class="menu-content">
                    <div class="menu-header">
                        <h3 class="menu-title">
                            <span class="food-icon <%=typeClass%>"></span>
                            <%=item.getName()%>
                        </h3>
                        <% if (!item.isAvailable()) { %>
                            <span class="badge closed" style="position: static; font-size: 10px;">Sold Out</span>
                        <% } %>
                    </div>
                    
                    <p class="menu-desc"><%=item.getDescription() != null ? item.getDescription() : "Delicious and freshly prepared."%></p>
                    
                    <div class="menu-footer">
                        <div class="menu-price">&#8377;<%=item.getPrice()%></div>
                        
                        <button type="button" class="btn-add" 
                                onclick="addToCartAjax('<%=item.getItemId()%>', '<%=item.getPrice()%>', '<%=item.getRestaurantId()%>')"
                                <%= !item.isAvailable() ? "disabled" : "" %>>
                            <%= item.isAvailable() ? "Add +" : "Unavailable" %>
                        </button>
                    </div>
                </div>
            </div>
        <%
            }
        } else {
        %>
            <div style="text-align: center; padding: 40px; background: white; border-radius: 12px;">
                <i class="fa-solid fa-cookie-bite" style="font-size: 50px; color: #ddd; margin-bottom: 20px;"></i>
                <h3 style="color: var(--text-muted);">No items available on this menu yet.</h3>
            </div>
        <%
        }
        %>
        </div>
    </div>

    <!-- SCRIPT TO FILTER -->
    <script>
        function filterMenu(type, btnElement) {
            // Update active button state
            document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
            btnElement.classList.add('active');

            // Filter items
            const items = document.querySelectorAll('.menu-item');
            items.forEach(item => {
                const itemType = item.getAttribute('data-type').replace('-', '_'); // Normalize hyphen to underscore
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
    <script>
        // Use global isLoggedIn from above
        function addToCartAjax(itemId, price, restId) {
            if (!isLoggedIn) {
                alert("Please Sign in to add items to your cart!");
                window.location.href = 'login';
                return;
            }
            const params = new URLSearchParams();
            params.append('action', 'add');
            params.append('menuItemId', itemId);
            params.append('price', price);
            params.append('restaurantId', restId);

            fetch('cart', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: params
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    const cartCount = document.getElementById('navCartCount');
                    const cartPill = document.getElementById('cartPill');
                    
                    if (cartCount) cartCount.innerText = data.cartCount;
                    
                    // Trigger Pulse Animation
                    if (cartPill) {
                        cartPill.classList.remove('cart-pulse');
                        void cartPill.offsetWidth; // Trigger reflow
                        cartPill.classList.add('cart-pulse');
                    }

                    // Optional: show a mini toast instead of reload if possible, 
                    // but for now keeping it simple as requested.
                    // location.reload(); 
                }
            });
        }

        function updateCartQty(itemId, qty, btnElement) {
            console.log("Updating Cart: Item=" + itemId + ", Qty=" + qty);
            const params = new URLSearchParams();
            params.append('action', 'update');
            params.append('menuItemId', itemId);
            params.append('quantity', qty);

            fetch('cart', {
                method: 'POST',
                headers: { 'X-Requested-With': 'XMLHttpRequest' },
                body: params
            })
            .then(res => {
                if (!res.ok) throw new Error("HTTP error " + res.status);
                return res.json();
            })
            .then(data => {
                console.log("Cart Response:", data);
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
                } else {
                    if (data.error === "Session expired") location.reload();
                }
            })
            .catch(err => {
                console.error("AJAX Error:", err);
            });
        }

        function toggleDrawer() {
            const drawer = document.getElementById('profileDrawer');
            const overlay = document.getElementById('drawerOverlay');
            if (drawer && overlay) {
                drawer.classList.toggle('active');
                overlay.classList.toggle('active');
                if (drawer.classList.contains('active')) {
                    document.body.style.overflow = 'hidden';
                    document.getElementById('cartDrawer').classList.remove('active');
                    document.getElementById('cartOverlay').classList.remove('active');
                } else {
                    document.body.style.overflow = '';
                }
            }
        }

        function toggleCart() {
            const cart = document.getElementById('cartDrawer');
            const overlay = document.getElementById('cartOverlay');
            if (cart && overlay) {
                cart.classList.toggle('active');
                overlay.classList.toggle('active');
                if (cart.classList.contains('active')) {
                    document.body.style.overflow = 'hidden';
                    document.getElementById('profileDrawer').classList.remove('active');
                    document.getElementById('drawerOverlay').classList.remove('active');
                } else {
                    document.body.style.overflow = '';
                }
            }
        }
    </script>

    <% } else { %>
        <div class="container" style="text-align: center; padding: 100px 20px;">
            <i class="fa-solid fa-store-slash" style="font-size: 60px; color: #ccc; margin-bottom: 20px;"></i>
            <h2 style="color: var(--text-dark);">Restaurant Not Found</h2>
            <p style="color: #666; margin-top: 10px;">The restaurant you're looking for doesn't exist or is offline.</p>
            <a href="restaurants" class="btn-primary" style="margin-top: 30px; display: inline-flex;">Explore Other Restaurants</a>
        </div>
    <% } %>


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


    <%@ include file="footer.jsp" %>
</body>
</html>