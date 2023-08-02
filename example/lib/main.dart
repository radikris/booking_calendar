import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

final themeModeProvider = StateProvider((ref) => ThemeMode.light);

void main() {
  initializeDateFormatting().then(
      (_) => runApp(const ProviderScope(child: BookingCalendarDemoApp())));
}

class BookingCalendarDemoApp extends ConsumerStatefulWidget {
  const BookingCalendarDemoApp({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookingCalendarDemoAppState();
}

class _BookingCalendarDemoAppState
    extends ConsumerState<BookingCalendarDemoApp> {
  final now = DateTime.now();
  late final BookingService mockBookingService;
  late final BookingController mockBookingController;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
      serviceName: 'Mock Service',
      serviceDuration: 30,
    );

    mockBookingController = BookingController(
        serviceOpening: DateTime(now.year, now.month, now.day, 8, 0),
        serviceClosing: DateTime(now.year, now.month, now.day, 16, 0),
        bookingService: mockBookingService,
        pauseSlots: generatePauseSlots());
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> onBookSelected(BuildContext context,
      {required BookingService newBooking}) async {
    // await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Created'),
          content: const Text('Your booking was successfully created.'),
          actions: <Widget>[
            OutlinedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
    if (newBooking.bookingStart != null && newBooking.bookingEnd != null) {
      converted.add(DateTimeRange(
          start: newBooking.bookingStart!, end: newBooking.bookingEnd!));
      print('${newBooking.toJson()} has been uploaded');
      setState(() {});
    }
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    ///take care this is only mock, so if you add today as disabledDays it will still be visible on the first load
    ///disabledDays will properly work with real data
    DateTime first = now;
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime second = now.add(const Duration(minutes: 55));
    DateTime third = now.subtract(const Duration(minutes: 240));
    DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
    converted.add(DateTimeRange(
        start: second, end: second.add(const Duration(minutes: 23))));
    converted.add(DateTimeRange(
        start: third, end: third.add(const Duration(minutes: 15))));
    converted.add(DateTimeRange(
        start: fourth, end: fourth.add(const Duration(minutes: 50))));

    //book whole day example
    converted.add(DateTimeRange(
        start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
        end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)));
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      DateTimeRange(
          start: DateTime(now.year, now.month, now.day, 12, 0),
          end: DateTime(now.year, now.month, now.day, 13, 0))
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
        title: 'Booking Calendar Demo',
        // This theme was made for FlexColorScheme version 6.1.1. Make sure
// you use same or higher version, but still same major version. If
// you use a lower version, some properties may not be supported. In
// that case you can also remove them after copying the theme to your app.
        theme: FlexThemeData.light(
          scheme: FlexScheme.blue,
          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
          blendLevel: 3,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 10,
            blendOnColors: false,
            elevatedButtonRadius: 8.0,
            elevatedButtonSchemeColor: SchemeColor.onPrimary,
            elevatedButtonSecondarySchemeColor: SchemeColor.primary,
            outlinedButtonRadius: 8.0,
            outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.blue,
          surfaceMode: FlexSurfaceMode.highScaffoldLevelSurface,
          blendLevel: 4,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 25,
            elevatedButtonRadius: 8.0,
            elevatedButtonSchemeColor: SchemeColor.onPrimary,
            elevatedButtonSecondarySchemeColor: SchemeColor.primary,
            outlinedButtonRadius: 8.0,
            outlinedButtonOutlineSchemeColor: SchemeColor.primary,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          swapLegacyOnMaterial3: true,
          // To use the Playground font, add GoogleFonts package and uncomment
          // fontFamily: GoogleFonts.notoSans().fontFamily,
        ),
        themeMode: themeMode,
        // To avoid error of MaterialLocalizations because we are going to
        // show a Dialog in the `onBookSelected` functions
        home: Builder(builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Booking Calendar Demo'),
              actions: [
                IconButton(
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).state =
                          themeMode == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                    },
                    icon: Icon(
                      themeMode == ThemeMode.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ))
              ],
            ),
            body: Center(
              child: BookingCalendar(
                controller: mockBookingController,
                convertStreamResultToDateTimeRanges: convertStreamResultMock,
                getBookingStream: getBookingStreamMock,
                onBookChange: (BookingService newBooking) async {
                  await onBookSelected(context, newBooking: newBooking);
                },
                // pauseSlots: ,
                pauseSlotText: 'LUNCH',
                hideBreakTime: false,
                loadingWidget: const Text('Fetching data...'),
                // uploadingWidget: const CircularProgressIndicator(),
                locale: 'hu_HU',
                startingDayOfWeek: StartingDayOfWeek.tuesday,
                wholeDayIsBookedWidget:
                    const Text('Sorry, for this day everything is booked'),
                //disabledDates: [DateTime(2023, 1, 20)],
                //disabledDays: [6, 7],
              ),
            ),
          );
        }));
  }
}
