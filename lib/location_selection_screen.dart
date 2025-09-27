// lib/location_selection_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  String? selectedDistrito;
  String? selectedZona;
  String? selectedSector;
  
  List<String> availableZonas = [];
  List<String> availableSectores = [];

  // Datos mock para los dropdowns
  final List<String> distritos = [
    'SJL PROD PRUEBA 003',
    'LIMA CENTRO',
    'CALLAO NORTE',
    'SAN BORJA SUR'
  ];
  
  final Map<String, List<String>> zonasPorDistrito = {
    'SJL PROD PRUEBA 003': ['201', '202', '203', '204'],
    'LIMA CENTRO': ['101', '102', '103'],
    'CALLAO NORTE': ['301', '302'],
    'SAN BORJA SUR': ['401', '402', '403']
  };
  
  final Map<String, List<String>> sectoresPorZona = {
    '201': ['201501', '201502', '201503'],
    '202': ['202501', '202502'],
    '203': ['203501', '203502', '203503', '203504'],
    '204': ['204501', '204502'],
    '101': ['101501', '101502'],
    '102': ['102501', '102502', '102503'],
    '103': ['103501'],
    '301': ['301501', '301502'],
    '302': ['302501'],
    '401': ['401501', '401502'],
    '402': ['402501', '402502', '402503'],
    '403': ['403501']
  };

  void _onDistritoChanged(String? distrito) {
    setState(() {
      selectedDistrito = distrito;
      selectedZona = null;
      selectedSector = null;
      availableZonas = zonasPorDistrito[distrito] ?? [];
      availableSectores = [];
    });
  }

  void _onZonaChanged(String? zona) {
    setState(() {
      selectedZona = zona;
      selectedSector = null;
      availableSectores = sectoresPorZona[zona] ?? [];
    });
  }

  void _onSectorChanged(String? sector) {
    setState(() {
      selectedSector = sector;
    });
  }

  bool get _canProceed {
    return selectedDistrito != null && 
           selectedZona != null && 
           selectedSector != null;
  }

  void _iniciarSesion() {
    if (_canProceed) {
      // Navegamos a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            distrito: selectedDistrito!,
            zona: selectedZona!,
            sector: selectedSector!,
          ),
        ),
      );
    }
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
              SizedBox(height: 40),
              
              // Logo FieldOps
              Container(
                height: 100,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              SizedBox(height: 40),
              
              // Dropdown Distrito
              Container(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: selectedDistrito,
                  hint: Text('Distrito'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: distritos.map((String distrito) {
                    return DropdownMenuItem<String>(
                      value: distrito,
                      child: Text(distrito),
                    );
                  }).toList(),
                  onChanged: _onDistritoChanged,
                ),
              ),
              
              SizedBox(height: 20),
              
              // Dropdown Zona
              Container(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: selectedZona,
                  hint: Text('Zona'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: selectedDistrito != null ? Color(0xFFF5F5F5) : Color(0xFFE0E0E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: availableZonas.map((String zona) {
                    return DropdownMenuItem<String>(
                      value: zona,
                      child: Text(zona),
                    );
                  }).toList(),
                  onChanged: selectedDistrito != null ? _onZonaChanged : null,
                ),
              ),
              
              SizedBox(height: 20),
              
              // Dropdown Sector
              Container(
                width: double.infinity,
                child: DropdownButtonFormField<String>(
                  value: selectedSector,
                  hint: Text('Sector'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: selectedZona != null ? Color(0xFFF5F5F5) : Color(0xFFE0E0E0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: availableSectores.map((String sector) {
                    return DropdownMenuItem<String>(
                      value: sector,
                      child: Text(sector),
                    );
                  }).toList(),
                  onChanged: selectedZona != null ? _onSectorChanged : null,
                ),
              ),
              
              SizedBox(height: 60),
              
              // Botón Iniciar Sesión
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canProceed ? _iniciarSesion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canProceed ? Color(0xFF1565C0) : Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
}