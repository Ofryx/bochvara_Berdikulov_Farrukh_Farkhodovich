import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SensorDataPage extends StatefulWidget {
  const SensorDataPage({super.key});

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('sensor');
  
  double? _temperature;
  double? _humidity;
  double? _pressure;
  double? _speed;

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    _dbRef.child('temperature').onValue.listen((event) {
      final data = event.snapshot.value;
      if (mounted) {
        setState(() {
          _temperature = double.tryParse(data.toString());
        });
      }
    });

    // Аналогично для других датчиков
    _dbRef.child('humidity').onValue.listen((event) {
      if (mounted) {
        setState(() {
          _humidity = double.tryParse(event.snapshot.value.toString());
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Данные датчиков')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSensorTile('Температура', _temperature, '°C'),
            _buildSensorTile('Влажность', _humidity, '%'),
            _buildSensorTile('Давление', _pressure, 'hPa'),
            _buildSensorTile('Скорость', _speed, 'm/s'),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(String title, double? value, String unit) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        value != null ? '${value.toStringAsFixed(1)}$unit' : '---',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}