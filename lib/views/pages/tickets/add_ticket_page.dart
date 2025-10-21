import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/data/models/teckets/purchase_code_model.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:goodealz/views/widgets/main_textfield.dart';

import '../../../providers/tickets/tickets_provider.dart';
import 'widgets/purchasecode_dropdwon.dart';

class AddTicketPage extends StatefulWidget {
  const AddTicketPage({super.key});

  @override
  State<AddTicketPage> createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  PurchaseCode? purchaseCode;


  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TicketsProvider>(context, listen: false)
          .getPurchaseCode(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainPage(
      body: Container(
        height: context.height,
        width: context.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: 16.aEdge,
          child: Column(
            children: [

              Form(
                key: formKey,
                child: Column(
                  children: [
                    MainTextField(
                      hint: 'title'.tr,
                      unfocusWhenTapOutside: true,
                      borderColor: AppColors.yGreyColor,
                      controller: _titleController,
                      prefixIcon: const Icon(Icons.title, color: AppColors.yDarkColor,),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return 'enter_title'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    12.sSize,
                    MainMultiLinesTextField(
                      hint: '\n${'description'.tr}',
                      unfocusWhenTapOutside: true,
                      borderColor: AppColors.yGreyColor,
                      maxLines: 3,
                      controller: _descriptionController,
                      prefixIcon: const Icon(Icons.title, color: AppColors.yDarkColor,),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return 'enter_description'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    12.sSize,
                    Consumer<TicketsProvider>(
                      builder: (context, ticketProvider, _) {
                        return PurchaseCodeDropDown(
                          enabled: !ticketProvider.codeLoader,
                          filledColor: ticketProvider.codeLoader ? Colors.grey[200] : null,
                          hint: 'purchase_code'.tr,
                          borderColor: AppColors.yGreyColor,
                          list: ticketProvider.purchaseCodes,
                          item: purchaseCode,
                          unfocusWhenTapOutside: true,
                          prefixIcon: const Icon(Icons.code, color: AppColors.yDarkColor,),
                          onChange: (value){
                            purchaseCode = value;
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'select_purchase_code'.tr;
                            } else {
                              return null;
                            }
                          },
                        );
                      }
                    ),
                    32.sSize,
                    Consumer<TicketsProvider>(
                        builder: (context, ticketProvider, _) {
                          return MainButton(
                            width: 170,
                            radius: 28,
                            color: ticketProvider.addTicketLoader ? AppColors.ySecondryColor : AppColors.yPrimaryColor,
                            onPressed: ticketProvider.addTicketLoader ? (){} : () async {
                              if (formKey.currentState!.validate()) {
                                ticketProvider.addTicket(context, title: _titleController.text, description: _descriptionController.text, purchaseCodeId: purchaseCode!.id!);

                              }
                            },
                            child: MainText(
                              ticketProvider.addTicketLoader ? 'wait'.tr : 'create_ticket_page'.tr,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
