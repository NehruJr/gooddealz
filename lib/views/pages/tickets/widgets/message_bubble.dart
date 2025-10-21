import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/data/models/teckets/ticketReply_model.dart';
import 'package:goodealz/views/widgets/main_text.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/helper/functions/date_converter.dart';

class MessageBubble extends StatelessWidget {
  final Reply reply;
  const MessageBubble({Key? key, required this.reply,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isReply = reply.userType != 'Client';

    return (isReply) ? Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      padding: 16.vhEdge,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [

          const SizedBox(width: 10),

          Flexible(
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [

              if(reply.message != null) Flexible(
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.yGreyColor,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  padding: EdgeInsets.all(reply.message != null ? 16 : 0),
                  child: MainText(reply.message ?? '', color: Colors.white,),
                ),
              ),
            ]),
          ),
        ]),
        8.sSize,

        Text(
          DateConverter.convertTodayYesterdayFormat(reply.createdAt!),
         ),
      ]),
    ) : Container(
      padding: const EdgeInsets.symmetric(horizontal:8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [


          Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [

            Flexible(
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [

                (reply.message != null && reply.message!.isNotEmpty) ? Flexible(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.yPrimaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(reply.message != null ? 8 : 0),
                      child: MainText(reply.message ?? '', color: Colors.white,),
                    ),
                  ),
                ) : const SizedBox(),

              ]),
            ),
            8.sSize

          ]),

          Icon(
           Icons.check,
            size: 12,
            color: Theme.of(context).disabledColor,
          ),
          8.sSize,

          Text(
            DateConverter.convertTodayYesterdayFormat(reply.createdAt!),
            style: const TextStyle(fontSize: 10),
          ),
          16.sSize

        ])

    );
  }
}