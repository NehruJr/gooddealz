// import 'dart:developer';
//
// import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
//
// class PusherConfig{
//   static const appId = "1756527";
//   static const key = "f4ac6a04ca971c13ce9c";
//   static const secretKey = "d92a5713439dcd487289";
//   static const cluster = "mt1";
//   static const port = "443";
//
//   // static const appId = "1697078";
//   // static const key = "e827d8f689b9646cde63";
//   // static const secretKey = "6d62397a18d0d72446d7";
//   // static const cluster = "eu";
//
//   PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();
//
//   initialize() async{
//     try {
//       await pusher.init(
//         apiKey: PusherConfig.key,
//         cluster: PusherConfig.cluster,
//         onConnectionStateChange: onConnectionStateChange,
//         onError: onError,
//         onSubscriptionSucceeded: onSubscriptionSucceeded,
//         onEvent: onEvent,
//         onDecryptionFailure: onDecryptionFailure,
//         // authEndpoint: "<Your Authendpoint>",
//         // onAuthorizer: onAuthorizer
//       );
//       final myChannel = await pusher.subscribe(
//           channelName: "chatadmin1",
//           onEvent: ((onEvent)=>print(onEvent.runtimeType))
//       );
//       await pusher.connect();
//       print(';;;;;;;;;;;;;;;;;;;;;;');
//       PusherEvent event = PusherEvent(channelName: 'chatuser16', eventName: 'llll', data: 'tttf');
//       print(pusher.channels.keys);
//       // pusher.trigger(event);
//     } catch (e) {
//       print("ERROR: $e");
//     }
//   }
//
//   void onConnectionStateChange(dynamic currentState, dynamic previousState) {
//     log("Connection: $currentState");
//   }
//
//   void onError(dynamic message, int? code, dynamic e) {
//     print('llllllllllllllllllllllllllllllllllllllllllll');
//     log("onError: $message code: $code exception: $e");
//   }
//
//   void onEvent(PusherEvent event) {
//     log("onEvent: $event");
//   }
//
//   void onSubscriptionSucceeded(String channelName, dynamic data) {
//     log("onSubscriptionSucceeded: $channelName data: $data");
//     final me = pusher.getChannel(channelName)?.me;
//     log("Me: $me");
//   }
//
//   void onSubscriptionError(String message, dynamic e) {
//     log("onSubscriptionError: $message Exception: $e");
//   }
//
//   void onDecryptionFailure(String event, String reason) {
//     log("onDecryptionFailure: $event reason: $reason");
//   }
//
//   void onMemberAdded(String channelName, PusherMember member) {
//     log("onMemberAdded: $channelName user: $member");
//   }
//
//   void onMemberRemoved(String channelName, PusherMember member) {
//     log("onMemberRemoved: $channelName user: $member");
//   }
//
//   void onSubscriptionCount(String channelName, int subscriptionCount) {
//     log("onSubscriptionCount: $channelName subscriptionCount: $subscriptionCount");
//   }
//
//
// }