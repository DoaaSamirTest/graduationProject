import 'package:flutter/material.dart';
import '../models/medicine.dart';

class ControlScreen extends StatefulWidget {
  final Medicine? medicine;

  const ControlScreen({Key? key, this.medicine}) : super(key: key);

  @override
  _ControlScreenState createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  bool _isPickingMedicine = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('التحكم بالعربية'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // عرض الكاميرا
              Card(
                elevation: 3,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: Center(
                    child: _isPickingMedicine
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Colors.blue),
                              SizedBox(height: 16),
                              Text(
                                'جارٍ التقاط الدواء...',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.videocam, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'كاميرا العربية',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // أزرار التحكم بالحركة
              Text(
                'التحكم بحركة العربية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),

              // أزرار الاتجاهات
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: Icons.arrow_upward,
                    onPressed: () => _moveRobot('forward'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: Icons.arrow_back,
                    onPressed: () => _moveRobot('left'),
                  ),
                  SizedBox(width: 24),
                  _buildControlButton(
                    icon: Icons.arrow_forward,
                    onPressed: () => _moveRobot('right'),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: Icons.arrow_downward,
                    onPressed: () => _moveRobot('backward'),
                  ),
                ],
              ),
              
              Spacer(),
              
              // زر التقاط الدواء
              ElevatedButton(
                onPressed: _isPickingMedicine ? null : _pickMedicine,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.psychology),
                      SizedBox(width: 8),
                      Text(
                        'التقاط الدواء تلقائياً',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        iconSize: 32,
        padding: EdgeInsets.all(12),
      ),
    );
  }

  void _moveRobot(String direction) {
    // هنا سيكون الكود الحقيقي للتواصل مع العربية
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تحريك العربية: $direction'),
        duration: Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _pickMedicine() async {
    setState(() {
      _isPickingMedicine = true;
    });
    
    // محاكاة عملية التقاط الدواء
    await Future.delayed(Duration(seconds: 3));
    
    setState(() {
      _isPickingMedicine = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم التقاط الدواء ${widget.medicine?.name} بنجاح!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}