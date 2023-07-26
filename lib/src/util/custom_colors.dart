import 'package:flutter/material.dart';

const availalbeSlotColor = Colors.green;
const availableSlotDarkColor = Color(0xFF00E676);

const bookedSlotColor = Colors.red;
const bookedSlotDarkColor = Color(0xFFE53935);

Color getAvailableSlotColor(bool isDarkMode) {
  if (isDarkMode) {
    return availableSlotDarkColor;
  }
  return availalbeSlotColor;
}

Color getBookedColor(bool isDarkMode) {
  if (isDarkMode) {
    return bookedSlotDarkColor;
  }
  return bookedSlotColor; // Darker shade of red
}
