class AppEndpoints{
  static String baseUrl = 'https://goodealz.net';
  static String paymentUrl = 'https://api.sofcopay.com';

  static String imageUrl = '$baseUrl/storage';

  static String login = '/api/login';
  static String register = '/api/register';
  static String getNationalities = '/api/get-nationalities';
  static String phoneVerification = '/api/phone-verification';
  static String resendOtp = '/api/resend-otp';
  static String profile = '/api/profile';
  static String logout = '/api/logout';
  static String forgetPassword = '/api/forget-password';
  static String resetPassword = '/api/reset-password';
  static String checkVerificationCode = '/api/check-reset-password-code';
  static String getProfile = '/api/profile';
  static String updateProfile = '/api/update_profile';
  static String socialLogin = '/api/social/login';
  static String socialRegister = '/api/social/register';
  static String deleteAccount = '/api/delete_account';
  static String loginAsGuest = '/api/login_as_guest';
  static String updateFCM = '/api/update_fcm';

  static String faqs = '/api/faqs';
  static String aboutUs = '/api/about-us';
  static String contactUs = '/api/contact-us';
  static String howItWorks = '/api/how-its-work';
  static String banners = '/api/banners';
  static String terms = '/api/terms-and-conditions';
  static String privacyPolicy = '/api/privacy-policy';
  static String myWallet = '/api/my_wallet';
  static String chargeWallet = '/api/charge_wallet';

  static String products = '/api/products?title&min_price&max_price';
  static String favoriteProducts = '/api/favorite-products';
  static String toggleFavorite = '/api/toggle-favorite';
  static String winners = '/api/prizes/winners';
  static String soldOutPrizes = '/api/prizes/sold-out';
  static String sellingFastPrizes = '/api/prizes/selling-fast-prizes';
  static String sellingFastDetails = '/api/prize/';
  static String possibleProducts= '/api/possible_products';

  static String addPrizeToCart = '/api/add-prize-to-cart';
  static String getCartProducts = '/api/get-cart-products';
  static String deleteCartProduct = '/api/cart/delete';
  static String updateCartQuantity = '/api/cart/update-quantity';
  static String cartCount = '/api/products_count';
  static String checkout = '/api/order/checkout';
  static String updateTransaction = '/api/update_transaction';
  static String cancelOrder = '/api/cancel/';
  static String repayOrder = '/api/repay';

  static String getDiscount = '/api/get-coupon-by-code';
  static String getAllCoupons = '/api/get-all-coupons';
  static String getDeliveryCost = '/api/calculate_cost';
  static String userCoupon = '/api/user_coupons';
  static String cities = '/api/get_cities';

  static String getNotifications = '/api/get-notifications';
  static String markAsRead = '/api/notifications/mark-as-read';
  static String clearNotification = '/api/notifications/clear-notifications';

  static String purchaseCode = '/api/tickets/get-purchase-code';
  static String tickets = '/api/tickets';
  static String getTicketReplies = '/api/get-ticket-replies';
  static String createReply = '/api/create-reply';

  // static String getOrder = '/api/all_orders';
  static String getOrder = '/api/orders';

  static String ongoingActions = '/api/ongoing_auctions';

  static String productPurchaseCodes = '/api/purchase_codes';
}

