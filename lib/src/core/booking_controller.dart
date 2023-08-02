import 'package:booking_calendar/src/model/booking_service.dart';
import 'package:booking_calendar/src/util/booking_util.dart';
import 'package:flutter/material.dart';

class BookingController extends ChangeNotifier {
  BookingController(
      {required this.serviceOpening,
      required this.serviceClosing,
      required BookingService bookingService,
      this.pauseSlots})
      : _bookingService = bookingService {
    // serviceOpening = bookingService.bookingStart;
    // serviceClosing = bookingService.bookingEnd;
    pauseSlots = pauseSlots;
    if (serviceOpening.isAfter(serviceClosing)) {
      throw "Service closing must be after opening";
    }
    base = serviceOpening;
    _generateBookingSlots();
  }

  ///for the Calendar picker we use: [TableCalendar]
  ///credit: https://pub.dev/packages/table_calendar

  ///initial [BookingService] which contains the details of the service,
  ///and this service will get additional two parameters:
  ///the [BookingService.bookingStart] and [BookingService.bookingEnd] date of the booking
  BookingService _bookingService;
  late DateTime base;

  DateTime serviceOpening;
  DateTime serviceClosing;

  List<DateTime> _allBookingSlots = [];
  List<DateTime> get allBookingSlots => _allBookingSlots;

  List<DateTimeRange> bookedSlots = [];

  ///The pause time, where the slots won't be available
  List<DateTimeRange>? pauseSlots = [];

  int _selectedSlot = (-1);
  // bool _isUploading = false;

  int get selectedSlot => _selectedSlot;
  // bool get isUploading => _isUploading;

  bool _successfullUploaded = false;
  bool get isSuccessfullUploaded => _successfullUploaded;

  BookingService get value => _bookingService;

  void initBack() {
    // _isUploading = false;
    _successfullUploaded = false;
  }

  void selectFirstDayByHoliday(DateTime first, DateTime firstEnd) {
    serviceOpening = first;
    serviceClosing = firstEnd;
    base = first;
    _generateBookingSlots();
  }

  void _generateBookingSlots() {
    allBookingSlots.clear();
    _allBookingSlots = List.generate(
        _maxServiceFitInADay(),
        (index) => base
            .add(Duration(minutes: _bookingService.serviceDuration) * index));
  }

  bool isWholeDayBooked() {
    bool isBooked = true;
    for (var i = 0; i < allBookingSlots.length; i++) {
      if (!isSlotBooked(i)) {
        isBooked = false;
        break;
      }
    }
    return isBooked;
  }

  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate with 00:00-24:00
    int openingHours = 24;

    openingHours = DateTimeRange(start: serviceOpening, end: serviceClosing)
        .duration
        .inHours;

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / _bookingService.serviceDuration).floor();
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots) {
      if (BookingUtil.isOverLapping(slot.start, slot.end, checkSlot,
          checkSlot.add(Duration(minutes: _bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }
    return result;
  }

  void selectSlot(int idx) {
    _selectedSlot = idx;
    notifyListeners();
  }

  void resetSelectedSlot() {
    _selectedSlot = -1;
    notifyListeners();
  }

  // void toggleUploading() {
  //   // _isUploading = !_isUploading;
  //   notifyListeners();
  // }

  Future<void> generateBookedSlots(List<DateTimeRange> data) async {
    bookedSlots.clear();
    _generateBookingSlots();

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bookedSlots.add(item);
    }
  }

  BookingService generateNewBookingForUploading() {
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    _bookingService
      ..bookingStart = (bookingDate)
      ..bookingEnd =
          (bookingDate.add(Duration(minutes: _bookingService.serviceDuration)));
    _bookingService = _bookingService;
    return _bookingService;
  }

  bool isSlotInPauseTime(DateTime slot) {
    bool result = false;
    if (pauseSlots == null) {
      return result;
    }
    for (var pauseSlot in pauseSlots!) {
      if (BookingUtil.isOverLapping(pauseSlot.start, pauseSlot.end, slot,
          slot.add(Duration(minutes: _bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }
    return result;
  }
}
