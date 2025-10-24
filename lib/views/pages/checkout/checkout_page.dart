import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/checkout/checkout_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/cart/cart_provider.dart';
import '../../../providers/discount/discount_provider.dart';
import '../../widgets/dropdown/custom_dropdown.dart';
import '../../widgets/location_permission_dialog.dart';
import '../location_screen/location_screen.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin {
  final _addressController = TextEditingController();

  double? lat;
  double? lng;

  String? city;
  String paymentMethod = 'card';
  final Completer<GoogleMapController> _controller = Completer();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<CheckoutProvider>(context, listen: false).getCities();
      Provider.of<CartProvider>(context, listen: false).clearData();
      Provider.of<CheckoutProvider>(context, listen: false).clearData();
      Provider.of<DiscountProvider>(context, listen: false).clearCoupon();
      _determinePosition();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    _checkPermission(() {
      Provider.of<CheckoutProvider>(context, listen: false)
          .getCurrentLocation(context, _controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      isAppBar: false,
      subAppBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.yLightGreyColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: AppColors.yBlackColor,
                    ),
                  ),
                ),
                16.wSize,
                MainText(
                  'checkout'.tr,
                  fontSize: 22,
                  color: AppColors.yBlackColor,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    MainText(
                      'delivery_address'.tr,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yBlackColor,
                    ),
                    16.sSize,
                    _buildMapContainer(),
                    20.sSize,
                    _buildCityDropdown(),
                    16.sSize,
                    _buildAddressField(),
                    32.sSize,

                    // Payment Method Section
                    MainText(
                      'payment_method'.tr,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yBlackColor,
                    ),
                    16.sSize,
                    _buildPaymentOption(
                        'card', 'digital_payment'.tr, Icons.credit_card),
                    12.sSize,
                    _buildPaymentOption(
                        'wallet', 'wallet'.tr, Icons.account_balance_wallet),
                    12.sSize,
                    _buildPaymentOption('cash', 'cash'.tr, Icons.money),
                    32.sSize,

                    MainText(
                      'order_summary'.tr,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.yBlackColor,
                    ),
                    16.sSize,
                    _buildOrderSummary(),
                    32.sSize,
                  ],
                ),
              ),
            ),

            // Place Order Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .06),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: _buildPlaceOrderButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapContainer() {
    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1.5,
            color: AppColors.yLightGreyColor,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: checkoutProvider.myPosition != null
                      ? LatLng(checkoutProvider.myPosition!.latitude,
                          checkoutProvider.myPosition!.longitude)
                      : const LatLng(23, 89),
                  zoom: 12,
                ),
                minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                onTap: (latLng) => _navigateToLocationScreen(checkoutProvider),
                zoomControlsEnabled: false,
                compassEnabled: false,
                indoorViewEnabled: true,
                mapToolbarEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _buildMapButton(
                  icon: Icons.fullscreen,
                  onTap: () => _navigateToLocationScreen(checkoutProvider),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: _buildMapButton(
                  icon: Icons.my_location,
                  onTap: () => _determinePosition(),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMapButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              icon,
              color: AppColors.yPrimaryColor,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.yLightGreyColor,
            width: 1.5,
          ),
        ),
        child: CustomDropDown(
          list: checkoutProvider.cities.map((e) => e.name!).toList(),
          borderColor: Colors.transparent,
          hint: 'select_city'.tr,
          item: city,
          enabled: !checkoutProvider.cityLoader,
          onChange: (val) {
            city = val;
            checkoutProvider
                .getDeliveryCost(context, city: city!)
                .then((value) {
              Provider.of<CartProvider>(context, listen: false)
                  .setDeliveryCost(checkoutProvider.deliveryCost ?? 0);
            });
          },
          validator: (val) => null,
        ),
      );
    });
  }

  Widget _buildAddressField() {
    return Selector<CheckoutProvider, String?>(
      selector: (context, checkoutProvider) => checkoutProvider.address,
      builder: (context, address, _) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.yLightGreyColor,
              width: 1.5,
            ),
          ),
          child: MainMultiLinesTextField(
            maxLines: 3,
            borderColor: Colors.transparent,
            hint: 'enter_address'.tr,
            controller: _addressController,
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          paymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: paymentMethod == value
                ? AppColors.yPrimaryColor
                : AppColors.yLightGreyColor,
            width: paymentMethod == value ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: paymentMethod == value
                      ? AppColors.yPrimaryColor
                      : AppColors.yGreyColor,
                  width: 2,
                ),
                color: paymentMethod == value
                    ? AppColors.yPrimaryColor
                    : Colors.transparent,
              ),
              child: paymentMethod == value
                  ? const Center(
                      child: Icon(
                        Icons.circle,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            16.wSize,
            Icon(
              icon,
              color: paymentMethod == value
                  ? AppColors.yPrimaryColor
                  : AppColors.yGreyColor,
              size: 22,
            ),
            12.wSize,
            MainText(
              title,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: paymentMethod == value
                  ? AppColors.yBlackColor
                  : AppColors.yGreyColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.yLightGreyColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            _buildSummaryRow('sub_total'.tr,
                '\$${cartProvider.subTotalPrice.toStringAsFixed(2)}'),
            12.sSize,
            _buildSummaryRow('delivery_charge'.tr,
                '\$${cartProvider.deliveryCost.toStringAsFixed(2)}'),
            12.sSize,
            _buildSummaryRow(
                'discount'.tr, '-\$${cartProvider.discount.toStringAsFixed(2)}',
                isDiscount: true),
            16.sSize,
            Divider(color: AppColors.yGreyColor.withOpacity(0.3), thickness: 1),
            16.sSize,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  'total'.tr,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.yBlackColor,
                ),
                MainText(
                  '\$${cartProvider.totalPrice.toStringAsFixed(2)}',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.yBlackColor,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MainText(
          label,
          fontSize: 15,
          color: AppColors.yGreyColor,
          fontWeight: FontWeight.w500,
        ),
        MainText(
          value,
          fontSize: 15,
          color: isDiscount ? AppColors.yGreenColor : AppColors.yBlackColor,
          fontWeight: FontWeight.w600,
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      return Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: checkoutProvider.checkoutLoader
              ? LinearGradient(
                  colors: [
                    AppColors.yGreyColor.withOpacity(0.5),
                    AppColors.yGreyColor.withOpacity(0.7)
                  ],
                )
              : const LinearGradient(
                  colors: [
                    AppColors.yPrimaryColor,
                    AppColors.ySecondryColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          boxShadow: [
            BoxShadow(
              color: checkoutProvider.checkoutLoader
                  ? Colors.grey.withValues(alpha: 0.3)
                  : AppColors.yPrimaryColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: checkoutProvider.checkoutLoader
              ? null
              : () {
                  if (city == null) {
                    showSnackbar('please_select_city'.tr);
                  } else if (_addressController.text.isEmpty) {
                    showSnackbar('please_select_address'.tr);
                  } else if (lat == null || lng == null) {
                    showSnackbar('please_pick_location'.tr);
                  } else {
                    checkoutProvider.checkout(
                      context,
                      city: city!,
                      address: _addressController.text,
                      paymentMethod: paymentMethod,
                      lat: lat!,
                      lng: lng!,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: checkoutProvider.checkoutLoader
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    12.wSize,
                    MainText(
                      'wait'.tr,
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                )
              : MainText(
                  'place_order'.tr,
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
        ),
      );
    });
  }

  void _navigateToLocationScreen(CheckoutProvider checkoutProvider) {
    AppRoutes.routeTo(
      context,
      LocationScreen(
        latLng: checkoutProvider.myPosition != null
            ? LatLng(
                checkoutProvider.myPosition!.latitude,
                checkoutProvider.myPosition!.longitude,
              )
            : const LatLng(23, 89),
      ),
      then: (value) {
        if (value != null && value.isNotEmpty) {
          _addressController.text = value['address'];
          lat = value['lat'];
          lng = value['lng'];
        }
      },
    );
  }

  void _checkPermission(Function onTap) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      showSnackbar('you_have_to_allow'.tr);
    } else if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (context) => const PermissionDialog(),
      );
    } else {
      onTap();
    }
  }
}
