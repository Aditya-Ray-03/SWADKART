<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.swadkart.model.MenuItem, com.swadkart.model.User, com.swadkart.dao.AddressDao, com.swadkart.dao.impl.AddressDaoImpl, com.swadkart.dao.OrderDao, com.swadkart.dao.impl.OrderDaoImpl, com.swadkart.model.Address, com.swadkart.model.Order, com.swadkart.model.CartItem, com.swadkart.dao.CartDao, com.swadkart.dao.impl.CartDaoImpl" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-hero {
            position: relative;
            height: 300px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            background: #1a1a1a;
            margin-bottom: 40px;
        }
        .search-hero-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.4;
            filter: blur(4px);
            transform: scale(1.1);
        }
        .search-hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            padding: 0 20px;
        }
        .search-hero-title {
            color: white;
            font-size: 40px;
            font-weight: 800;
            margin-bottom: 10px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.5);
        }
        .search-hero-subtitle {
            display: inline-block;
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            padding: 10px 25px;
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 600;
            font-size: 16px;
        }
        .search-highlight {
            color: var(--primary-color);
            font-weight: 800;
        }
        
        /* Unified Search Results Grid */
        .search-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 60px;
        }

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

    <!-- SEARCH HERO SECTION -->
    <div class="search-hero">
        <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1920&q=80" alt="Search" class="search-hero-img">
        <div class="search-hero-content">
            <h1 class="search-hero-title">Search Results</h1>
            <div class="search-hero-subtitle">
                Showing results for "<span class="search-highlight"><%= request.getAttribute("searchQuery") %></span>"
            </div>
        </div>
    </div>

    <div class="container">
        <%
            List<MenuItem> list = (List<MenuItem>) request.getAttribute("searchResults");

            if (list != null && !list.isEmpty()) {
        %>
            <!-- SEARCH RESULTS FILTER BAR -->
            <div class="filter-bar" id="searchFilterBar" style="justify-content: center; margin: 30px 0;">
                <button class="filter-btn active" onclick="filterMenu('ALL', this)">All Items</button>
                <button class="filter-btn" onclick="filterMenu('VEG', this)">Veg Only</button>
                <button class="filter-btn" onclick="filterMenu('NON_VEG', this)">Non-Veg Only</button>
            </div>

            <div class="search-grid">

            <%
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
                        imgIdx = (imgIdx % 10) + 1;
                    }
            %>
                <!-- PREMIUM MENU ITEM CARD -->
                <div class="menu-card menu-item" data-type="<%= filterType %>" style="display: flex; flex-direction: column;">
                    <div class="menu-img-wrapper" style="position: relative; height: 180px; overflow: hidden; border-radius: 15px;">
                        <img src="<%=itemImg%>" alt="<%=item.getName()%>" class="menu-img" style="width:100%; height:100%; object-fit:cover; transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);">
                        <div style="position: absolute; top: 10px; right: 10px;">
                            <% if (!item.isAvailable()) { %>
                                <span class="badge closed" style="font-size: 10px;">Sold Out</span>
                            <% } %>
                        </div>
                    </div>
                    <div class="menu-content" style="padding: 18px; flex-grow: 1; display:flex; flex-direction: column;">
                        <div class="menu-header">
                            <h3 class="menu-title" style="font-size: 18px;">
                                <span class="food-icon <%=typeClass%>"></span>
                                <%=item.getName()%>
                            </h3>
                        </div>
                        <p class="menu-desc" style="font-size: 13px; color: #777; margin: 10px 0; height: 3.2em; overflow: hidden;"><%=item.getDescription() != null ? item.getDescription() : "Delicious and freshly prepared."%></p>
                        
                        <div class="menu-footer" style="margin-top: auto; display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #f0f0f0; padding-top: 15px;">
                            <div class="menu-price" style="font-weight: 800; color: var(--text-dark); font-size: 18px;">&#8377;<%=item.getPrice()%></div>
                            <div style="display: flex; gap: 10px; align-items: center;">
                                <a href="menu?restaurantId=<%=item.getRestaurantId()%>" title="View Restaurant" style="color: var(--primary-color); font-size: 18px;"><i class="fa-solid fa-store"></i></a>
                                <button type="button" class="btn-add" 
                                        onclick="addToCartAjax('<%=item.getItemId()%>', '<%=item.getPrice()%>', '<%=item.getRestaurantId()%>')"
                                        <%= !item.isAvailable() ? "disabled" : "" %>
                                        style="padding: 8px 18px; font-size: 13px;">
                                    <%= item.isAvailable() ? "Add +" : "Off" %>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
            </div>
        <% } else { %>
            <div class="no-results" style="text-align: center; padding: 80px 20px;">
                <i class="fa-solid fa-magnifying-glass-location" style="font-size: 70px; color: #ddd; margin-bottom: 25px;"></i>
                <h2 style="font-size: 28px; color: var(--text-dark); font-weight: 800;">No items found</h2>
                <p style="color: #888; font-size: 16px; margin-top: 10px;">We couldn't find any dish matching "<span style="color: var(--primary-color); font-weight:700;"><%= request.getAttribute("searchQuery") %></span>".</p>
                <div style="margin-top: 35px; display: flex; gap: 15px; justify-content: center;">
                    <a href="restaurants" class="btn-primary" style="display: inline-flex; padding: 12px 25px;">Explore All Restaurants</a>
                    <a href="index.jsp" class="btn-secondary" style="display: inline-flex; padding: 12px 25px; background: #eee; color: #333; text-decoration: none; border-radius: 12px; font-weight: 700;">Back to Home</a>
                </div>
        <% } %>
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
    <%@ include file="footer.jsp" %>
    
    <script>
        function addToCartAjax(itemId, price, restaurantId) {
            if (!isLoggedIn) {
                alert("Please login first to add items to cart.");
                window.location.href = "login";
                return;
            }
            fetch('cart', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded', 'X-Requested-With': 'XMLHttpRequest' },
                body: 'action=add&menuItemId=' + itemId + '&price=' + price + '&restaurantId=' + restaurantId
            })
            .then(r => r.json())
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
                }
            });
        }
    </script>
</body>
</html>
