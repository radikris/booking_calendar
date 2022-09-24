import 'package:booking_calendar/src/components/common_button.dart';
import 'package:booking_calendar/src/components/common_card.dart';
import 'package:flutter/material.dart';

class BookingSucessDialog extends StatelessWidget {
  const BookingSucessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CommonCard(child: Icon(Icons.book_online, size: 256)),
              ),
              const SizedBox(height: 16),
              const Text("Here comes your fancy loading"),
              CommonButton(text: ('Back To Home'), onTap: () {})
            ],
          ),
        ),
      ),
    );
  }
}
