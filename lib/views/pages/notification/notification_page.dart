import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/string_to_from.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/notification/notification_model.dart';
import 'package:goodealz/views/pages/my_orders/my_orders_page.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/helper/functions/date_converter.dart';
import '../../../providers/notification/notification_provider.dart';
import '../../widgets/no_data_widget.dart';
import '../selling_fast_details/selling_fast_details.dart';
import '../tickets/chat_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NotificationProvider>(context, listen: false)
          .getNotifications(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'notifications'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Consumer<NotificationProvider>(
                  builder: (context, notificationProvider, _) {
                  return GestureDetector(
                    onTap: (){
                      notificationProvider.clearNotification();
                    },
                    child: MainText(
                      notificationProvider.clearLoader ? 'wait'.tr : 'clear_all'.tr,
                      color: notificationProvider.clearLoader ? AppColors.ySecondry2Color : AppColors.yGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
              ),
            ),
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, _) {
                // ignore: prefer_const_constructors
                if (notificationProvider.notificationLoader) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  return notificationProvider.notifications.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notificationProvider.notifications.length,
                  itemBuilder: (context, i) {
                    return NotificationCard(notification: notificationProvider.notifications[i],
                    isRead: notificationProvider.notifications[i].readAt != null,
                    onTap: (){
                      notificationProvider.markAsRead(notificationProvider.notifications[i].id!, i);
                      if(notificationProvider.notifications[i].modal == 'order'){
                      AppRoutes.routeTo(context, const MyOrdersPage());
                      }
                      else if(notificationProvider.notifications[i].modal == 'ticket'){
                        print('-------------------------');
AppRoutes.routeTo(context, ChatScreen(ticketId: notificationProvider.notifications[i].ticketId.toIntNum, fromNotification: true,));
                      }
                      else if(notificationProvider.notifications[i].modal == 'winner'){
AppRoutes.routeTo(context, SellingFastDetailsPage(prizeSlug: notificationProvider.notifications[i].prizeSlug??'',));
                      }
                    },
                    );
                  },
                ) : const NoDataWidget();
                }
              }
            )
          ],
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  NotificationCard({
    super.key,
    required this.notification,
    required this.isRead,
    required this.onTap,
  });
  final Notifications notification;
  bool isRead;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> onTap(),
      child: Card(
        surfaceTintColor: isRead ? Colors.blue : Colors.white,
        elevation: 2,
        child: Padding(
          padding: 16.aEdge,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainText(
                      '${notification.message}',
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    8.sSize,
                    MainText(
                      DateConverter.convertOnlyTodayTime(notification.createdAt!),
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              Image.asset(getPngAsset('notification_icon'), width: 30,),
            ],
          ),
        ),
      ),
    );
  }
}
