import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final double height;
  final String text;
  final void Function()? onClick;

  const CustomButton({
    super.key,
    required this.height,
    required this.text,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
            ),
          ),
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            ),
          ),
        ),
      ),
    );
  }
}