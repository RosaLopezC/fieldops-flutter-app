import 'package:flutter/material.dart';
import 'location_selection_screen.dart';

void main() {
  runApp(FieldOpsApp());
}

class FieldOpsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldOps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1565C0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Lista simulada de encargados
  final List<Map<String, String>> encargados = [
    {
      'nombre': 'Rosa Lopez',
      'dni': '87654321',
      'password': 'rosa123',
    },
    {
      'nombre': 'Ana Lopez',
      'dni': '45678912',
      'password': 'ana123',
    },
    {
      'nombre': 'Genesis Vazques',
      'dni': '45871296',
      'password': 'genesis123',
    },
    {
      'nombre': 'Mexi Malera',
      'dni': '12345698',
      'password': 'mexi123',
    },
  ];

  void _login() async {
    final dni = _dniController.text.trim();
    final password = _passwordController.text.trim();

    if (dni.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1)); // Simula llamada API

    setState(() {
      _isLoading = false;
    });

    // Buscar usuario por DNI
    final encargado = encargados.firstWhere(
      (e) => e['dni'] == dni,
      orElse: () => {},
    );

    if (encargado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('DNI no registrado')),
      );
      return;
    }

    if (encargado['password'] != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contraseña incorrecta')),
      );
      return;
    }

    // Login exitoso, puedes pasar datos del usuario si lo necesitas
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
          encargado: encargado, // Pass the logged-in user data
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              
              // Logo FieldOps
              Container(
                height: 100,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              SizedBox(height: 60),
              
              // Campo DNI
              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'DNI',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Campo Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Recordar datos
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                    activeColor: Color(0xFF1565C0),
                  ),
                  Text(
                    'Recordar datos',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Botón Iniciar Sesión
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 40),
              
              // Pie de página con versión
              Text(
                'FieldOps v1.0.0',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}