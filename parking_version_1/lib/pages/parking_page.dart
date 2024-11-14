import 'package:flutter/material.dart';
import 'package:parking_version_1/pages/local_base.dart';
import 'package:parking_version_1/pages/payment.dart';
 // Подключаем страницу оплаты

class ParkingSlotsPage extends StatefulWidget {
  final String type; // 'car' или 'bike'

  const ParkingSlotsPage({super.key, required this.type});

  @override
  _ParkingSlotsPageState createState() => _ParkingSlotsPageState();
}

class _ParkingSlotsPageState extends State<ParkingSlotsPage> {
  List<String> slotStatus = List.filled(24, 'available');
  int? selectedSlotIndex;
  bool showMessage = false;
  String messageText = '';
  final db = LocalDatabase();

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  void _loadSlots() async {
    final slots = await db.getSlots(widget.type);
    setState(() {
      slotStatus = List.generate(24, (index) {
        final slot = slots.firstWhere(
          (s) => s['id'] == index,
          orElse: () => {'status': 'available'},
        );
        return slot['status'] as String;
      });
    });
  }

  void _updateSlot(int index, String status) async {
    await db.insertSlot(index, widget.type, status);
    setState(() {
      slotStatus[index] = status;
    });
  }

  void reserveSlot() {
    if (selectedSlotIndex != null && slotStatus[selectedSlotIndex!] == 'available') {
      _updateSlot(selectedSlotIndex!, 'reserved');
      _showMessage('Успешно забронировано на 1 час.');
    }
  }

  void bookSlot() {
    if (selectedSlotIndex != null && slotStatus[selectedSlotIndex!] == 'available') {
      _updateSlot(selectedSlotIndex!, 'booked');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentPage(slotIndex: selectedSlotIndex!),
        ),
      );
    } else {
      _showMessage('Выберите свободное место для бронирования.');
    }
  }

  void _showMessage(String text) {
    setState(() {
      showMessage = true;
      messageText = text;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        showMessage = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.type == 'car' ? 'Парковка машин' : 'Парковка велосипедов'),
        backgroundColor: Colors.grey[800],
      ),
      body: Column(
        children: [
          _buildLegend(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemCount: 24,
              itemBuilder: (context, index) {
                Color color = slotStatus[index] == 'booked' ? Colors.blue
                  : slotStatus[index] == 'reserved' ? Colors.yellow
                  : Colors.green;

                return GestureDetector(
                  onTap: () => setState(() => selectedSlotIndex = index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: selectedSlotIndex == index ? Colors.white : color,
                      borderRadius: BorderRadius.circular(8),
                      border: selectedSlotIndex == index
                          ? Border.all(color: Colors.black, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        'C${index + 1}',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildLegend() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLegendItem(Colors.blue, 'Ваше бронирование'),
        _buildLegendItem(Colors.yellow, 'Забронировано'),
        _buildLegendItem(Colors.green, 'Свободные места'),
      ],
    ),
  );

  Widget _buildLegendItem(Color color, String label) => Row(
    children: [
      Container(width: 16, height: 16, color: color),
      const SizedBox(width: 8),
      Text(label),
    ],
  );

  Widget _buildButtons() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: bookSlot,
          child: const Text('ЗАБРОНИРОВАТЬ'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
        ElevatedButton(
          onPressed: reserveSlot,
          child: const Text('РЕЗЕРВИРОВАТЬ'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700]),
        ),
      ],
    ),
  );
}
