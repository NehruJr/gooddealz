import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/get_asset.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/teckets/ticket_model.dart';
import 'package:goodealz/views/pages/tickets/add_ticket_page.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../providers/tickets/tickets_provider.dart';
import '../../widgets/no_data_widget.dart';
import 'chat_page.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => TicketsPageState();
}

class TicketsPageState extends State<TicketsPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketsProvider>(context, listen: false)
          .getTickets(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      title: 'tickets'.tr,
      body: SingleChildScrollView(
        padding: 16.aEdge,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: (){
                  AppRoutes.routeTo(context, const AddTicketPage());
                },
                child: MainText(
                  'create_ticket'.tr,
                  color: AppColors.ySecondry2Color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Consumer<TicketsProvider>(
                builder: (context, ticketsProvider, _) {
                  // ignore: prefer_const_constructors
                  return ticketsProvider.ticketLoader ? Center(child: CircularProgressIndicator(),) :
                  ticketsProvider.tickets.isNotEmpty ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ticketsProvider.tickets.length,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: (){
                          AppRoutes.routeTo(context, ChatScreen(ticket: ticketsProvider.tickets[i], ticketId: ticketsProvider.tickets[i].id!,));
                        },
                          child: TicketsCard(ticket: ticketsProvider.tickets[i]));
                    },
                  ) : const NoDataWidget();
                }
            )
          ],
        ),
      ),
    );
  }
}

class TicketsCard extends StatelessWidget {
  const TicketsCard({
    super.key,
    required this.ticket,
  });
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.yBGColor,
      shadowColor: AppColors.yBlackColor,
      elevation: 4,
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
                    '${ticket.title}',
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  8.sSize,
                  MainText(
                    ticket.description??'',
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 14,
                  ),
                ],
              ),
            ),
            Image.asset(getPngAsset('ticket-icon'), width: 30, color: AppColors.yPrimaryColor,),
          ],
        ),
      ),
    );
  }
}
