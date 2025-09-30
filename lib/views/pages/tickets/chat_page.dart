import 'dart:async';
import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/constants/app_routes.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/tickets/tickets_provider.dart';
import 'package:goodealz/views/pages/home/home_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';

import '../../../core/ys_localizations/ys_localizations_provider.dart';
import '../../../data/models/teckets/ticket_model.dart';
import 'widgets/message_bubble.dart';
import 'widgets/paginated_listview.dart';

class ChatScreen extends StatefulWidget {

  final Ticket? ticket;
  final int ticketId;
  final bool fromNotification;
  const ChatScreen({Key? key, this.ticket, this.fromNotification = false, required this.ticketId}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputMessageController = TextEditingController();
  StreamSubscription? _stream;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketsProvider>(context, listen: false)
          .getTicketReplies(context, ticketId: widget.ticketId);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stream?.cancel();
  }

  @override
  Widget build(BuildContext context) {

      return WillPopScope(
        onWillPop: () async{
          if(widget.fromNotification) {
            // Get.offAllNamed(RouteHelper.getInitialRoute());
            AppRoutes.routeRemoveAllTo(context, const HomePage());
            return true;
          } else {
            Navigator.pop(context);
            return true;
          }
        },
        child: Scaffold(
          appBar: ( AppBar(
            leading: IconButton(
              onPressed: () {
                if(widget.fromNotification) {
                  // Get.offAllNamed(RouteHelper.getInitialRoute());
                  AppRoutes.routeRemoveAllTo(context, const HomePage());
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white,),
            ),
            title: MainText(widget.ticket?.title??'', color: Colors.white,),
            backgroundColor: AppColors.yPrimaryColor,

          )) as PreferredSizeWidget?,

          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(children: [

                  Expanded(
                    child: Consumer<TicketsProvider>(
                      builder: (context, ticketsProvider, _) {
                        return ticketsProvider.getReplyLoader ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
                            controller: _scrollController,
                            reverse: true,
                            child: PaginatedListView(
                              scrollController: _scrollController,
                              reverse: true,
                              totalSize: ticketsProvider.replies.length,
                              offset: 1,
                              onPaginate: (int? offset) {},
                              itemView: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                // reverse: true,
                                itemCount: ticketsProvider.replies.length,
                                itemBuilder: (context, index) {
                                  return MessageBubble(
                                    reply:ticketsProvider.replies[index],
                                    );
                                },
                              ),
                            ),
                          );
                      }
                    ),
                  )
                  ,

                      Row(children: [

                        SizedBox(
                          height: 25,
                          child: VerticalDivider(width: 0, thickness: 1, color: Theme.of(context).hintColor),
                        ),
                        8.sSize,

                        Expanded(
                          child: MainTextField(
                            controller: _inputMessageController,
                            keyboardType: TextInputType.multiline,
                            // maxLines: 3,
                            hint: 'type_here'.tr,

                            // onSubmitted: (String newText) {
                            //   if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                            //     Get.find<ChatController>().toggleSendButtonActivity();
                            //   }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                            //     Get.find<ChatController>().toggleSendButtonActivity();
                            //   }
                            // },
                            // onChanged: (String newText) {
                            //   if(newText.trim().isNotEmpty && !Get.find<ChatController>().isSendButtonActive) {
                            //     Get.find<ChatController>().toggleSendButtonActivity();
                            //   }else if(newText.isEmpty && Get.find<ChatController>().isSendButtonActive) {
                            //     Get.find<ChatController>().toggleSendButtonActivity();
                            //   }
                            // },
                          ),
                        ),

                       Consumer<TicketsProvider>(
                         builder: (context, ticketsProvider, _) {
                           return ticketsProvider.replyLoader ? const CircularProgressIndicator() : InkWell(
                                onTap: () async {
                                  if(_inputMessageController.text.isNotEmpty) {
                                    FocusScope.of(context).unfocus();
                                    await ticketsProvider.replyToAdmin(context,
                                      message: _inputMessageController.text,
                                      ticketId: widget.ticketId
                                    );
                                    _inputMessageController.clear();
                                  }else {
                                    showSnackbar('write_something'.tr);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Icon(Icons.send),
                                ),
                              );
                         }
                       )


                      ]),
                    ]),
                  )
                ),
              ),
            ),
          );
  }
}