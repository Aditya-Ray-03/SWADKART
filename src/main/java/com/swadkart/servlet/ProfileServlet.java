package com.swadkart.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.swadkart.dao.UserDao;
import com.swadkart.dao.impl.UserDaoImpl;
import com.swadkart.model.User;

@WebServlet("/updateProfile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao = new UserDaoImpl();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("loggedInUser");

        if (currentUser == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");

        if ("sendEmailOtp".equals(action)) {
            String newEmail = request.getParameter("email");
            String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
            session.setAttribute("emailVerifyOtp", otp);
            session.setAttribute("pendingEmail", newEmail);
            session.setAttribute("emailOtpTimestamp", System.currentTimeMillis());
            
            System.out.println("================================");
            System.out.println("SWADKART EMAIL OTP REQUESTED:");
            System.out.println("Email: " + newEmail);
            System.out.println("Your OTP is: " + otp);
            System.out.println("================================");
            
            response.setStatus(HttpServletResponse.SC_OK);
            return;
        }

        if ("verifyEmailOtp".equals(action)) {
            String inputOtp = request.getParameter("otp");
            String storedOtp = (String) session.getAttribute("emailVerifyOtp");
            String pendingEmail = (String) session.getAttribute("pendingEmail");
            Long otpTimestamp = (Long) session.getAttribute("emailOtpTimestamp");
            
            // Check for expiration (5 minutes)
            boolean isExpired = (otpTimestamp == null) || (System.currentTimeMillis() - otpTimestamp > 300000);

            if (isExpired) {
                session.removeAttribute("emailVerifyOtp");
                session.removeAttribute("pendingEmail");
                session.removeAttribute("emailOtpTimestamp");
                response.setStatus(HttpServletResponse.SC_GONE); // 410 Gone
                response.getWriter().write("OTP has expired");
                return;
            }

            if (storedOtp != null && storedOtp.equals(inputOtp)) {
                currentUser.setEmail(pendingEmail);
                boolean success = userDao.updateUser(currentUser);
                if (success) {
                    session.setAttribute("loggedInUser", currentUser);
                    session.removeAttribute("emailVerifyOtp");
                    session.removeAttribute("pendingEmail");
                    session.removeAttribute("emailOtpTimestamp");
                    response.setStatus(HttpServletResponse.SC_OK);
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("Invalid OTP");
            }
            return;
        }

        // Standard direct update (e.g., just name/phone)
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");

        currentUser.setFullName(fullName);
        currentUser.setPhone(phone);

        boolean success = userDao.updateUser(currentUser);

        if (success) {
            session.setAttribute("loggedInUser", currentUser);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Profile updated successfully");
        } else {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Failed to update profile");
        }
    }
}
