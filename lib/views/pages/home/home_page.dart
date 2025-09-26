import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/providers/conectivity_provider.dart';
import 'package:goodealz/providers/product/product_provider.dart';
import 'package:goodealz/providers/settings/settings_provider.dart';
import 'package:goodealz/views/pages/explore/explore_page.dart';
import 'package:goodealz/views/pages/home/widgets/banner_widget.dart';
import 'package:goodealz/views/pages/home/widgets/home_appbar.dart';
import 'package:goodealz/views/pages/winners/winners_page.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/product_widget.dart';
import 'package:goodealz/views/widgets/see_all_widget.dart';
import 'package:goodealz/views/widgets/winner_card.dart';

import '../../../providers/notification/notification_provider.dart';
import '../../../providers/prizes/prizes_provider.dart';
import '../../widgets/Connection_widget.dart';
import '../../widgets/home_shimmer/banner_shimmer.dart';
import '../../widgets/prize_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  late bool _isGuest;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  getData() async {
    _isGuest = Provider.of<AuthProvider>(context, listen: false).isGuest!;

    Provider.of<SettingsProvider>(context, listen: false).getBanners(context);
    if (!_isGuest) {
      Provider.of<ProductProvider>(context, listen: false)
          .getFavoriteProducts(context);
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotifications(context);
      Provider.of<PrizesProvider>(context, listen: false).getWinners(context);
      Provider.of<PrizesProvider>(context, listen: false)
          .getSellingFastPrizes(context);
      Provider.of<PrizesProvider>(context, listen: false)
          .getSoldOutPrizes(context);
    }
    Provider.of<ProductProvider>(context, listen: false).getProducts(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isGuest = Provider.of<AuthProvider>(context, listen: false).isGuest!;
    return MainPage(
      isAppBar: false,
      subAppBar: HomeAppBar(
        isGuest: isGuest,
      ),
      bottomNavigationBarIndex: 0,
      body: Consumer<ConectivityProvider>(builder: (context, connect, _) {
        if (connect.isOffline) {
          return const NoConnectionWidget();
        } else {
          return SingleChildScrollView(
            padding: 16.aEdge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  'explore'.tr,
                  fontSize: 26,
                  color: Colors.black,
                ),
                8.sSize,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MainText(
                      'today_deal'.tr,
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    // Row(
                    //   children: [
                    //     SvgPicture.asset(
                    //       getSvgAsset('Location'),
                    //     ),
                    //     const MainText(
                    //       '15/2 Dubai',
                    //       fontSize: 14,
                    //       color: Colors.black,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
                16.sSize,
                Consumer<ProductProvider>(
                    builder: (context, productProvider, _) {
                  return productProvider.productLoader
                      ? const SearchShimmer()
                      : MainTextField(
                          unfocusWhenTapOutside: true,
                          textInputAction: TextInputAction.search,
                          controller: _searchController,
                          prefixIcon: IconButton(
                            icon: SvgPicture.asset(
                              getSvgAsset('Search'),
                              height: 22,
                            ),
                            onPressed: () {
                              if (productProvider.searchProducts.isNotEmpty) {
                                AppRoutes.routeTo(context, const ExplorePage());
                                _searchController.clear();
                              } else {
                                showSnackbar('no_search'.tr);
                              }
                            },
                          ),
                          suffixIcon: productProvider.searchText.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    productProvider.clearSearch();
                                    _searchController.clear();
                                  },
                                  icon: const Icon(Icons.close),
                                )
                              : null,
                          hint: 'search_items'.tr,
                          onChanged: (value) {
                            productProvider.searchForProducts(value);
                          },
                          onSubmit: (value) {
                            if (productProvider.searchProducts.isNotEmpty) {
                              AppRoutes.routeTo(
                                  context,
                                  const ExplorePage(
                                    fromSearch: true,
                                  ));
                              _searchController.clear();
                            } else {
                              showSnackbar('no_search'.tr);
                            }
                          },
                        );
                }),
                16.sSize,
                Consumer<SettingsProvider>(
                  builder: (context, settingsProvider, _) {
                    return settingsProvider.bannerLoader
                        ? const Center(
                            child: BannerShimmer(),
                          )
                        : BannerWidget(
                            bannerModels: settingsProvider.bannerModel != null
                                ? [
                                    settingsProvider.bannerModel!,
                                    settingsProvider.bannerModel!,
                                    settingsProvider.bannerModel!,
                                    settingsProvider.bannerModel!,
                                  ]
                                : [],
                            textPosition: TextPosition.topLeft,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 5),
                            // indicatorStyle: IndicatorStyle.circle,
                           
                          );
                  },
                ),
                16.sSize,
                Consumer<PrizesProvider>(builder: (context, prizesProvider, _) {
                  if (prizesProvider.sellingFastLoader) {
                    return const Center(
                      child: SellingFastShimmer(),
                    );
                  } else {
                    return prizesProvider.sellingFastPrizes.isEmpty
                        ? 0.sSize
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              isGuest ||
                                      Provider.of<PrizesProvider>(context)
                                          .sellingFastPrizes
                                          .isEmpty
                                  ? 0.sSize
                                  : MainText(
                                      'selling_fast'.tr,
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                    ),
                              SizedBox(
                                height: 300,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    width: 5,
                                  ),
                                  itemCount:
                                      prizesProvider.sellingFastPrizes.length,
                                  itemBuilder: (context, index) {
                                    return PrizeWidget(
                                        prize: prizesProvider
                                            .sellingFastPrizes[index]);
                                  },
                                ),
                              ),
                            ],
                          );
                  }
                }),
                16.sSize,
                Consumer<ProductProvider>(
                    builder: (context, productProvider, _) {
                  return productProvider.productLoader
                      ? const Center(
                          child: ExploreProductShimmer(),
                        )
                      : Column(
                          children: [
                            SeeAllWidget(
                              title: 'explore_campaigns'.tr,
                              onTap: () {
                                AppRoutes.routeTo(context, const ExplorePage());
                              },
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: productProvider.products.length <= 2
                                  ? productProvider.products.length
                                  : 2,
                              itemBuilder: (context, index) {
                                print(productProvider.products.length);
                                return ProductWidget(
                                  productDetails:
                                      productProvider.products[index],
                                  isDone: productProvider
                                          .products[index].salesPercentage ==
                                      "100",
                                );
                              },
                            ),
                          ],
                        );
                }),
                16.sSize,
                if (!isGuest)
                  Consumer<PrizesProvider>(
                      builder: (context, prizesProvider, _) {
                    return prizesProvider.soldOutLoader
                        ? const Center(
                            child: SoldOutShimmer(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              MainText(
                                'sold_out'.tr,
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    prizesProvider.soldOutPrizes.length < 5
                                        ? prizesProvider.soldOutPrizes.length
                                        : 5,
                                itemBuilder: (context, index) {
                                  return PrizeWidget(
                                      prize:
                                          prizesProvider.soldOutPrizes[index]);
                                },
                              ),
                            ],
                          );
                  }),
                16.sSize,
                if (!isGuest)
                  Consumer<PrizesProvider>(
                      builder: (context, prizesProvider, _) {
                    return prizesProvider.winnersLoader
                        ? const Center(
                            child: WinnerShimmer(),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SeeAllWidget(
                                title: 'the_winners'.tr,
                                onTap: () {
                                  AppRoutes.routeTo(
                                      context, const WinnersPage());
                                },
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: prizesProvider.winners.length < 5
                                    ? prizesProvider.winners.length
                                    : 5,
                                itemBuilder: (context, index) {
                                  return WinnerCard(
                                      winner: prizesProvider
                                          .winners[index].winner!);
                                },
                              ),
                            ],
                          );
                  }),
              ],
            ),
          );
        }
      }),
    );
  }
}
