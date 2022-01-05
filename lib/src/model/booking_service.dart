import 'package:json_annotation/json_annotation.dart';
part 'booking_service.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingService {
  /// The generated code assumes these values exist in JSON.
  ///
  /// The userId of the currently logged user
  /// who will start the new booking
  final String? userId;

  /// The userName of the currently logged user
  /// who will start the new booking
  final String? userName;

  /// The userEmail of the currently logged user
  /// who will start the new booking
  final String? userEmail;

  /// The userPhoneNumber of the currently logged user
  /// who will start the new booking
  final String? userPhoneNumber;

  /// The id of the currently selected Service
  /// for this service will the user start the new booking

  final String? serviceId;

  ///The name of the currently selected Service
  final String serviceName;

  ///The duration of the currently selected Service

  final int serviceDuration;

  ///The price of the currently selected Service

  final int? servicePrice;

  ///The selected booking slot's starting time
  DateTime bookingStart;

  ///The selected booking slot's ending time
  DateTime bookingEnd;

  BookingService(
      {this.userEmail,
      this.userPhoneNumber,
      this.userId,
      this.userName,
      required this.bookingStart,
      required this.bookingEnd,
      this.serviceId,
      required this.serviceName,
      required this.serviceDuration,
      this.servicePrice});

  /// Connect the generated [_$BookingServiceFromJson] function to the `fromJson`
  /// factory.
  factory BookingService.fromJson(Map<String, dynamic> json) => _$BookingServiceFromJson(json);

  /// Connect the generated [_$BookingServiceToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$BookingServiceToJson(this);
}
