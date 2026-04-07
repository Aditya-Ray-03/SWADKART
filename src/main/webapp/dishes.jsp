<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.swadkart.model.User, com.swadkart.dao.AddressDao, com.swadkart.dao.impl.AddressDaoImpl, com.swadkart.dao.OrderDao, com.swadkart.dao.impl.OrderDaoImpl, com.swadkart.model.Address, com.swadkart.model.Order, com.swadkart.model.CartItem, com.swadkart.dao.CartDao, com.swadkart.dao.impl.CartDaoImpl, java.util.List, java.util.Arrays" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Cravings - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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

        /* Large Grid specifically for categories */
        .all-cravings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
            gap: 30px 20px;
            margin-bottom: 60px;
            justify-items: center;
        }
        
        .category-item {
            text-decoration: none;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: transform 0.3s;
        }
        .category-item:hover {
            transform: translateY(-5px);
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
                
                List<CartItem> cartItems = (user != null) ? cartDao.getCartItems(user.getUserId()) : new java.util.ArrayList<>();

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
                <a href="login.jsp" class="floating-btn">Sign Up <i class="fa-solid fa-arrow-right"></i></a>
            <% } %>
        </div>
    </header>

    <script>
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
    </script>

    <!-- DISHES HERO SECTION -->
    <div class="search-hero">
        <img src="https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1920&q=80" alt="Dishes" class="search-hero-img">
        <div class="search-hero-content">
            <h1 class="search-hero-title">What are you craving?</h1>
            <div class="search-hero-subtitle">
                Explore over 50 variations of delicious food!
            </div>
        </div>
    </div>

    <div class="container">
        <div class="all-cravings-grid">
            <%
                List<String> categories = Arrays.asList(
                    "Biryani", "Pizza", "Burger", "Indian", "Sushi", "Desserts", "Pasta", "Chicken", 
                    "Salad", "Sandwich", "Thali", "Noodles", "Kebab", "Milkshake", "Dosa", "Wrap", 
                    "Paneer", "Roll", "Momos", "Samosa", "Chaat", "Idli", "Vada", "Paratha", "Kulcha", 
                    "Naan", "Rice", "Roti", "Dal", "Curry", "Soup", "Starters", "Breads", "Ice Cream", 
                    "Cake", "Pastry", "Waffle", "Pancake", "Coffee", "Tea", "Juice", "Mocktail", 
                    "Smoothie", "Fries", "Nachos", "Tacos", "Burrito", "Quesadilla", "Steak", 
                    "Seafood", "Sizzler", "Dimsum", "Spring Roll", "Manchurian"
                );
                
                int imgIdx = 1;
                for (String category : categories) {
                    String itemImg = "images/menuItem/menu_img" + imgIdx + ".jpg";
                    // Cycle through 10 images smoothly
                    imgIdx = (imgIdx % 10) + 1;
            %>
                <!-- INDIVIDUAL CATEGORY CIRCLE -->
                <a href="searchMenu?query=<%= category %>" class="category-item">
                    <div class="category-circle" style="width: 100px; height: 100px; border-radius: 50%; overflow: hidden; margin-bottom: 12px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); border: 3px solid white;">
                        <img src="<%= itemImg %>" alt="<%= category %>" style="width: 100%; height: 100%; object-fit: cover;">
                    </div>
                    <span style="font-weight: 700; color: var(--text-dark); font-size: 15px;"><%= category %></span>
                </a>
            <% } %>
        </div>
    </div>

    <%@ include file="footer.jsp" %>
    
</body>
</html>
