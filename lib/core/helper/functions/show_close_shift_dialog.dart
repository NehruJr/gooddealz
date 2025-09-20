// import 'package:flutter/material.dart';
// import 'package:reno_app/core/core_exports.dart';
// import 'package:reno_app/core/ys_localizations/ys_localizations.dart';

// showCloseShiftDialog(BuildContext context) {
//   TextEditingController amountController = TextEditingController();

//   TextEditingController noteController = TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   Future.delayed(Duration.zero, () async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'close_shift_question'.tr,
//             // style: AppThemes.heading_3(textColor: AppColors.yRedColor),
//           ),
//           content: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomTextField(
//                   controller: amountController,
//                   hintText: 'amount'.tr,
//                   validator: (value) {
//                     if (!value!.isDouble) {
//                       return '';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 CustomMultiLinesTextField(
//                   controller: noteController,
//                   hintText: 'notes'.tr,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             Row(
//               children: [
//                 Expanded(
//                   child: BlocBuilder<CloseShiftBloc, CloseShiftState>(
//                     builder: (context, state) {
//                       if (state is CloseShiftSuccessState) {
//                         Future.delayed(Duration.zero, () async {
//                           Navigator.pop(context);
//                           Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const SalesBillPage()));
//                         });
//                       }
//                       return SmallButton(
//                         text: 'close'.tr,
//                         backgroundColor: AppColors.primaryRedColor,
//                         onPressed: () async {
//                           if (formKey.currentState!.validate()) {
//                             BlocProvider.of<CloseShiftBloc>(context)
//                                 .add(CloseShiftXEvent(
//                               shiftId: context.read<ShiftProvider>().shiftId!,
//                               amount:
//                                   double.parse(amountController.text.trim()),
//                               note: noteController.text,
//                             ));
//                           }
//                         },
//                       );
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: SmallButton(
//                     text: 'cancel'.tr,
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   });
// }
