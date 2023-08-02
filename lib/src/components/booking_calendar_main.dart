import 'package:booking_calendar/src/util/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:table_calendar/table_calendar.dart' as tc
    show StartingDayOfWeek;

import '../core/booking_controller.dart';
import '../model/booking_service.dart';
import '../model/enums.dart' as bc;
import '../util/booking_util.dart';
import 'booking_explanation.dart';
import 'booking_slot.dart';
import 'common_card.dart';

class BookingCalendarMain extends StatefulWidget {
  const BookingCalendarMain(
      {Key? key,
      required this.getBookingStream,
      required this.convertStreamResultToDateTimeRanges,
      this.onBookChange,
      this.bookingExplanation,
      this.bookingGridCrossAxisCount,
      this.bookingGridChildAspectRatio,
      this.formatDateTime,
      this.calendarBackgroundColor,
      this.bookingButtonText,
      this.bookingButtonColor,
      this.bookedSlotColor,
      this.selectedSlotColor,
      this.availableSlotColor,
      this.bookedSlotText,
      this.bookedSlotTextStyle,
      this.selectedSlotText,
      this.selectedSlotTextStyle,
      this.availableSlotText,
      this.availableSlotTextStyle,
      this.gridScrollPhysics,
      this.loadingWidget,
      this.errorWidget,
      // this.uploadingWidget,
      this.wholeDayIsBookedWidget,
      this.pauseSlotColor,
      this.pauseSlotText,
      this.hideBreakTime = false,
      this.locale,
      this.startingDayOfWeek,
      this.disabledDays,
      this.disabledDates,
      this.lastDay,
      this.calendarStyle})
      : super(key: key);

  final Stream<dynamic>? Function(
      {required DateTime start, required DateTime end}) getBookingStream;
  final Future<void> Function(BookingService newBooking)? onBookChange;
  final List<DateTimeRange> Function({required dynamic streamResult})
      convertStreamResultToDateTimeRanges;

  ///Customizable
  final Widget? bookingExplanation;
  final int? bookingGridCrossAxisCount;
  final double? bookingGridChildAspectRatio;
  final String Function(DateTime dt)? formatDateTime;
  final String? bookingButtonText;
  final Color? bookingButtonColor;
  final Color? bookedSlotColor;
  final Color? selectedSlotColor;
  final Color? availableSlotColor;
  final Color? pauseSlotColor;
  final Color? calendarBackgroundColor;

//Added optional TextStyle to available, booked and selected cards.
  final String? bookedSlotText;
  final String? selectedSlotText;
  final String? availableSlotText;
  final String? pauseSlotText;

  final TextStyle? bookedSlotTextStyle;
  final TextStyle? availableSlotTextStyle;
  final TextStyle? selectedSlotTextStyle;

  final ScrollPhysics? gridScrollPhysics;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  // final Widget? uploadingWidget;

  final bool? hideBreakTime;
  final DateTime? lastDay;
  final String? locale;
  final bc.StartingDayOfWeek? startingDayOfWeek;
  final List<int>? disabledDays;
  final List<DateTime>? disabledDates;

  final Widget? wholeDayIsBookedWidget;

  final CalendarStyle? calendarStyle;

  @override
  State<BookingCalendarMain> createState() => _BookingCalendarMainState();
}

class _BookingCalendarMainState extends State<BookingCalendarMain> {
  late BookingController controller;
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = context.read<BookingController>();
    final firstDay = calculateFirstDay();

    startOfDay = firstDay.startOfDayService(controller.serviceOpening);
    endOfDay = firstDay.endOfDayService(controller.serviceClosing);
    _focusedDay = firstDay;
    _selectedDay = firstDay;
    controller.selectFirstDayByHoliday(startOfDay, endOfDay);
  }

  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;

  late DateTime _selectedDay;
  late DateTime _focusedDay;
  late DateTime startOfDay;
  late DateTime endOfDay;

  void selectNewDateRange() {
    startOfDay = _selectedDay.startOfDayService(controller.serviceOpening);
    endOfDay = _selectedDay
        .add(const Duration(days: 1))
        .endOfDayService(controller.serviceClosing);

    controller.base = startOfDay;
    controller.resetSelectedSlot();
  }

  DateTime calculateFirstDay() {
    final now = DateTime.now();
    if (widget.disabledDays != null) {
      return widget.disabledDays!.contains(now.weekday)
          ? now.add(Duration(days: getFirstMissingDay(now.weekday)))
          : now;
    } else {
      return DateTime.now();
    }
  }

  int getFirstMissingDay(int now) {
    for (var i = 1; i <= 7; i++) {
      if (!widget.disabledDays!.contains(now + i)) {
        return i;
      }
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    controller = context.watch<BookingController>();

    return Consumer<BookingController>(
      builder: (_, controller, __) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: CommonCard(
                color: widget.calendarBackgroundColor,
                child: TableCalendar(
                  startingDayOfWeek: widget.startingDayOfWeek?.toTC() ??
                      tc.StartingDayOfWeek.monday,
                  holidayPredicate: (day) {
                    if (widget.disabledDates == null) return false;

                    bool isHoliday = false;
                    for (var holiday in widget.disabledDates!) {
                      if (isSameDay(day, holiday)) {
                        isHoliday = true;
                      }
                    }
                    return isHoliday;
                  },
                  enabledDayPredicate: (day) {
                    if (widget.disabledDays == null &&
                        widget.disabledDates == null) return true;

                    bool isEnabled = true;
                    if (widget.disabledDates != null) {
                      for (var holiday in widget.disabledDates!) {
                        if (isSameDay(day, holiday)) {
                          isEnabled = false;
                        }
                      }
                      if (!isEnabled) return false;
                    }
                    if (widget.disabledDays != null) {
                      isEnabled = !widget.disabledDays!.contains(day.weekday);
                    }

                    return isEnabled;
                  },
                  locale: widget.locale,
                  firstDay: calculateFirstDay(),
                  lastDay: widget.lastDay ??
                      DateTime.now().add(const Duration(days: 1000)),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  calendarStyle: widget.calendarStyle ??
                      CalendarStyle(
                        isTodayHighlighted: true,
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      selectNewDateRange();
                    }
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverToBoxAdapter(
              child: widget.bookingExplanation ??
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    direction: Axis.horizontal,
                    children: [
                      BookingExplanation(
                          color: widget.availableSlotColor ??
                              getAvailableSlotColor(isDarkMode),
                          text: widget.availableSlotText ?? "Available"),
                      BookingExplanation(
                          color: widget.selectedSlotColor ??
                              Theme.of(context).primaryColor,
                          text: widget.selectedSlotText ?? "Selected"),
                      BookingExplanation(
                          color: widget.bookedSlotColor ??
                              getBookedColor(isDarkMode),
                          text: widget.bookedSlotText ?? "Booked"),
                      if (widget.hideBreakTime != null &&
                          widget.hideBreakTime == false)
                        BookingExplanation(
                            color: widget.pauseSlotColor ?? Colors.grey,
                            text: widget.pauseSlotText ?? "Break"),
                    ],
                  ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverFillRemaining(
              child: StreamBuilder<dynamic>(
                stream:
                    widget.getBookingStream(start: startOfDay, end: endOfDay),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return widget.errorWidget ??
                        Center(
                          child: Text(snapshot.error.toString()),
                        );
                  }

                  if (!snapshot.hasData) {
                    return widget.loadingWidget ??
                        const Center(child: CircularProgressIndicator());
                  }

                  ///this snapshot should be converted to List<DateTimeRange>
                  final data = snapshot.requireData;
                  controller.generateBookedSlots(widget
                      .convertStreamResultToDateTimeRanges(streamResult: data));
                  // return Container();

                  return (widget.wholeDayIsBookedWidget != null &&
                          controller.isWholeDayBooked())
                      ? widget.wholeDayIsBookedWidget!
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.allBookingSlots.length,
                          itemBuilder: (context, index) {
                            TextStyle? getTextStyle() {
                              if (controller.isSlotBooked(index)) {
                                return widget.bookedSlotTextStyle;
                              } else if (index == controller.selectedSlot) {
                                return widget.selectedSlotTextStyle;
                              } else {
                                return widget.availableSlotTextStyle;
                              }
                            }

                            final slot =
                                controller.allBookingSlots.elementAt(index);
                            return BookingSlot(
                              hideBreakSlot: widget.hideBreakTime,
                              pauseSlotColor: widget.pauseSlotColor,
                              availableSlotColor: widget.availableSlotColor,
                              bookedSlotColor: widget.bookedSlotColor,
                              selectedSlotColor: widget.selectedSlotColor,
                              isPauseTime: controller.isSlotInPauseTime(slot),
                              isBooked: controller.isSlotBooked(index),
                              isSelected: index == controller.selectedSlot,
                              onTap: () {
                                if (controller.isSlotBooked(index)) {
                                  return;
                                }
                                controller.select(index);
                                widget.onBookChange?.call(controller.value);
                              },
                              child: Center(
                                child: Text(
                                  widget.formatDateTime?.call(slot) ??
                                      BookingUtil.formatDateTime(slot),
                                  style: getTextStyle() ??
                                      Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                widget.bookingGridCrossAxisCount ?? 3,
                            childAspectRatio:
                                widget.bookingGridChildAspectRatio ?? 1.5,
                          ),
                        );
                },
              ),
            ),
            // const SizedBox(
            //   height: 16,
            // ),
            // CommonButton(
            //   text: widget.bookingButtonText ?? 'BOOK',
            //   onPressed: () async {
            //     // controller.toggleUploading();
            //     await widget.onBookSelected
            //         ?.call(controller.generateNewBookingForUploading());
            //     // controller.toggleUploading();
            //     if (context.mounted) {
            //       controller.resetSelectedSlot();
            //     }
            //   },
            //   isDisabled: controller.selectedSlot == -1,
            //   buttonActiveColor: widget.bookingButtonColor,
            // ),
          ],
        ),
      ),
    );
  }
}
