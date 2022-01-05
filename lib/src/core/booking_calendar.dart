import 'package:booking_calendar/src/components/booking_calendar_main.dart';
import 'package:booking_calendar/src/core/booking_controller.dart';
import 'package:booking_calendar/src/model/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingCalendar extends StatelessWidget {
  const BookingCalendar({Key? key, required this.bookingService}) : super(key: key);

  final BookingService bookingService;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingController(bookingService: bookingService),
      child: const BookingCalendarMain(),
    );
  }
}
