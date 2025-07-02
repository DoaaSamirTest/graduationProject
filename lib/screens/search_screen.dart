import 'package:flutter/material.dart';
import '../models/medicine.dart';
import '../utils/database_helper.dart';
import '../utils/http_test_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchScreenState createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Medicine> _allMedicines = [];
  List<Medicine> _filteredMedicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    _allMedicines = await _dbHelper.getMedicines();
    setState(() {
      _filteredMedicines = _allMedicines;
      _isLoading = false;
    });
  }

  void _filterMedicines(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMedicines = _allMedicines;
      } else {
        _filteredMedicines =
            _allMedicines
                .where(
                  (medicine) =>
                      medicine.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
      }
    });
  }

  Future<void> _sendMedicineName(String medicineName) async {
    await HttpTestService.sendMedicineNameToServer(context, medicineName);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('البحث عن الأدوية'), centerTitle: true),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  opacity: 0.8,
                  image: AssetImage('assets/images/pexels.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'ابحث عن دواء...',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF2F6CAB)),
                      ),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF2F6CAB)),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: _filterMedicines,
                  ),
                  SizedBox(height: 20),

                  // Results
                  Expanded(
                    child:
                        _isLoading
                            ? Center(child: CircularProgressIndicator())
                            : _filteredMedicines.isEmpty
                            ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    _searchController.text.isEmpty
                                        ? 'لا توجد أدوية في القائمة'
                                        : 'لا توجد نتائج للبحث',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            : ListView.builder(
                              itemCount: _filteredMedicines.length,
                              itemBuilder: (context, index) {
                                final medicine = _filteredMedicines[index];
                                return Card(
                                  margin: EdgeInsets.only(bottom: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Icon(
                                        Icons.medication,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    title: Text(
                                      medicine.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('الوقت: ${medicine.time}'),
                                        Text('الموقع: ${medicine.location}'),
                                      ],
                                    ),
                                    trailing: ElevatedButton.icon(
                                      onPressed:
                                          () =>
                                              _sendMedicineName(medicine.name),
                                      icon: Icon(Icons.send, size: 16),
                                      label: Text('إرسال'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
