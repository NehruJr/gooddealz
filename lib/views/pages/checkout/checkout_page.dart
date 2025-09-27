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
  final _couponController = TextEditingController();
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
      actionWidgets: [
        Container(
          height: 90,
          width: 110,
          padding: const EdgeInsets.only(top: 6.0),
          child: Hero(
            tag: 'logo',
            child: Image.asset(
              getPngAsset('black_logo'),
              fit: BoxFit.cover,
            ),
          ),
        )
      ],
      subAppBar: Container(
        padding: 16.vhEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.ySecondryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shopping_cart_checkout,
                color: AppColors.ySecondryColor,
                size: 22,
              ),
            ),
            16.wSize,
            MainText(
              'checkout'.tr,
              fontSize: 22,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: 16.aEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                icon: Icons.location_on,
                title: 'delivery_address'.tr,
                child: Column(
                  children: [
                    16.sSize,
                    _buildMapContainer(),
                    20.sSize,
                    _buildCityDropdown(),
                    16.sSize,
                    _buildAddressField(),
                  ],
                ),
              ),
              24.sSize,
              _buildSectionCard(
                icon: Icons.payment,
                title: 'payment_method'.tr,
                child: Column(
                  children: [
                    12.sSize,
                    _buildPaymentOption(
                        'card', 'digital_payment'.tr, Icons.credit_card),
                    _buildPaymentOption(
                        'wallet', 'wallet'.tr, Icons.account_balance_wallet),
                    _buildPaymentOption('cash', 'cash'.tr, Icons.money),
                  ],
                ),
              ),
              24.sSize,
              _buildSectionCard(
                icon: Icons.discount,
                title: 'coupon_code'.tr,
                child: Column(
                  children: [
                    16.sSize,
                    _buildCouponField(),
                  ],
                ),
              ),
              24.sSize,
              _buildSectionCard(
                icon: Icons.receipt_long,
                title: 'order_summary'.tr,
                child: Column(
                  children: [
                    16.sSize,
                    _buildOrderSummary(),
                  ],
                ),
              ),
              32.sSize,
              _buildPlaceOrderButton(),
              32.sSize,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.ySecondryColor.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.ySecondryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                12.wSize,
                MainText(
                  title,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMapContainer() {
    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 2,
            color: AppColors.ySecondryColor.withValues(alpha: 0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
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
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.1),
                    ],
                  ),
                ),
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
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _navigateToLocationScreen(checkoutProvider),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.touch_app,
                                size: 16,
                                color: AppColors.ySecondryColor,
                              ),
                              8.wSize,
                              MainText(
                                'tap_to_select_location'.tr,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.ySecondryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
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
            color: Colors.black.withValues(alpha: 0.15),
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
              color: AppColors.ySecondryColor,
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
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.ySecondryColor.withValues(alpha: 0.3),
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
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.ySecondryColor.withValues(alpha: 0.3),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: paymentMethod == value
            ? AppColors.ySecondryColor.withValues(alpha: 0.1)
            : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: paymentMethod == value
              ? AppColors.ySecondryColor
              : Colors.grey[300]!,
          width: paymentMethod == value ? 2 : 1,
        ),
      ),
      child: RadioListTile(
        value: value,
        activeColor: AppColors.ySecondryColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        onChanged: (selectedValue) {
          setState(() {
            paymentMethod = selectedValue ?? '';
          });
        },
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: paymentMethod == value
                    ? AppColors.ySecondryColor
                    : Colors.grey[400],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            12.wSize,
            MainText(
              title,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: paymentMethod == value
                  ? AppColors.ySecondryColor
                  : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.ySecondryColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: MainTextField(
              controller: _couponController,
              hint: 'have_coupon'.tr,
              borderColor: Colors.transparent,
            ),
          ),
          Consumer<DiscountProvider>(
            builder: (context, discountProvider, _) {
              if (discountProvider.couponLoader) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.ySecondryColor,
                      ),
                    ),
                  ),
                );
              }

              return Container(
                margin: const EdgeInsets.all(4),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_couponController.text.isNotEmpty) {
                      discountProvider
                          .applyCoupon(_couponController.text)
                          .then((value) {
                        Provider.of<CartProvider>(context, listen: false)
                            .setCoupon(discountProvider.discountCoupon);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ySecondryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: MainText(
                    'apply'.tr,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      return Column(
        children: [
          _buildSummaryRow('sub_total'.tr,
              '${cartProvider.subTotalPrice} ${cartProvider.currency}'),
          12.sSize,
          _buildSummaryRow('delivery_charge'.tr,
              '${cartProvider.deliveryCost} ${cartProvider.currency}'),
          12.sSize,
          _buildSummaryRow('discount'.tr,
              '${cartProvider.discount.toStringAsFixed(2)} ${cartProvider.currency}',
              isDiscount: true),
          20.sSize,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.ySecondryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MainText(
                  'total'.tr,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ySecondryColor,
                ),
                MainText(
                  '${cartProvider.totalPrice} ${cartProvider.currency}',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ySecondryColor,
                  textDirection: TextDirection.ltr,
                ),
              ],
            ),
          ),
        ],
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
          fontSize: 16,
          color: Colors.black.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
        ),
        MainText(
          value,
          fontSize: 16,
          color:
              isDiscount ? Colors.green : Colors.black.withValues(alpha: 0.7),
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
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                )
              : LinearGradient(
                  colors: [
                    AppColors.ySecondryColor,
                    AppColors.ySecondryColor.withValues(alpha: 0.8),
                  ],
                ),
          boxShadow: [
            BoxShadow(
              color: checkoutProvider.checkoutLoader
                  ? Colors.grey.withValues(alpha: 0.3)
                  : AppColors.ySecondryColor.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
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
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    12.wSize,
                    MainText(
                      'place_order'.tr,
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
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
