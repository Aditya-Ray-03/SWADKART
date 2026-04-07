package com.swadkart.servlet;

import java.io.IOException;
import java.util.List;

import com.swadkart.dao.MenuDao;
import com.swadkart.dao.RestaurantDao;
import com.swadkart.dao.impl.MenuDaoImpl;
import com.swadkart.dao.impl.RestaurantDaoImpl;
import com.swadkart.model.MenuItem;
import com.swadkart.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet responsible for rendering the detailed menu view of a specific restaurant.
 * Interacts with both the RestaurantDao and MenuDao to pack the view with rich data.
 */
@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

	private MenuDao menuDao;
	private RestaurantDao restaurantDao;

	/**
	 * Initializes dependent DAO components.
	 */
	@Override
	public void init() throws ServletException {
		menuDao = new MenuDaoImpl();
		restaurantDao = new RestaurantDaoImpl();
	}

	/**
	 * Intercepts navigation to a specific Menu page by tracking the 'restaurantId' parameter.
	 * Generates a redirect or routes cleanly to the menu view based on database validity.
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 1️⃣ Get restaurantId from URL
		String idParam = request.getParameter("restaurantId");

		if (idParam == null || idParam.equals("null") || idParam.isEmpty()) {
			System.out.println("❌ restaurantId is missing");
			response.sendRedirect("restaurants");
			return;
		}

		long restaurantId = Long.parseLong(idParam);

		// 2️⃣ Fetch menu and restaurant
		String query = request.getParameter("query");
		List<MenuItem> menuList;
		if (query != null && !query.trim().isEmpty()) {
			menuList = menuDao.getMenuByRestaurantId(restaurantId, query.trim());
			request.setAttribute("searchQuery", query.trim());
		} else {
			menuList = menuDao.getMenuByRestaurantId(restaurantId);
		}
		
		Restaurant restaurant = restaurantDao.getRestaurantById(restaurantId);

		// 3️⃣ Send to JSP
		request.setAttribute("menuList", menuList);
		request.setAttribute("restaurant", restaurant);

		RequestDispatcher rd = request.getRequestDispatcher("menu.jsp");
		rd.forward(request, response);
	}
}