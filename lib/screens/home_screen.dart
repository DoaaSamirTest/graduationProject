import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/database_helper.dart';
import 'medicine_details_screen.dart';
import 'add_medicine_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Medicine> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    _medicines = await _dbHelper.getMedicines();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 3, 103, 65),
          title: Text('جدول الأدوية'),
          centerTitle: true,
          elevation:0,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // الخلفية
            Positioned.fill(
              child: Image.asset(
                'lib/images/pexels-n-voitkevich-7615574.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // المحتوى
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          color: Colors.white.withOpacity(0.6),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              _getCurrentDate(),
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        ..._medicines.map((medicine) => _buildMedicineCard(medicine)),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AddMedicineScreen()),
                            );
                            _loadMedicines();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 3, 103, 65).withOpacity(0.6),


  
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('إضافة دواء جديد',
                                style: TextStyle(fontSize: 16,
                                color: Colors.white)),
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

  Widget _buildMedicineCard(Medicine medicine) {
    return Card(
      color: Colors.white.withOpacity(0.6),
      margin: EdgeInsets.only(bottom: 24),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MedicineDetailsScreen(medicine: medicine),
            ),
          );
          _loadMedicines();
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(255, 45, 191, 125),
                child: Icon(Icons.medication, color: Colors.white),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicine.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(medicine.time, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 14,
                backgroundColor: medicine.taken ? Colors.green.shade100 : const Color.fromARGB(255, 45, 191, 125),
                child: Icon(
                  medicine.taken ? Icons.check : Icons.notifications,
                  size: 16,
                  color: medicine.taken ? Colors.green : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final days = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    
    return '${days[now.weekday - 1]}، ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
