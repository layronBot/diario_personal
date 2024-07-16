import 'package:flutter/material.dart';
import 'package:diario2/pantallas/login.dart';
import 'package:diario2/pantallas/registrar.dart';
import 'package:diario2/pantallas/bienvenido.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diario Personal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        // Remove the line below as we need to pass parameters dynamically
        // '/welcome': (context) => const BienvenidoPage(userId: 0, userName: '', userUsername: ''), 
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/welcome') {
          final args = settings.arguments;
          if (args is Map<String, dynamic>) {
            return MaterialPageRoute(
              builder: (context) {
                return BienvenidoPage(
                  userId: args['userId'],
                  userName: args['userName'],
                  userUsername: args['userUsername'],
                );
              },
            );
          }
        }
        // If no match was found for the route, return null
        return null;
      },
    );
  }
}






