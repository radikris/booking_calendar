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
    _initializeSelectedSlot();
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

  void _initializeSelectedSlot() {
    if (_bookingService.bookingStart != null &&
        _bookingService.bookingEnd != null) {
      // Extract time only (ignoring year, month, and day) from both DateTime objects
      final bookingStartTime = DateTime(0, 0, 0).copyWith(
        hour: _bookingService.bookingStart!.hour,
        minute: _bookingService.bookingStart!.minute,
      );
      final serviceOpeningTime = DateTime(0, 0, 0).copyWith(
        hour: serviceOpening.hour,
        minute: serviceOpening.minute,
      );

      // Calculate the difference between the bookingStart and the serviceOpening
      Duration difference = bookingStartTime.difference(serviceOpeningTime);

      // Determine the slot based on the service duration
      _selectedSlot =
          (difference.inMinutes / _bookingService.serviceDuration).floor();
    }
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

  /// The function checks if a given slot is already booked by comparing
  /// it with the existing booked slots.
  ///
  /// Args:
  ///   index (int): The index parameter represents the index of the slot
  ///   in the allBookingSlots list that you want to check if it is booked
  ///   or not.
  ///
  /// Returns:
  ///   a boolean value.
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

  void select(int index) {
    _selectedSlot = index;
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    _bookingService
      ..bookingStart = (bookingDate)
      ..bookingEnd =
          (bookingDate.add(Duration(minutes: _bookingService.serviceDuration)));
    _bookingService = _bookingService;
    notifyListeners();
  }

  bool isSlotInPauseTime(DateTime slot, int index) {
    bool result = false;
    if (isSlotBooked(index)) {
      return result;
    }
    if (!result && slot.isBefore(DateTime.now())) {
      result = true;
    }
    if (pauseSlots == null) {
      return result;
    }
    for (var pauseSlot in pauseSlots!) {
      final DateTimeRange(:start, :end) = DateTimeRange(
          start: pauseSlot.start
              .copyWith(year: slot.year, month: slot.month, day: slot.day),
          end: pauseSlot.end
              .copyWith(year: slot.year, month: slot.month, day: slot.day));

      if (BookingUtil.isOverLapping(start, end, slot,
          slot.add(Duration(minutes: _bookingService.serviceDuration)))) {
        result = true;
        break;
      }
    }

    return result;
  }
}
