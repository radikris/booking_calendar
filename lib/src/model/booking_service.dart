class BookingService {
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

  BookingService({
    this.userEmail,
    this.userPhoneNumber,
    this.userId,
    this.userName,
    required this.bookingStart,
    required this.bookingEnd,
    this.serviceId,
    required this.serviceName,
    required this.serviceDuration,
    this.servicePrice,
  });

  BookingService.fromJson(Map<String, dynamic> json)
      : userEmail = json['userEmail'] as String?,
        userPhoneNumber = json['userPhoneNumber'] as String?,
        userId = json['userId'] as String?,
        userName = json['userName'] as String?,
        bookingStart = DateTime.parse(json['bookingStart'] as String),
        bookingEnd = DateTime.parse(json['bookingEnd'] as String),
        serviceId = json['serviceId'] as String?,
        serviceName = json['serviceName'] as String,
        serviceDuration = json['serviceDuration'] as int,
        servicePrice = json['servicePrice'] as int?;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'userPhoneNumber': userPhoneNumber,
        'serviceId': serviceId,
        'serviceName': serviceName,
        'serviceDuration': serviceDuration,
        'servicePrice': servicePrice,
        'bookingStart': bookingStart.toIso8601String(),
        'bookingEnd': bookingEnd.toIso8601String(),
      };
}
