import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  DataPage({Key? key, required this.data}) : super(key: key);

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final _pinController = TextEditingController();
  bool _isPinCorrect = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _requestPin();
    });
  }

  void _requestPin() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Entre com o PIN'),
          content: TextField(
            controller: _pinController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'PIN',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (_pinController.text == '1234') {
                  setState(() {
                    _isPinCorrect = true;
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('PIN incorreto'),
                    ),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informações da Conta'),
      ),
      body: _isPinCorrect
          ? Container(
              color: Colors.lightBlue[50],
              child: ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Login: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${widget.data[index]['login']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Senha: ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${widget.data[index]['password']}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Center(child: Text('Entre com o PIN para visualizar os dados')),
    );
  }
}
