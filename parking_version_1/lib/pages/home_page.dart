import 'package:flutter/material.dart';
import 'package:parking_version_1/pages/park_status.dart';
import 'package:parking_version_1/pages/parking_page.dart';
// Импорт для ParkingOccupancyPage

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildMenuItem(context, Icons.directions_car, 'Available Park\n(Car)', true),
            _buildMenuItem(context, Icons.local_parking, 'Park Status', false),
            _buildMenuItem(context, Icons.directions_bike, 'Available Park\n(Bike)', false),
            _buildMenuItem(context, Icons.history, 'Transaction History', false),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String label, bool isAvailablePark) {
    return GestureDetector(
      onTap: () {
        if (label == 'Available Park\n(Car)') {
          // Переход на страницу ParkingSlotsPage для парковки машин
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ParkingSlotsPage(type: 'car')),
          );
        } else if (label == 'Available Park\n(Bike)') {
          // Переход на страницу ParkingSlotsPage для парковки велосипедов
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ParkingSlotsPage(type: 'bike')),
          );
        } else if (label == 'Park Status') {
          // Переход на страницу ParkingOccupancyPage при нажатии на Park Status
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ParkingOccupancyPage()),
          );
        } else {
          // Обработайте другие нажатия здесь, если нужно
          print("Tapped on: $label");
        }
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
