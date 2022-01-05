import 'package:json_annotation/json_annotation.dart';
part 'booking_service.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingService {
  /// The generated code assumes these values exist in JSON.
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPhoneNumber;
  final String? serviceId;
  final String serviceName;
  final int serviceDuration;
  final int? servicePrice;
  DateTime bookingStart;
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
