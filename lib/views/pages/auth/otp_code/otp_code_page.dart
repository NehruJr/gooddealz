import 'package:flutter/material.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/helper/extensions/context_size.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/providers/auth/auth_provider.dart';
import 'package:goodealz/views/widgets/main_button.dart';
import 'package:goodealz/views/widgets/main_page.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:pinput/pinput.dart';

import '../../../widgets/loading_manager.dart';
import '../../../widgets/timer_widget.dart';

class OTPCodePage extends StatefulWidget {
  const OTPCodePage({super.key, required this.phone, this.isFromReset = false});

  final String phone;
  final bool isFromReset;

  @override
  State<OTPCodePage> createState() => _OTPCodePageState();
}

class _OTPCodePageState extends State<OTPCodePage> {
  final formKey = GlobalKey<FormState>();

  String? verificationCode;

  bool isTimer = true;

  @override
  Widget build(BuildContext context) {
    return Selector<AuthProvider, bool>(
        selector: (context, authProvider) => authProvider.resendCodeLoader,
        builder: (context, resendCodeLoader, _) {
          return LoadingManager(
            isLoading: resendCodeLoader,
            child: MainPage(
              noDrawer: true,
              body: Container(
                height: context.height,
                width: context.width,
                // decoration: BoxDecoration(
                //   gradient: LinearGradient(
                //     begin: Alignment.topCenter,
                //     end: Alignment.bottomCenter,
                //     colors: [
                //       Colors.white.withOpacity(0.1),
                //       Colors.white,
                //       Colors.white,
                //     ],
                //   ),
                // ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: 16.aEdge,
                        child: Column(
                          children: [
                            16.sSize,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      child: MainText(
                                        'otp_code'.tr,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        maxLines: 2,
                                      ),
                                    ),
                                    32.sSize,
                                    SizedBox(
                                      width: context.width - 150,
                                      child: MainText(
                                        'otp_sent'.tr + widget.phone,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.5),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            32.sSize,
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Pinput(
                                    length: 6,
                                    defaultPinTheme: PinTheme(
                                      margin: 4.aEdge,
                                      width: (context.width / 4) - 32,
                                      height: (context.width / 4) - 32,
                                      textStyle: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.yPrimaryColor
                                            .withOpacity(0.6),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: AppColors.yPrimaryColor),
                                        borderRadius: 12.cBorder,
                                      ),
                                    ),
                                    onCompleted: (pin) {
                                      verificationCode = pin;
                                      if (widget.isFromReset) {
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .checkRestPassCode(context,
                                                phone: widget.phone,
                                                code: verificationCode!);
                                      } else {
                                        Provider.of<AuthProvider>(context,
                                                listen: false)
                                            .checkVerificationCode(context,
                                                code: verificationCode!);
                                      }
                                      print(pin);
                                    },
                                  ),
                                  16.sSize,
                                  // if(!widget.isFromReset)
                                  isTimer ? TimerWidget(onEnd: (){
                                    isTimer = false;
                                    setState(() {});
                                  },) :
                                  Consumer<AuthProvider>(
                                      builder: (context, authProvider, _) {
                                    return TextButton(
                                      onPressed: () async{
                                        if (widget.isFromReset) {
                                          await authProvider.resendForgetPassword(context, phone: widget.phone);
                                        }
                                        else{
                                          await authProvider
                                              .resendVerificationCode(context);
                                        }
                                        isTimer = true;
                                        setState(() {});
                                      },
                                      child: MainText(
                                        'resend'.tr,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    );
                                  })
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<AuthProvider>(builder: (context, authProvider, _) {
                      return MainButton(
                        width: 170,
                        radius: 28,
                        color: authProvider.verificationCodeLoader
                            ? AppColors.ySecondryColor
                            : AppColors.yPrimaryColor,
                        onPressed: () async {
                          // AppRoutes.routeTo(context, const ResetPasswordPage());
                          if (!formKey.currentState!.validate() &&
                              verificationCode == null) {
                            return;
                          }
                          if (widget.isFromReset) {
                            authProvider.checkRestPassCode(context,
                                phone: widget.phone, code: verificationCode!);
                          } else {
                            authProvider.checkVerificationCode(context,
                                code: verificationCode!);
                          }
                        },
                        child: MainText(
                          authProvider.verificationCodeLoader
                              ? 'wait'.tr
                              : 'next'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      );
                    }),
                    32.sSize
                  ],
                ),
              ),
            ),
          );
        });
  }
}
