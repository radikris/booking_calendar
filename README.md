<p align="center">
	<img src="https://raw.githubusercontent.com/radikris/booking_calendar/main/example/assets/booking_calendar_logo.png" height="80" alt="Booking Calendar Logo" />
</p>
<p align="center">
	<a href="https://pub.dev/packages/booking_calendar"><img src="https://img.shields.io/pub/v/focus_detector.svg" alt="Pub.dev Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
	<a href="https://github.com/radikris/booking_calendar"><img src="https://img.shields.io/badge/platform-flutter-ff69b4.svg" alt="Flutter Platform Badge"></a>
</p>

# Booking Calendar

Want to make online bookings in your app? Then luckily you need look no further!

With a total of 4 lines, you get a working online booking system where users can track bookings in real-time.

It calculates the cases where there would be a conflict in the calendar and displays them in different colors.

You can customise your booking calendar with a number of additional parameters.

## Usage

Check the Demo Example for more Information

```dart
 Widget build(BuildContext context) {
    return BookingCalendar(
        key: key,
        ///These are the required parameters
        getBookingStream: getBookingStream,
        uploadBooking: uploadBooking,
        convertStreamResultToDateTimeRanges: convertStreamResultToDateTimeRanges,
        ///These are only customizable, optional parameters
        bookingButtonColor: bookingButtonColor,
        bookingButtonText: bookingButtonText,
        bookingExplanation: bookingExplanation,
        bookingGridChildAspectRatio: bookingGridChildAspectRatio,
        bookingGridCrossAxisCount: bookingGridCrossAxisCount,
        formatDateTime: formatDateTime,
        availableSlotColor: availableSlotColor,
        availableSlotText: availableSlotText,
        bookedSlotColor: bookedSlotColor,
        bookedSlotText: bookedSlotText,
        selectedSlotColor: selectedSlotColor,
        selectedSlotText: selectedSlotText,
        gridScrollPhysics: gridScrollPhysics,
        loadingWidget: loadingWidget,
        errorWidget: errorWidget,
    );
  }
```

## Additional information

Feel free to add issues and leave comments on the github repository.
