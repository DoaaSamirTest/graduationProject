import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/database_helper.dart';
import '../utils/http_test_service.dart';
import 'control_screen.dart';

class MedicineDetailsScreen extends StatefulWidget {
  final Medicine? medicine;

  const MedicineDetailsScreen({super.key, this.medicine});

  @override
  MedicineDetailsScreenState createState() => MedicineDetailsScreenState();
}

class MedicineDetailsScreenState extends State<MedicineDetailsScreen> {
  late Medicine _medicine;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _medicine = widget.medicine!;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('تفاصيل الدواء'),
          backgroundColor:Colors.white,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            // ✅ الخلفية
            Positioned.fill(
              child: Image.asset(
                'assets/images/pexels.jpg', // ← غيّري المسار حسب اسم الصورة
                fit: BoxFit.cover,
              ),
            ),

            // ✅ المحتوى فوق الخلفية
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 3,
                    color: Colors.white.withValues(alpha: 0.4), // ← خلفية شفافة للكرت
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.medication,
                              size: 40,
                              color: Color.fromARGB(255, 11, 3, 79),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            _medicine.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                _medicine.time,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'الموقع: ${_medicine.location}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ControlScreen(medicine: _medicine),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.navigation),
                                  SizedBox(width: 8),
                                  Text(
                                    'تحريك العربية للدواء',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _medicine.taken ? null : _markAsTaken,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  _medicine.taken
                                      ? Colors.grey.shade300
                                      : const Color.fromARGB(
                                        255,
                                        227,
                                        227,
                                        116,
                                      ).withValues(alpha: 0.6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _medicine.taken
                                        ? Icons.check
                                        : Icons.check_circle,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    _medicine.taken
                                        ? 'تم أخذ الدواء'
                                        : 'تأكيد أخذ الدواء',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await HttpTestService.sendMedicineNameToServer(
                                context,
                                _medicine.name,
                              );
                            },
                            icon: Icon(Icons.send),
                            label: Text('إرسال اسم الدواء للخادم'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _markAsTaken() async {
    final updatedMedicine = Medicine(
      id: _medicine.id,
      name: _medicine.name,
      time: _medicine.time,
      taken: true,
      location: _medicine.location,
    );

    await _dbHelper.updateMedicine(updatedMedicine);

    setState(() {
      _medicine = updatedMedicine;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تأكيد أخذ الدواء'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
