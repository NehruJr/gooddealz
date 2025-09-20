import 'package:flutter/material.dart';

class GlobalMethods {

  static  navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static void navigate(BuildContext context, Widget widget, {Function? then}){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return widget;
        })).then((value) => then != null ? then() : null);
  }

  static void navigateReplace(BuildContext context, Widget widget){
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) {
          return widget;
        }));
  }

  static void navigateReplaceALL(BuildContext context, Widget widget){
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) {
          return widget;
        }),
            (route)=> false
    );
  }

  static void showMessageDialog({required String title, required String subTitle, required BuildContext context, required Function function, }){
    showDialog(context: context, builder: (ctx)=> AlertDialog(
      title: Text(title),
      content: Text(subTitle),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.cyan, fontSize: 18)),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Ok',  style: TextStyle(color: Colors.red, fontSize: 18), ),
          onPressed: (){ function();
          Navigator.of(context).pop();
          },
        ),
      ],
    ));
  }

  static Future<void> errorDialog({

    String title = 'An Error occurred',
    required String subtitle,

    required BuildContext context,
  }) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                'assets/images/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(title),
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(color: Colors.cyan, fontSize: 18),
                ),
              ),

            ],
          );
        });
  }


  static String timeAgoSinceDate(String dateTime, {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateTime).toLocal();
    final date2 = DateTime.now().toLocal();
    final difference = date2.difference(date);

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inSeconds <= 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes <= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inMinutes <= 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours <= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inHours <= 60) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays <= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inDays <= 6) {
      return '${difference.inDays} days ago';
    } else if ((difference.inDays / 7).ceil() <= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if ((difference.inDays / 7).ceil() <= 4) {
      return '${(difference.inDays / 7).ceil()} weeks ago';
    } else if ((difference.inDays / 30).ceil() <= 1) {
      return (numericDates) ? '1 month ago' : 'Last month';
    } else if ((difference.inDays / 30).ceil() <= 30) {
      return '${(difference.inDays / 30).ceil()} months ago';
    } else if ((difference.inDays / 365).ceil() <= 1) {
      return (numericDates) ? '1 year ago' : 'Last year';
    }
    return '${(difference.inDays / 365).floor()} years ago';
  }
}
