<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - SwadKart</title>
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
            max-width: 420px;
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
        
        /* SOCIAL LOGIN */
        .social-login {
            display: flex;
            flex-direction: column;
            gap: 12px;
            margin-bottom: 30px;
        }
        .btn-social {
            width: 100%;
            padding: 12px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
            font-weight: 600;
            color: #475569;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .btn-social:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 25px 0;
            color: #94a3b8;
            font-size: 13px;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid #e2e8f0;
        }
        .divider:not(:empty)::before { margin-right: .75em; }
        .divider:not(:empty)::after { margin-left: .75em; }

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
            <img src="https://images.unsplash.com/photo-1543353071-873f17a7a088?auto=format&fit=crop&w=1200&q=80" class="auth-banner-img" alt="Background">
            <div class="auth-banner-content">
                <div class="auth-banner-logo">Swad<span>Kart</span></div>
                <h1 class="auth-banner-title">Elevate Your Dining Experience</h1>
                <p class="auth-banner-desc">Join thousands of food lovers and explore the finest flavors in your city—delivered with speed and care.</p>
            </div>
        </div>

        <!-- FORM SIDE -->
        <div class="auth-form-side">
            <div class="auth-card">
                <div class="auth-header">
                    <h2>Welcome</h2>
                    <p style="color: #64748b; margin-top: 5px;">Join thousands of food lovers today</p>
                </div>
                
                <div class="divider">continue with mobile</div>

                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    String step = (String) request.getAttribute("step");
                    if (step == null) step = "sendOtp";
                    
                    if(error != null) { 
                %>
                    <div style="background: #fef2f2; color: #991b1b; padding: 12px; border-radius: 12px; border: 1px solid #fee2e2; margin-bottom: 20px; font-size: 14px;">
                        <i class="fa-solid fa-circle-exclamation" style="margin-right: 8px;"></i> <%=error%>
                    </div>
                <% } %>

                <form action="login" method="post">
                    <input type="hidden" name="action" value="<%= step %>">
                    
                    <% if ("sendOtp".equals(step)) { %>
                        <div class="form-group">
                            <label>Mobile Number</label>
                            <div style="display: flex; gap: 12px;">
                                <div style="display: flex; align-items: center; justify-content: center; width: 65px; height: 52px; background: #f1f5f9; border-radius: 12px; font-weight: 700; color: #475569; font-size: 15px;">+91</div>
                                <input type="text" name="phone" required placeholder="10-digit mobile number" maxlength="10" pattern="[0-9]{10}" style="flex: 1;">
                            </div>
                        </div>
                        <button type="submit" class="btn-primary" style="width: 100%; padding: 16px; border-radius: 12px; font-weight: 800; font-size: 16px;">
                            Request OTP <i class="fa-solid fa-arrow-right" style="margin-left: 10px;"></i>
                        </button>
                        <p style="font-size: 12px; color: #94a3b8; margin-top: 20px; line-height: 1.5;">
                            Secure verification via OTP. Standard carrier rates may apply.
                        </p>
                    <% } else if ("verifyOtp".equals(step)) { 
                        String authPhone = (String) session.getAttribute("authPhone");
                    %>
                        <div class="form-group">
                            <label>OTP sent to +91 <%= authPhone %></label>
                            <input type="text" name="otp" required placeholder="0000" maxlength="4" style="letter-spacing: 12px; text-align: center; font-size: 24px; font-weight: 900; color: var(--primary-color);">
                        </div>
                        <button type="submit" class="btn-primary" style="width: 100%; padding: 16px; border-radius: 12px; font-weight: 800; font-size: 16px;">
                            Verify & Unlock <i class="fa-solid fa-shield-halved" style="margin-left: 10px;"></i>
                        </button>
                    <% } %>
                </form>
                
                <div style="margin-top: 30px; text-align: center;">
                    <a href="index.jsp" style="color: #64748b; text-decoration: none; font-size: 14px; font-weight: 600;">
                        <i class="fa-solid fa-chevron-left" style="font-size: 12px; margin-right: 5px;"></i> Back to Store
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
