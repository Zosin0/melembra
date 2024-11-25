import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'contas.dart'; // Importe a página de contas
import 'pagamentos.dart'; // Importe a página de pagamentos

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color.fromARGB(255, 218, 236, 247),
        appBar: AppBar(
            title: DefaultTextStyle(
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(fontSize: 48, fontWeight: FontWeight.w600),
                color: Colors.white,
                fontSize: 30.0,
              ),
              child: const Text('Me lembra!'),
            ),
            backgroundColor: const Color.fromARGB(255, 80, 5, 255)),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ContasScreen()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/conta.png',
                        width: 100,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PagamentosScreen()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/pagamento.png',
                        width: 100,
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
