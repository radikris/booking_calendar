import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.isActive = true,
    this.isDisabled = false,
    this.buttonStyle,
    this.width,
    this.buttonActiveColor,
    this.buttonInActiveColor,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;
  final bool? isActive;
  final bool? isDisabled;
  final TextStyle? buttonStyle;
  final Color? buttonActiveColor;
  final Color? buttonInActiveColor;
  final double? width;

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

    return InkWell(
      onTap: (isDisabled == null || isDisabled == false) ? onTap : null,
      child: Container(
        width: width ?? double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: _getButtonColor(context),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          border: (isActive == false && isDisabled == false)
              ? Border.all(color: Colors.teal, width: 2)
              : null,
        ),
        child: Text(
          text,
          style: buttonStyle ??
              themeData.labelLarge!.copyWith(color: _getTextColor(context)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
