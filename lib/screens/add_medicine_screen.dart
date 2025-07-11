import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/database_helper.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  AddMedicineScreenState createState() => AddMedicineScreenState();
}

class AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('إضافة دواء جديد'), centerTitle: true),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              opacity: 0.8,
              image: AssetImage('assets/images/pexels.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'اسم الدواء',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF2F6CAB)),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(
                        alpha: 0.8,
                      ), // خلفية بيضاء شفافة للحقل
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم الدواء';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'موقع الدواء (مثال: A1, B2)',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF2F6CAB)),
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.8),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال موقع الدواء';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  InkWell(
                    onTap: _selectTime,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'وقت تناول الدواء',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF2F6CAB)),
                        ),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTimeOfDay(_selectedTime),
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF2F6CAB),
                            ),
                          ),
                          Icon(Icons.access_time, color: Color(0xFF2F6CAB)),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _saveMedicine,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 24,
                      ),
                      child: Text(
                        'حفظ الدواء',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          ),
        );
      },
    );
    if (timeOfDay != null) {
      setState(() {
        _selectedTime = timeOfDay;
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hours = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  Future<void> _saveMedicine() async {
    if (_formKey.currentState!.validate()) {
      final medicine = Medicine(
        name: _nameController.text,
        time: _formatTimeOfDay(_selectedTime),
        location: _locationController.text,
      );
      await DatabaseHelper().insertMedicine(medicine);

      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
