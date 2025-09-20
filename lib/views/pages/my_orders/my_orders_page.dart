import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/order/order_provider.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart' as s;

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../widgets/no_data_widget.dart';
import '../../widgets/orderCard_widget.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key, this.fromPayment = false});

  final bool fromPayment;

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  int currentIndex = 0;

  bool _isRefresh = false;

  final _controller = ScrollController();
  final refresh = s.RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    //
    // _controller.addListener(() {
    //   print(',,,,,,,,,,,,,,,,,,,,,,,,');
    //   print(',,,,,,,,,,,,,,,,,,,,,,,,');
    //   if(_controller.position.maxScrollExtent == _controller.offset){
    //
    //     print('555555555555555555');
    //   }
    //
    // });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<OrderProvider>(context, listen: false)
          .getOrders(context, getCurrentStatus());
    });
  }

  @override
  void dispose() {
    super.dispose();

    refresh.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'my_orders'.tr,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                });

                Provider.of<OrderProvider>(context, listen: false)
                    .getOrders(context, getCurrentStatus());
              },
              indicatorWeight: 4,
              indicatorColor: AppColors.yPrimaryColor,
              unselectedLabelColor: Colors.black54,
              tabs: [Tab(text: 'pending'.tr), Tab(text: 'completed'.tr), ],
            ),
            Flexible(
              child:
                  Consumer<OrderProvider>(builder: (context, orderProvider, _) {
                print(orderProvider.orderLoader);
                    return RefreshIndicator(
                  onRefresh: () async {
                    _isRefresh = true;
                    await orderProvider.getOrders(context, getCurrentStatus());
                    _isRefresh = false;
                  },
                  child: s.SmartRefresher(
                    controller: refresh,
                    enablePullDown: false,
                    enablePullUp: true,
                    onLoading: () async {
                      await orderProvider.getMoreOrders(context);
                      // if failed,use refreshFailed()
                      refresh.loadComplete();
                    },
                    child: orderProvider.orderLoader && !_isRefresh
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : orderProvider.orders.isNotEmpty ? ListView.builder(
                      // controller: _controller,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: orderProvider.orders.length,
                      itemBuilder: (context, index) {
                        return OrderCard(
                                order: orderProvider.orders[index],
                                index: index,
                              );
                      },
                    ) : const NoDataWidget(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String getCurrentStatus() {
    if (currentIndex == 0) {
      return 'pending payment';
    } else if (currentIndex == 1) {
      return "paid";
    } else {
      return "unpaid";
    }
  }
}
