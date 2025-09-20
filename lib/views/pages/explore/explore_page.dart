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

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, this.fromSearch = false});

  final bool fromSearch;
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).getProducts(context);
      _searchController.text = Provider.of<ProductProvider>(context, listen: false).searchText;
      if(!widget.fromSearch){
        _searchController.clear();
        Provider.of<ProductProvider>(context, listen: false).clearSearch();
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return MainPage(
    
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              'explore_campaigns'.tr,
              fontSize: 26,
              color: Colors.black,
            ),
            16.sSize,
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
                      print(productProvider.searchText);
                      print(productProvider.searchText.isEmpty);
                    },
                    icon: const Icon(Icons.close),
                  ) : null,
                  hint: 'search_items'.tr,
                  onChanged: (value){
                    productProvider.searchForProducts(value);
                  },
                );
              }
            ),
            8.sSize,
            Consumer<ProductProvider>(builder: (context, productProvider, _) {
              if (productProvider.productLoader) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return productProvider.searchText.trim().isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productProvider.searchProducts.length,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            productDetails: productProvider.searchProducts[index],
                          );
                        },
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productProvider.products.length,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            productDetails: productProvider.products[index],
                          );
                        },
                      );
              }
            }),
            8.sSize,
          ],
        ),
      ),
    );
  }
}
