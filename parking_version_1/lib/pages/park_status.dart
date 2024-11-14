import 'package:flutter/material.dart';
import 'package:parking_version_1/pages/local_base.dart';


class ParkingOccupancyPage extends StatefulWidget {
  const ParkingOccupancyPage({super.key});

  @override
  _ParkingOccupancyPageState createState() => _ParkingOccupancyPageState();
}

class _ParkingOccupancyPageState extends State<ParkingOccupancyPage> {
  final db = LocalDatabase();
  int totalCarSlots = 24;
  int totalBikeSlots = 24;
  int occupiedCarSlots = 0;
  int occupiedBikeSlots = 0;

  @override
  void initState() {
    super.initState();
    _calculateOccupancy();
  }

  Future<void> _calculateOccupancy() async {
    final carSlots = await db.getSlots('car');
    final bikeSlots = await db.getSlots('bike');

    setState(() {
      occupiedCarSlots = carSlots.where((slot) => slot['status'] != 'available').length;
      occupiedBikeSlots = bikeSlots.where((slot) => slot['status'] != 'available').length;
    });
  }

  @override
  Widget build(BuildContext context) {
    double carOccupancy = occupiedCarSlots / totalCarSlots;
    double bikeOccupancy = occupiedBikeSlots / totalBikeSlots;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Occupancy'),
        backgroundColor: Colors.grey[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOccupancySection(
              'Car Parking',
              occupiedCarSlots,
              totalCarSlots,
              carOccupancy,
              Colors.blue,
            ),
            const SizedBox(height: 24),
            _buildOccupancySection(
              'Bike Parking',
              occupiedBikeSlots,
              totalBikeSlots,
              bikeOccupancy,
              Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOccupancySection(
    String title,
    int occupied,
    int total,
    double occupancy,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('Занято: $occupied из $total'),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: occupancy,
          color: color,
          backgroundColor: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        Text('${(occupancy * 100).toStringAsFixed(1)}% занятости'),
      ],
    );
  }
}
