package com.swadkart.servlet;

import java.io.IOException;

import com.swadkart.dao.UserDao;
import com.swadkart.dao.impl.UserDaoImpl;
import com.swadkart.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet handling the 2-step OTP-based modern authentication flow.
 * Intercepts 'sendOtp' to generate a secure PIN and 'verifyOtp' to 
 * authorize standard users or funnel them to onboarding.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    /**
     * Handles initial rendering of the Login OTP interface.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    /**
     * Intercepts POST traffic mapped to OTP actions.
     * Generates simulated OTP on 'sendOtp'.
     * Validates session OTP against user input on 'verifyOtp'.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String phone = req.getParameter("phone");
        HttpSession session = req.getSession();

        if ("sendOtp".equals(action)) {
            // Step 1: Generate OTP and save to session
            if (phone == null || !phone.matches("\\d{10}")) {
                req.setAttribute("errorMessage", "Invalid 10-digit Phone Number!");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }
            
            // Generate pseudo-random 4 digit OTP
            int otp = 1000 + (int)(Math.random() * 8999);
            session.setAttribute("generatedOtp", String.valueOf(otp));
            session.setAttribute("authPhone", phone);
            session.setAttribute("otpTimestamp", System.currentTimeMillis());
            
            // SIMULATE SMS SENDING SECURELY TO CONSOLE
            System.out.println("================================");
            System.out.println("SWADKART SECURE OTP REQUESTED:");
            System.out.println("Phone: " + phone);
            System.out.println("Your OTP is: " + otp);
            System.out.println("================================");

            // Forward to show OTP field
            req.setAttribute("step", "verifyOtp");
            req.getRequestDispatcher("login.jsp").forward(req, resp);

        } else if ("verifyOtp".equals(action)) {
            // Step 2: Check OTP
            String userOtp = req.getParameter("otp");
            String generatedOtp = (String) session.getAttribute("generatedOtp");
            String authPhone = (String) session.getAttribute("authPhone");
            Long otpTimestamp = (Long) session.getAttribute("otpTimestamp");
            
            // Check for expiration (5 minutes = 300,000 ms)
            boolean isExpired = (otpTimestamp == null) || (System.currentTimeMillis() - otpTimestamp > 300000);

            if (isExpired) {
                session.removeAttribute("generatedOtp");
                session.removeAttribute("authPhone");
                session.removeAttribute("otpTimestamp");
                req.setAttribute("errorMessage", "OTP has expired. Please request a new one.");
                req.setAttribute("step", "sendOtp");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
                return;
            }

            if (userOtp != null && userOtp.equals(generatedOtp)) {
                // OTP MATCH! Check if user exists...
                User user = userDao.getUserByPhone(authPhone);
                if (user != null) {
                    // Standard Login
                    session.setAttribute("loggedInUser", user);
                    session.removeAttribute("generatedOtp");
                    session.removeAttribute("authPhone");
                    session.removeAttribute("otpTimestamp");
                    resp.sendRedirect("index.jsp");
                } else {
                    // Need Name Setup
                    session.setAttribute("pendingSetupPhone", authPhone);
                    resp.sendRedirect("signup.jsp"); 
                }
            } else {
                // FAILS
                req.setAttribute("errorMessage", "Invalid OTP entered!");
                req.setAttribute("step", "verifyOtp"); 
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } else {
            resp.sendRedirect("login.jsp");
        }
    }
}
