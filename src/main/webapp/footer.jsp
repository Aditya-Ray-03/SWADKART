<!-- MODERN PREMIUM RICH FOOTER -->
<footer class="sw-premium-footer">
	<div class="container">
		<div class="row">
			<div class="col-lg-2 name">
				<h1>
					<b>SwadKart</b>
				</h1>
				<p>
					"We are here to connect you with your next favorite meal quickly
					and effortlessly. Browse through a wide collection of restaurants
					and order your food with just a few clicks." <span
						style="font-size: 10px; margin-top: 10px;"> <a
						href="javascript:void(0)" onclick="openPolicyModal('terms')">T&amp;C
							Apply</a>
					</span>
				</p>
			</div>
			<div class="col-lg-3 connect">
				<h3>Let's Get Connected</h3>
				<ul class="footer-icons">
					<li><a href="#"><i class="bi bi-twitter-x"></i></a></li>
					<li><a href="#"><i class="bi bi-facebook"></i></a></li>
					<li><a href="#"><i class="bi bi-instagram"></i></a></li>
					<li><a href="#"><i class="bi bi-linkedin"></i></a></li>
					<li><a href="#"><i class="bi bi-youtube"></i></a></li>
				</ul>
			</div>
			<div class="col-lg-3 chef">
				<h3>Become a Partner</h3>
				<ul class="chef-details">
					<li><a href="signup">Register as a Restaurant</a></li>
					<li><a href="javascript:void(0)"
						onclick="openPolicyModal('app')">Install Partner App</a></li>
					<li><a href="javascript:void(0)"
						onclick="openPolicyModal('contact')">Partner Support</a></li>
				</ul>
			</div>
			<div class="col-lg-4 services">
				<h3 class="no">Cuisines We Offer</h3>
				<h3 class="yes">Cuisines</h3>
				<ul class="service-list no" style="display: inline-flex;">
					<li><a href="#">Biryani</a></li>
					<li><a href="#">North Indian</a></li>
					<li><a href="#">South Indian</a></li>
					<li class="last-item"><a href="#">Chinese</a></li>
				</ul>
				<ul class="service-list no" style="display: inline-flex;">
					<li><a href="#">Desserts</a></li>
					<li><a href="#">Beverages</a></li>
					<li><a href="#">Pure Veg</a></li>
					<li class="last-item"><a href="#">Street Food</a></li>
				</ul>
				<ul class="service-list yes">
					<li><a href="#">Biryani</a></li>
					<li><a href="#">North Indian</a></li>
					<li><a href="#">South Indian</a></li>
					<li><a href="#">Chinese</a></li>
					<li><a href="#">Pure Veg</a></li>
				</ul>
			</div>

			<div class="col-lg-12 line"></div>

			<div class="col-lg-12 customer">
				<h3 class="no">For Foodies</h3>
				<h3 class="yes">Foodies</h3>
				<ul class="customer-links">
					<li><a href="login"><b>SignUp/Login</b></a></li>
					<li><a href="javascript:void(0)"
						onclick="openPolicyModal('profile')"><b>My Profile</b></a></li>
					<li><a href="javascript:void(0)"
						onclick="openPolicyModal('orders')"><b>My Orders</b></a></li>
					<li><a href="javascript:void(0)"
						onclick="openPolicyModal('contact')"><b>Contact Us</b></a></li>
					<li><a href="javascript:void(0)"
						onclick="openPolicyModal('how_to_use')"><b>How to Use</b></a></li>
					<li style="display: flex; align-items: center; gap: 10px;"><a
						href="javascript:void(0)" onclick="openPolicyModal('app')"><b>Install
								SwadKart App <i
								style="border: 2px solid white; padding: 5px 13px; border-radius: 10px;    margin-top: -5px;"
								class="fa-brands fa-google-play"></i>
						</b></a>
						<div class="app-badge-footer"></div></li>
				</ul>
			</div>

			<div class="col-lg-12 line no" style="margin-top: 20px;"></div>

			<div class="col-lg-3 rules">
				<a href="javascript:void(0)" onclick="openPolicyModal('terms')">Terms
					& Conditions</a>
			</div>
			<div class="col-lg-3 rules">
				<a href="javascript:void(0)" onclick="openPolicyModal('privacy')">Privacy
					Policy</a>
			</div>
			<div class="col-lg-3 rules">
				<a href="javascript:void(0)" onclick="openPolicyModal('return')">Return
					Policy</a>
			</div>
			<div class="col-lg-3 rules">
				<a href="javascript:void(0)"
					onclick="openPolicyModal('cancellation')">Cancellations</a>
			</div>
		</div>

		<div
			style="text-align: center; margin-top: 40px; color: #888; font-size: 12px; border-top: 1.5px solid var(--primary-color); padding-top: 25px; opacity: 0.8;">
			<p style="text-align: center; margin-right: 0;">
				&copy; 2026 SwadKart. All rights reserved. Designed with <img
					alt="love" height="15px"
					src="https://cdn-icons-png.flaticon.com/128/9484/9484251.png">èfor Foodies.
			</p>
		</div>
	</div>
</footer>

<!-- POLICY MODAL SYSTEM -->
<div id="policyModalOverlay" class="sw-modal-overlay">
	<div class="sw-modal">
		<div class="sw-modal-header">
			<h2 id="modalTitle">Policy</h2>
			<button class="sw-modal-close" onclick="closePolicyModal()">&times;</button>
		</div>
		<div class="sw-modal-body" id="modalBody">
			<!-- Content injected via JS -->
		</div>
		<div class="sw-modal-footer">
			<button class="btn-close-modal" onclick="closePolicyModal()">Close</button>
		</div>
	</div>
</div>

<script>
	const policyContent = {
		'terms' : {
			title : 'Terms & Conditions',
			body : '<h4>1. Introduction</h4><p>Welcome to SwadKart. By using our service, you agree to these terms. Please read them carefully.</p><h4>2. Ordering</h4><p>Orders are subject to restaurant availability and delivery range. Once an order is prepared, modifications may not be possible.</p><h4>3. User Responsibility</h4><p>You must provide accurate information for delivery. Misuse of the platform may lead to account suspension.</p>'
		},
		'privacy' : {
			title : 'Privacy Policy',
			body : '<h4>Data Collection</h4><p>We collect your name, email, and address solely to fulfill your food orders and provide a personalized experience.</p><h4>Security</h4><p>Your data is encrypted and never sold to third parties. We use industry-standard security protocols to protect your information.</p>'
		},
		'return' : {
			title : 'Return Policy',
			body : '<h4>Refund Eligibility</h4><p>Refunds or returns are processed if: 1. The item delivered is incorrect. 2. The food quality is significantly below standard. 3. Items are missing from your order.</p><h4>Process</h4><p>Please contact support within 30 minutes of delivery for any return/refund claims.</p>'
		},
		'cancellation' : {
			title : 'Cancellations',
			body : '<h4>Customer Cancellations</h4><p>You can cancel your order for a full refund if the restaurant hasn\'t started preparing it. Once preparation begins, a partial or no refund may be issued.</p><h4>Restaurant Cancellations</h4><p>If a restaurant cancels your order, a 100% refund will be credited to your wallet or original payment method immediately.</p>'
		},
		'contact' : {
			title : 'Contact Us',
			body : '<h4>Customer Support</h4><p>We are here to help you 24/7. Reach out through any of these channels:</p><p><i class="bi bi-telephone-fill"></i> Helpline: 1800-SWAD-KART<br><i class="bi bi-envelope-fill"></i> Email: support@swadkart.com<br><i class="bi bi-chat-dots-fill"></i> Live Chat: Available in the App</p>'
		},
		'how_to_use' : {
			title : 'How to Use SwadKart',
			body : '<h4>Step 1: Browse</h4><p>Search for your favorite restaurants or cuisines using the search bar or category filters.</p><h4>Step 2: Add to Cart</h4><p>Pick the delicious items you want and customize them if needed.</p><h4>Step 3: Secure Checkout</h4><p>Verify your delivery address and pay securely using multiple payment options.</p><h4>Step 4: Track Order</h4><p>Watch your food travel to you in real-time until it reaches your doorstep!</p>'
		},
		'profile' : {
			title : 'My Profile',
			body : '<p>Please log in to view and edit your profile details.</p>'
		},
		'orders' : {
			title : 'My Orders',
			body : '<p>Login to see your past orders and current tracking status.</p>'
		},
		'wallet' : {
			title : 'Wallet',
			body : '<p>Manage your SwadKart credits and view transaction history after logging in.</p>'
		},
		'refer' : {
			title : 'Refer & Earn',
			body : '<p>Share your unique code with friends and get ‚Çπ100 credit on their first order!</p>'
		},
		'app' : {
			title : 'Install SwadKart App',
			body : '<p>Experience faster ordering and exclusive deals. Download SwadKart from App Store or Play Store today!</p>'
		}
	};

	function openPolicyModal(type) {
		const modal = policyContent[type];
		if (modal) {
			document.getElementById('modalTitle').innerText = modal.title;
			document.getElementById('modalBody').innerHTML = modal.body;
			document.getElementById('policyModalOverlay').style.display = 'flex';
			document.body.style.overflow = 'hidden'; // Prevent background scroll
		}
	}

	function closePolicyModal() {
		document.getElementById('policyModalOverlay').style.display = 'none';
		document.body.style.overflow = ''; // Restore scroll
	}

	// Close on overlay click
	window.onclick = function(event) {
		const overlay = document.getElementById('policyModalOverlay');
		if (event.target == overlay) {
			closePolicyModal();
		}
	}
</script>
