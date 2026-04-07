<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sign Up - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        :root {
            --auth-bg: #f8fafc;
        }
        body {
            background: var(--auth-bg);
            overflow-x: hidden;
        }
        .auth-split {
            display: flex;
            min-height: 100vh;
        }
        
        /* BANNER SIDE */
        .auth-banner {
            flex: 1.2;
            position: relative;
            background: #111;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 60px;
            overflow: hidden;
        }
        .auth-banner-img {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.6;
            filter: saturate(1.2) brightness(0.8);
        }
        .auth-banner-content {
            position: relative;
            z-index: 2;
            color: white;
            max-width: 500px;
        }
        .auth-banner-logo {
            font-size: 42px;
            font-weight: 900;
            margin-bottom: 20px;
        }
        .auth-banner-logo span { color: var(--primary-color); }
        .auth-banner-title {
            font-size: 48px;
            line-height: 1.1;
            font-weight: 800;
            margin-bottom: 20px;
        }
        .auth-banner-desc {
            font-size: 18px;
            opacity: 0.9;
            line-height: 1.6;
        }

        /* FORM SIDE */
        .auth-form-side {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px;
            background: white;
            position: relative;
        }
        .auth-card {
            width: 100%;
            max-width: 440px;
        }
        .auth-header {
            margin-bottom: 35px;
            text-align: left;
        }
        .auth-header h2 {
            font-size: 32px;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 10px;
        }

        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            font-weight: 600;
            color: #475569;
            font-size: 14px;
            margin-bottom: 8px;
            display: block;
        }
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #f1f5f9;
            border-radius: 12px;
            font-size: 15px;
            background: #f8fafc;
            transition: all 0.3s ease;
        }
        .form-group input:focus {
            background: white;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(255, 107, 107, 0.1);
            outline: none;
        }
        
        @media (max-width: 992px) {
            .auth-banner { display: none; }
            .auth-form-side { flex: 1; background: var(--auth-bg); }
            .auth-card {
                background: white;
                padding: 40px;
                border-radius: 24px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
            }
        }
    </style>
</head>
<body>
    <div class="auth-split">
        <!-- BANNER SIDE -->
        <div class="auth-banner">
            <img src="https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=1200&q=80" class="auth-banner-img" alt="Background">
            <div class="auth-banner-content">
                <div class="auth-banner-logo">Swad<span>Kart</span></div>
                <h1 class="auth-banner-title">Welcome to the Family</h1>
                <p class="auth-banner-desc">You're just one step away from unlocking professional-grade dining and effortless ordering.</p>
            </div>
        </div>

        <!-- FORM SIDE -->
        <div class="auth-form-side">
            <div class="auth-card">
                <div class="auth-header">
                    <h2>Final Setup</h2>
                    <p style="color: #64748b; margin-top: 5px;">Let's complete your professional profile</p>
                </div>
                
                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    if(error != null) { 
                %>
                    <div style="background: #fef2f2; color: #991b1b; padding: 12px; border-radius: 12px; border: 1px solid #fee2e2; margin-bottom: 20px; font-size: 14px;">
                        <i class="fa-solid fa-circle-exclamation" style="margin-right: 8px;"></i> <%=error%>
                    </div>
                <% } %>

                <form action="signup" method="post">
                    <%
                        String pendingPhone = (String) session.getAttribute("pendingSetupPhone");
                    %>
                    <div class="form-group">
                        <label>Verified Mobile</label>
                        <input type="text" value="+91 <%= pendingPhone != null ? pendingPhone : "" %>" disabled style="background: #f1f5f9; color: #64748b;">
                    </div>
                    
                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" required placeholder="name@example.com">
                    </div>
                    
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="fullName" required placeholder="Enter your full name">
                    </div>
                    
                    <button type="submit" class="btn-primary" style="width: 100%; padding: 16px; border-radius: 12px; font-weight: 800; font-size: 16px; margin-top: 10px;">
                        Create Account <i class="fa-solid fa-circle-check" style="margin-left: 10px;"></i>
                    </button>
                </form>

                <div style="margin-top: 30px; text-align: center;">
                    <p style="color: #94a3b8; font-size: 13px;">By continuing, you agree to our <a href="#" style="color: var(--primary-color); font-weight: 600; text-decoration: none;">Terms of Service</a></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
