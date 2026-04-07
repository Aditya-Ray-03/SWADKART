<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Success - SwadKart</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/canvas-confetti@1.6.0/dist/confetti.browser.min.js"></script>
</head>
<body style="background: #f8f9fb;">
    <div class="success-card">
        <div class="success-icon">
            <i class="fa-solid fa-check"></i>
        </div>
        <h1 style="font-size: 28px; color: var(--text-dark); margin-bottom: 10px;">Order Placed Successfully!</h1>
        <p style="color: #666; font-size: 16px; margin-bottom: 30px;">Hold tight! We've notified the restaurant and your foodie journey has begun.</p>
        
        <% String orderId = request.getParameter("orderId"); %>
        <div style="background: #f1f2f6; padding: 15px; border-radius: 12px; margin-bottom: 30px;">
            <p style="font-size: 13px; color: #888; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px;">Order ID</p>
            <p style="font-size: 20px; font-weight: 800; color: var(--primary-color);">#<%= orderId %></p>
        </div>

        <div style="display: flex; flex-direction: column; gap: 15px;">
            <a href="restaurants" class="btn-primary" style="padding: 15px; border-radius: 12px; text-decoration: none; font-weight: 700;">
                <i class="fa-solid fa-bag-shopping"></i> Order More Food
            </a>
            <button onclick="window.location.href='index.jsp'" style="background: none; border: none; color: #888; cursor: pointer; font-size: 14px; font-weight: 600;">
                Back to Home
            </button>
        </div>
    </div>

    <script>
        // Trigger confetti on load
        window.addEventListener('load', () => {
            const count = 200;
            const defaults = {
                origin: { y: 0.7 },
                colors: ['#ff4757', '#ff6b81', '#2f3542']
            };

            function fire(particleRatio, opts) {
                confetti({
                    ...defaults,
                    ...opts,
                    particleCount: Math.floor(count * particleRatio)
                });
            }

            fire(0.25, { spread: 26, startVelocity: 55 });
            fire(0.2, { spread: 60 });
            fire(0.35, { spread: 100, decay: 0.91, scalar: 0.8 });
            fire(0.1, { spread: 120, startVelocity: 25, decay: 0.92, scalar: 1.2 });
            fire(0.1, { spread: 120, startVelocity: 45 });
        });
    </script>
    <%@ include file="footer.jsp" %>
</body>
</html>
