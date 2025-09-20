import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';
import 'package:goodealz/views/widgets/product_widget.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../providers/product/product_provider.dart';
import '../../widgets/no_data_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _searchController = TextEditingController();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).clearSearch();
      Provider.of<ProductProvider>(context, listen: false).getFavoriteProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      isAppBar: false,
      subAppBar: Padding(
        padding: 16.hEdge,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MainText(
              'favorites'.tr,
              fontSize: 19,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            // const NotificationIcon(),
          ],
        ),
      ),
      bottomNavigationBarIndex: 3,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
                return MainTextField(
                  unfocusWhenTapOutside: true,
                  controller: _searchController,
                  prefixIcon: Padding(
                    padding: 20.aEdge,
                    child: SvgPicture.asset(
                      getSvgAsset('Search'),
                      height: 22,
                    ),
                  ),
                  suffixIcon: productProvider.searchText.isNotEmpty ? IconButton(
                            onPressed: () {
                              productProvider.clearSearch();
                              _searchController.clear();
                            },
                            icon: const Icon(Icons.close),
                          ) : null,
                      onChanged: (value){
                        productProvider.searchForFavorites(value);
                      },
                  hint: 'search_items'.tr,
                );
              }
            ),
            8.sSize,
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
              if (productProvider.favoriteLoader) {
                return const Center(
                child: CircularProgressIndicator(),
              );
              } else {
                return  productProvider.favoriteProducts.isNotEmpty ?
                productProvider.searchText.trim().isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productProvider.searchFavorites.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(isDone:  productProvider.searchFavorites[index].salesPercentage == "100",
                      productDetails: productProvider.searchFavorites[index],
                    
                    );
                  },
                ) : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productProvider.favoriteProducts.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(
                      isDone: productProvider.favoriteProducts[index].salesPercentage == "100",
                      productDetails: productProvider.favoriteProducts[index],
                    );
                  },
                ) : const NoDataWidget();
              }
              }
            ),
            8.sSize,
          ],
        ),
      ),
    );
  }
}
