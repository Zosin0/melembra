import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:melembra/db.helper.dart';
import 'package:melembra/notification.dart';

class PagamentosScreen extends StatefulWidget {
  const PagamentosScreen({super.key});

  @override
  State<PagamentosScreen> createState() => _PagamentosScreenState();
}

class _PagamentosScreenState extends State<PagamentosScreen> {
  NotificationService _notificationService = NotificationService();

  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;
  // GET
  void _refreshData() async {
    final data = await SQLHelper.getAllDataFromData2();
    setState(() {
      _allData = data.where((payment) => payment['paid'] == 0).toList();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _termController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  Future<void> _selectDateAndTime() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) {
      return;
    }

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime == null) {
      return;
    }

    final DateTime selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    _termController.text = selectedDateTime.toIso8601String();
  }

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _nameController.text = existingData['name'];
      _termController.text = existingData['term'];
      _valueController.text = existingData['value'];
      _descController.text = existingData['desc'];
    }

    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
              top: 30,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _termController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Prazo',
                ),
                onTap: _selectDateAndTime,
                readOnly: true, // para evitar que o teclado apareça
              ),
              SizedBox(height: 10),
              TextField(
                controller: _valueController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Valor',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Descrição',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (id == null) {
                      await _addData();
                    } else {
                      await _updateData(id, true);
                    }

                    _nameController.text = '';
                    _termController.text = '';
                    _valueController.text = '';
                    _descController.text = '';

                    Navigator.of(context).pop();
                    _refreshData(); // Atualiza os dados após adicionar ou atualizar
                    print("Data Adicionada");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Text(
                      id == null ? 'Adicionar' : 'Atualizar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add
  Future<void> _addData() async {
    await SQLHelper.addData2(
      _nameController.text,
      _termController.text,
      _valueController.text,
      _descController.text,
    );
    DateTime dueDate = DateTime.parse(_termController.text);
    _notificationService.scheduleNotification(dueDate, _nameController.text, _valueController.text);

    _refreshData();
  }

  // Update
  Future<void> _updateData(int id, bool paid) async {
    await SQLHelper.updateData2(
      id, 
      _nameController.text, 
      _termController.text,
      _valueController.text, 
      _descController.text, 
      paid, // Adicione este parâmetro
    );
    _refreshData();
  }


// Pay
  void _payData(int id) async {
    await SQLHelper.updateData2(
      id,
      _nameController.text,
      _termController.text,
      _valueController.text,
      _descController.text,
      true, // Marca o pagamento como pago
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Pagamento realizado com sucesso!'),
      ),
    );
    _refreshData();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color.fromARGB(255, 119, 236, 207),
        appBar: AppBar(
            title: DefaultTextStyle(
              style: GoogleFonts.roboto(
                textStyle:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                color: Colors.white,
                fontSize: 30.0,
              ),
              child: const Text('Pagamentos!'),
            ),
            backgroundColor: const Color.fromARGB(255, 80, 5, 255)),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _allData.length,
                itemBuilder: (context, index) => Card(
                  margin: EdgeInsets.all(15),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        _allData[index]['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(_allData[index]['value']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showBottomSheet(_allData[index]['id']);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.indigo,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _payData(_allData[index]['id']);
                          },
                          icon: Icon(
                            Icons.payment,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showBottomSheet(null),
          child: Icon(Icons.add),
        ),
      );
}
