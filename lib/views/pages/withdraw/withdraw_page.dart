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

class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});

  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<ProductProvider>(context, listen: false).getWithdrawProducts(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      bottomNavigationBarIndex: 1,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainText(
              'withdraw'.tr,
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
                        },
                        icon: const Icon(Icons.close),
                      ) : null,
                  onChanged: (value){
                    productProvider.searchForWithDraw(value);
                  },
                  hint: 'search_items'.tr,
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
                return  productProvider.withDrawProducts.isNotEmpty ? productProvider.searchText.trim().isNotEmpty
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productProvider.searchWithdraw.length,
                  itemBuilder: (context, index) {
                    return ProductWidget(isDone: true,
                      productDetails: productProvider.searchWithdraw[index],
                    );
                  },
                ) : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productProvider.withDrawProducts.length,
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            productDetails: productProvider.withDrawProducts[index],
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
