// lib/poste_selection_screen.dart
import 'package:flutter/material.dart';
import 'poste_electrico_form_screen.dart';

class PosteSelectionScreen extends StatelessWidget {
  final String distrito;
  final String zona;
  final String sector;

  const PosteSelectionScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  void _onPosteElectricoPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteElectricoFormScreen(
          distrito: distrito,
          zona: zona,
          sector: sector,
        ),
      ),
    );
  }

  void _onPosteTelematicPressed(BuildContext context) {
    // Navegará al formulario de Poste Telemático
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navegando a Formulario de Poste Telemático')),
    );
    // Navigator.push(context, MaterialPageRoute(builder: (context) => PosteTelematicFormScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.launch, color: Color(0xFF1565C0)),
            onPressed: () {
              // Acción del botón de la esquina superior derecha
            },
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
                height: 60,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              SizedBox(height: 30),
              
              // Título
              Text(
                'Poste',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Información de ubicación
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Distrito: $distrito',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Zona: $zona',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Sector: $sector',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 60),
              
              // Botón Poste Eléctrico
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _onPosteElectricoPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Poste Eléctrico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Botón Poste Telemático
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _onPosteTelematicPressed(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Poste Telemático',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}