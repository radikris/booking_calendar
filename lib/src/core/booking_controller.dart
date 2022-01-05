import 'package:booking_calendar/src/model/booking_service.dart';
import 'package:booking_calendar/src/util/booking_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookingController extends ChangeNotifier {
  BookingService bookingService;
  BookingController({required this.bookingService, this.serviceOpening, this.serviceClosing}) {
    if (serviceOpening != null && serviceClosing != null && serviceOpening!.isAfter(serviceClosing!)) {
      throw "Service closing must be after opening";
    }
    base = serviceOpening ?? DateTime.now().startOfDay;
    _generateBookingSlots();
  }

  DateTime? serviceOpening;
  DateTime? serviceClosing;

  List<DateTime> _allBookingSlots = [];
  List<DateTime> get allBookingSlots => _allBookingSlots;

  List<DateTimeRange> bookedSlots = [];

  int _selectedSlot = (-1);
  bool _isLoading = true;

  int get selectedSlot => _selectedSlot;
  bool get isLoading => _isLoading;

  late DateTime base;

  void _generateBookingSlots() {
    allBookingSlots.clear();
    _allBookingSlots = List.generate(
        _maxServiceFitInADay(), (index) => base.add(Duration(minutes: bookingService.serviceDuration) * index));
  }

  int _maxServiceFitInADay() {
    ///if no serviceOpening and closing was provided we will calculate with 00:00-24:00
    int openingHours = 24;
    if (serviceOpening != null && serviceClosing != null) {
      openingHours = DateTimeRange(start: serviceOpening!, end: serviceClosing!).duration.inHours;
    }

    ///round down if not the whole service would fit in the last hours
    return ((openingHours * 60) / bookingService.serviceDuration).floor();
  }

  bool isSlotBooked(int index) {
    DateTime checkSlot = allBookingSlots.elementAt(index);
    bool result = false;
    for (var slot in bookedSlots) {
      if (BookingUtil.isOverLapping(
          slot.start, slot.end, checkSlot, checkSlot.add(Duration(minutes: bookingService.serviceDuration)))) {
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

  // Future<void> uploadBooking() async {
  //   isLoading.value = true;
  //   final autoEmailController = Get.find<AutoEmailController>();
  //   final bookingDetail = generateSportBooking();
  //   await autoEmailController.sendMail(bookingDetail, allBookingSlots.elementAt(selectedSlot.value));
  //   await ApiRepostiory.to.uploadBooking(bookingDetail);
  //   selectedSlot.value = -1;
  //   isLoading.value = false;
  // }

  // Future<void> fetchBooking(QuerySnapshot<SportBooking> data) async {
  //   bookedSlots.clear();
  //   generateBookingSlots();

  //   //final result = await ApiRepostiory.to.fetchBookings(placeId: place.placeId ?? '');
  //   for (var i = 0; i < data.size; i++) {
  //     final item = data.docs[i].data();
  //     bookedSlots.add(BookingPair(start: (item.bookingStart!), end: (item.bookingEnd!)));
  //   }
  // }

  void generateSportBooking() {
    final bookingDate = allBookingSlots.elementAt(selectedSlot);
    bookingService
      ..bookingStart = (bookingDate)
      ..bookingEnd = (bookingDate.add(Duration(minutes: bookingService.serviceDuration)));
  }
}
