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
 * Servlet handling the secondary onboarding phase of the OTP flow.
 * Specifically handles the profile creation for users verified via mobile OTP
 * but do not yet exist in the DB ecosystem.
 */
@WebServlet("/signup")
public class RegisterServlet extends HttpServlet {
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    /**
     * Handles initial rendering of the onboarding profile phase (signup.jsp).
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("signup.jsp").forward(req, resp);
    }

    /**
     * Intercepts Name Setup submission. Auto-generates final profile entity
     * via UserDao and escalates the user immediately to logged-in session state.
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        HttpSession session = req.getSession();
        String pendingPhone = (String) session.getAttribute("pendingSetupPhone");

        if (pendingPhone == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        boolean success = userDao.registerUserPhone(pendingPhone, fullName, email);

        if (success) {
            // Log them in immediately
            User user = userDao.getUserByPhone(pendingPhone);
            session.setAttribute("loggedInUser", user);
            session.removeAttribute("pendingSetupPhone");
            resp.sendRedirect("index.jsp");
        } else {
            req.setAttribute("errorMessage", "Failed to create account. Something went wrong.");
            req.getRequestDispatcher("signup.jsp").forward(req, resp);
        }
    }
}
