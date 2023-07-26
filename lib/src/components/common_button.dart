import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isActive = true,
    this.isDisabled = false,
    this.buttonStyle,
    this.width,
    this.buttonActiveColor,
    this.buttonInActiveColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;
  final bool? isActive;
  final bool? isDisabled;
  final ButtonStyle? buttonStyle;
  final double? width;
  final Color? buttonActiveColor;
  final Color? buttonInActiveColor;

  Color _getButtonColor(BuildContext context) {
    if (isActive == true && isDisabled == false) {
      return buttonActiveColor ?? Theme.of(context).primaryColor;
    } else if (isActive == false && isDisabled == false) {
      return Theme.of(context).cardColor;
    } else {
      return buttonInActiveColor ?? Theme.of(context).disabledColor;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (isActive == true && isDisabled == false) {
      return Theme.of(context).colorScheme.onPrimary;
    } else if (isActive == false && isDisabled == false) {
      return buttonActiveColor ?? Colors.teal;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: (isDisabled == null || isDisabled == false) ? onPressed : null,
      style: buttonStyle ??
          ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(context),
            foregroundColor: _getTextColor(context),
            minimumSize: Size(width ?? double.infinity, 48),
            // shape: const RoundedRectangleBorder(
            //   borderRadius: BorderRadius.all(Radius.circular(24)),
            // ),
            side: (isActive == false && isDisabled == false)
                ? const BorderSide(color: Colors.teal, width: 2)
                : null,
          ),
      child: Text(
        text,
        style: themeData.labelLarge!.copyWith(color: _getTextColor(context)),
      ),
    );
  }
}
