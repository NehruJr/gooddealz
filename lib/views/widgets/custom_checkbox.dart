import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox(
      {Key? key,
        required this.value,
        required this.change,
        required this.text,
        required this.color})
      : super(key: key);

  final String text;
  final bool value;
  final void Function(bool?)? change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white,
            ),
            child: Checkbox(
              activeColor: color,
              value: value,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
              side: const BorderSide(color: Colors.black, width: 1.5),
              onChanged: change ,
              // fillColor: MaterialStateProperty.all(color),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Text(text,
            style: const TextStyle(
                color: Colors.black,
                fontFamily: 'TajawalMedium',
                fontSize: 14)),
      ],
    );
  }
}
