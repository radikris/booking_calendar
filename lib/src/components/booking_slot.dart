import 'package:booking_calendar/src/components/common_card.dart';
import 'package:booking_calendar/src/util/custom_colors.dart';
import 'package:flutter/material.dart';

class BookingSlot extends StatelessWidget {
  const BookingSlot({
    Key? key,
    required this.child,
    required this.isBooked,
    required this.onTap,
    required this.isSelected,
    required this.isPauseTime,
    this.bookedSlotColor,
    this.selectedSlotColor,
    this.availableSlotColor,
    this.pauseSlotColor,
    this.hideBreakSlot,
  }) : super(key: key);

  final Widget child;
  final bool isBooked;
  final bool isPauseTime;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;
  final bool? hideBreakSlot;

  Color getSlotColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (isPauseTime) {
      return pauseSlotColor ?? Colors.grey;
    }

    if (isBooked) {
      return bookedSlotColor ?? getBookedColor(isDarkMode);
    } else {
      return isSelected
          ? selectedSlotColor ?? Theme.of(context).primaryColor
          : availableSlotColor ?? getAvailableSlotColor(isDarkMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return (hideBreakSlot != null && hideBreakSlot == true && isPauseTime)
        ? const SizedBox()
        : GestureDetector(
            onTap: (!isBooked && !isPauseTime) ? onTap : null,
            child: CommonCard(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                color: getSlotColor(context),
                child: child),
          );
  }
}
