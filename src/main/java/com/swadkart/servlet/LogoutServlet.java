package com.swadkart.servlet;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet handling the termination of persistent user sessions securely.
 * Automatically wipes internal session state.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    /**
     * Catches hyperlink redirects. Invalidates session memory completely 
     * and securely routs client gracefully to index.
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate(); // Clear session state entirely
        }
        resp.sendRedirect("index.jsp"); // Return back home securely
    }
}
