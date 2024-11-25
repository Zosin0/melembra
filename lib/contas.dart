import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:melembra/data.page.view.dart';
import 'package:melembra/db.helper.dart';

class ContasScreen extends StatefulWidget {
  const ContasScreen({super.key});

  @override
  State<ContasScreen> createState() => _ContasScreenState();
}

class _ContasScreenState extends State<ContasScreen> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;
// GET
  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      _titleController.text = existingData['title'];
      _descriptionController.text = existingData['desc'];
      _passwordController.text = existingData['password'];
      _loginController.text = existingData['login'];
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
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nome',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Login',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Senha',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
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
                      await _updateData(id);
                    }

                    _titleController.text = '';
                    _descriptionController.text = '';
                    _passwordController.text = '';
                    _loginController.text = '';

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
    await SQLHelper.createData(
      _titleController.text,
      _descriptionController.text,
      _passwordController.text,
      _loginController.text,
    );
    _refreshData();
  }

// Update
  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
        id,
        _titleController.text,
        _descriptionController.text,
        _passwordController.text,
        _loginController.text);
    _refreshData();
  }

// Delete
  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Conta deletada com sucesso!'),
      ),
    );
    _refreshData();
  }

  // Consultar
  void _seeData(int id) async {
    List<Map<String, dynamic>> data = await SQLHelper.seeData(id);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataPage(data: data),
      ),
    );

    _refreshData();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 119, 179, 236),
        appBar: AppBar(
            title: DefaultTextStyle(
              style: GoogleFonts.roboto(
                textStyle:
                    const TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                color: Colors.white,
                fontSize: 30.0,
              ),
              child: const Text('Contas!'),
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
                        _allData[index]['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Text(_allData[index]['desc']),
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
                            _deleteData(_allData[index]['id']);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _seeData(_allData[index]['id']);
                          },
                          icon: Icon(
                            Icons.search,
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
