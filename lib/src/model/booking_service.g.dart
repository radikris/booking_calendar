// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingService _$BookingServiceFromJson(Map<String, dynamic> json) =>
    BookingService(
      userEmail: json['userEmail'] as String?,
      userPhoneNumber: json['userPhoneNumber'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      bookingStart: DateTime.parse(json['bookingStart'] as String),
      bookingEnd: DateTime.parse(json['bookingEnd'] as String),
      serviceId: json['serviceId'] as String?,
      serviceName: json['serviceName'] as String,
      serviceDuration: json['serviceDuration'] as int,
      servicePrice: json['servicePrice'] as int?,
    );

Map<String, dynamic> _$BookingServiceToJson(BookingService instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'userEmail': instance.userEmail,
      'userPhoneNumber': instance.userPhoneNumber,
      'serviceId': instance.serviceId,
      'serviceName': instance.serviceName,
      'serviceDuration': instance.serviceDuration,
      'servicePrice': instance.servicePrice,
      'bookingStart': instance.bookingStart.toIso8601String(),
      'bookingEnd': instance.bookingEnd.toIso8601String(),
    };
