import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:goodealz/core/helper/functions/show_snackbar.dart';
import 'package:goodealz/data/models/teckets/ticketReply_model.dart';
import 'package:goodealz/data/models/teckets/ticket_model.dart';

import '../../core/constants/app_endpoints.dart';
import '../../data/models/teckets/purchase_code_model.dart';
import '../../data/remote/http_api.dart';

class TicketsProvider extends ChangeNotifier{

  bool codeLoader = false;
  bool ticketLoader = false;
  bool addTicketLoader = false;
  bool replyLoader = false;
  bool getReplyLoader = false;

  List<PurchaseCode> _purchaseCodes = [];
  List<PurchaseCode> get purchaseCodes => _purchaseCodes;

  List<Ticket> _tickets = [];
  List<Ticket> get tickets => _tickets;

  List<Reply> _replies = [];
  List<Reply> get replies => _replies;


  Future<void> getPurchaseCode(context) async {
    try{

      codeLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.purchaseCode,);

      if(response.statusCode == 200){
        codeLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        PurchaseCodeModel purchaseCodeModel = PurchaseCodeModel.fromJson(jsonRes);
        _purchaseCodes = purchaseCodeModel.purchaseCodes?? [];

      }else{

        codeLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      codeLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: context);
    }
  }

  Future<void> getTickets(context) async {
    try{

      ticketLoader = true;
      notifyListeners();
      final response = await CallApi.get(AppEndpoints.tickets,);
      print(response.body);

      if(response.statusCode == 200){
        ticketLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        TicketModel ticketModel = TicketModel.fromJson(jsonRes);
        _tickets = ticketModel.tickets?? [];

      }else{

        ticketLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      ticketLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

  Future<void> getTicketReplies(context, {required int ticketId}) async {
    try{

      getReplyLoader = true;
      notifyListeners();
      final response = await CallApi.post(AppEndpoints.getTicketReplies,
          data: jsonEncode({
            "ticket_id": ticketId,
          }));

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        getReplyLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
        ReplyModel replyModel = ReplyModel.fromJson(jsonRes);
        _replies = replyModel.replies?? [];

      }else{

        getReplyLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      getReplyLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

  Future<void> addTicket(context, {required String title, required String description, required int purchaseCodeId}) async {
    try{

      addTicketLoader = true;
      notifyListeners();
      final response = await CallApi.post(AppEndpoints.tickets,
      data: jsonEncode({
        "title": title,
        "description": description,
        "purchase_code_id": purchaseCodeId
      }));

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        addTicketLoader = false;
        notifyListeners();

        final jsonRes = jsonDecode(response.body);
_tickets.insert(0, Ticket.fromJson(jsonRes['data']));


        showSnackbar(jsonRes['message']);
        Navigator.pop(context);

      }else{

        addTicketLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      addTicketLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }

  Future<void> replyToAdmin(context, {required String message, required int ticketId}) async {
    try{

      replyLoader = true;
      notifyListeners();
      final response = await CallApi.post(AppEndpoints.createReply,
      data: jsonEncode({
        "message": message,
        "ticket_id": ticketId,
      }));

      print('=======response======');
      print(response.statusCode);
      log(response.body.toString());

      if(response.statusCode == 200){
        replyLoader = false;
        notifyListeners();
        final jsonRes = jsonDecode(response.body);

        final reply = Reply.fromJson(jsonRes['data']);
        replies.add(reply);
        // showSnackbar(jsonRes['message']);
        // Navigator.pop(context);

      }else{

        replyLoader = false;
        notifyListeners();
        final error = jsonDecode(response.body)['message']?? jsonDecode(response.body)['error']?? 'An error occurred';
        showSnackbar(error, error: true);
      }

    }catch(e){

      replyLoader = false;
      notifyListeners();
      showSnackbar( e.toString(), error: true);
    }
  }


}