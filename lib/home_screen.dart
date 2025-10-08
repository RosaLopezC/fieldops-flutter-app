// lib/home_screen.dart
import 'package:flutter/material.dart';
import 'poste_selection_screen.dart';
import 'predio_form_screen.dart'; // <-- importa la pantalla de formulario de predio
import 'pendientes_screen.dart'; // <-- importa la pantalla de pendientes
import 'location_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final Map<String, String> encargado; // <-- agrega esto

  const HomeScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.encargado, // <-- agrega esto
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> encargados = [
    {'nombre': 'Rosa Lopez', 'dni': '87654321'},
    {'nombre': 'Ana Lopez', 'dni': '45678912'},
    {'nombre': 'Genesis Vazques', 'dni': '45871296'},
    {'nombre': 'Mexi Malera', 'dni': '12345698'},
  ];

  void _onPostePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteSelectionScreen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
        ),
      ),
    );
  }

  void _onPredioPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PredioFormScreen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
        ),
      ),
    );
  }

  void _onPendientesPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PendientesScreen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
        ),
      ),
    );
  }

  void _onFinPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cambiar Sector'),
          content: Text('¿Estás seguro que deseas finalizar el trabajo en este sector y seleccionar otro?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo
                
                // Navegar a la pantalla de selección de ubicación
                // Pasar el encargado requerido
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationSelectionScreen(
                      encargado: widget.encargado,  // Pasar el encargado desde el widget actual
                    ),
                  ),
                );
              },
              child: Text('Confirmar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cerrar Sesión'),
          content: Text('¿Estás seguro que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context, 
                  '/', 
                  (route) => false,
                );
              },
              child: Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey[600]),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo FieldOps
              Container(
                height: 80,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              SizedBox(height: 30),
              
              // Información del reporte
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reporte',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Distrito: ${widget.distrito}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      'Zona: ${widget.zona}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    Text(
                      'Sector: ${widget.sector}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Botón FIN
              Container(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _onFinPressed,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'FIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 40),
              
              // Botones principales
              Row(
                children: [
                  Expanded(
                    child: _buildMainButton(
                      'Poste',
                      Color(0xFF1565C0),
                      _onPostePressed,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: _buildMainButton(
                      'Predio',
                      Color(0xFF1565C0),
                      _onPredioPressed,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Botón Pendientes
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onPendientesPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Color(0xFF1565C0), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Pendientes',
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              Spacer(),
              
              // Información del encargado logueado
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: Color(0xFF1565C0)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.encargado['nombre'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'DNI: ${widget.encargado['dni'] ?? ''}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            'Rol: Encargado',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMainButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}