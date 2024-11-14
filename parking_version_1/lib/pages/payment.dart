import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final int slotIndex;

  const PaymentPage({super.key, required this.slotIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оплата'),
        backgroundColor: Colors.grey[800],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Вы забронировали место C${slotIndex + 1}.',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Пожалуйста, завершите оплату, чтобы подтвердить бронирование.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Логика оплаты или переход к форме оплаты
                  Navigator.pop(context); // Вернуться на предыдущую страницу после оплаты
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text('Перейти к оплате'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
