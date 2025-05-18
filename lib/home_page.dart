import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vkr_test/Auth/Login_page.dart';
import 'package:vkr_test/LineCharts/LineChart_humidity.dart';
import 'package:vkr_test/LineCharts/LineChart_pressure.dart';
import 'package:vkr_test/LineCharts/LineChart_speed.dart';
import 'package:vkr_test/LineCharts/LineChart_temperature.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _sensorDataStream;

  @override
  void initState() {
    super.initState();
    // Создаем поток для получения последнего документа из коллекции sensor_data
    _sensorDataStream = _firestore
        .collection('sensor_data')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

  // Функция для форматирования значений датчиков
  String _formatSensorValue(dynamic value, String unit) {
    if (value == null) return '-- $unit';
    return '${value.toStringAsFixed(1)} $unit';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 11, 1, 117),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(onTap: () {}),
                  ),
                );
              }
            },
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
        title: Text(
          "Бердикулов Ф.Ф.",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "Барабанный вакуум фильтр",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6,
                      offset: Offset(2, 2),)
                  ],
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _sensorDataStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Ошибка: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    // Если нет данных
                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('Нет данных датчиков'));
                    }

                    // Получаем последний документ
                    var lastData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

                    return Table(
                      border: TableBorder(
                        horizontalInside: BorderSide(color: Colors.black, width: 2),
                        verticalInside: BorderSide(color: Colors.black, width: 2),
                      ),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 45, 22, 135),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ), 
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Датчики',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  'Значение',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Температура',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _formatSensorValue(lastData['temperature'], '°C'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Влажность',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _formatSensorValue(lastData['humidity'], '%'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Давление',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _formatSensorValue(lastData['pressure'], 'Па'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Скорость вращения',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _formatSensorValue(lastData['speed'], 'м/с'),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LineCHART_temperature(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LineCHART_humidity(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LineCHART_pressure(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LineCHART_speed(),
            ),
          ],
        ),
      ),
    );
  }
}