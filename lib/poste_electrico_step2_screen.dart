// lib/poste_electrico_step2_screen.dart
import 'package:flutter/material.dart';
import 'poste_electrico_step3_screen.dart'; // <-- Agrega esto
import 'widgets/custom_app_bar.dart';

class PosteElectricoStep2Screen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final String tensionSeleccionada;

  const PosteElectricoStep2Screen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.tensionSeleccionada,
  }) : super(key: key);

  @override
  _PosteElectricoStep2ScreenState createState() => _PosteElectricoStep2ScreenState();
}

class _PosteElectricoStep2ScreenState extends State<PosteElectricoStep2Screen> {
  // Estados de selección
  String? tipoEstructura1; // Simple/Doble/Triple
  String? tipoEstructura2; // Concreto/Madera/Metal/Fibra
  String? zonaInstalacion1; // Tierra/Jardín/Rocoso/Vereda
  String? zonaInstalacion2; // 100/200/250/300/400/500/ND/OTRO
  
  // Campo de texto para "OTRO"
  final _resistenciaController = TextEditingController();
  bool _mostrarCampoOtro = false;

  @override
  void dispose() {
    _resistenciaController.dispose();
    super.dispose();
  }

  void _onZonaInstalacion2Changed(String value) {
    setState(() {
      zonaInstalacion2 = value;
      _mostrarCampoOtro = value == 'OTRO';
      if (!_mostrarCampoOtro) {
        _resistenciaController.clear();
      }
    });
  }

  void _onSiguientePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteElectricoStep3Screen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          tensionSeleccionada: widget.tensionSeleccionada,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Poste Eléctrico - Estructura',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título con tensión
              Text(
                'Poste Eléctrico ${widget.tensionSeleccionada}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1565C0),
                ),
              ),
              
              SizedBox(height: 10),
              
              // Información de ubicación
              Text('Distrito: ${widget.distrito}', style: _infoTextStyle()),
              Text('Zona: ${widget.zona}', style: _infoTextStyle()),
              Text('Sector: ${widget.sector}', style: _infoTextStyle()),
              
              SizedBox(height: 20),
              
              // Tipo de estructura (Simple/Doble/Triple)
              _buildSectionTitle('Tipo de estructura'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _buildSelectableButton('Simple', tipoEstructura1, (value) {
                    setState(() { tipoEstructura1 = value; });
                  })),
                  SizedBox(width: 10),
                  Expanded(child: _buildSelectableButton('Doble', tipoEstructura1, (value) {
                    setState(() { tipoEstructura1 = value; });
                  })),
                  SizedBox(width: 10),
                  Expanded(child: _buildSelectableButton('Triple', tipoEstructura1, (value) {
                    setState(() { tipoEstructura1 = value; });
                  })),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Tipo de estructura (Material)
              _buildSectionTitle('Tipo de estructura'),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildSelectableButton('Concreto', tipoEstructura2, (value) {
                    setState(() { tipoEstructura2 = value; });
                  }),
                  _buildSelectableButton('Madera', tipoEstructura2, (value) {
                    setState(() { tipoEstructura2 = value; });
                  }),
                  _buildSelectableButton('Metal', tipoEstructura2, (value) {
                    setState(() { tipoEstructura2 = value; });
                  }),
                  _buildSelectableButton('Fibra', tipoEstructura2, (value) {
                    setState(() { tipoEstructura2 = value; });
                  }),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Zona de instalación (Ubicación)
              _buildSectionTitle('Zona de instalación'),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildSelectableButton('Tierra', zonaInstalacion1, (value) {
                    setState(() { zonaInstalacion1 = value; });
                  }),
                  _buildSelectableButton('Jardín', zonaInstalacion1, (value) {
                    setState(() { zonaInstalacion1 = value; });
                  }),
                  _buildSelectableButton('Rocoso', zonaInstalacion1, (value) {
                    setState(() { zonaInstalacion1 = value; });
                  }),
                  _buildSelectableButton('Vereda', zonaInstalacion1, (value) {
                    setState(() { zonaInstalacion1 = value; });
                  }),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Zona de instalación (Resistencia)
              _buildSectionTitle('Zona de instalación'),
              SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildSelectableButton('100', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('200', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('250', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('300', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('400', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('500', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('ND', zonaInstalacion2, _onZonaInstalacion2Changed),
                  _buildSelectableButton('OTRO', zonaInstalacion2, _onZonaInstalacion2Changed),
                ],
              ),
              
              // Campo para "OTRO"
              if (_mostrarCampoOtro) ...[
                SizedBox(height: 15),
                _buildNumberField('Especifica resistencia', _resistenciaController),
              ],
              
              SizedBox(height: 40),
              
              // Botón Siguiente
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _onSiguientePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Siguiente',
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1565C0),
      ),
    );
  }

  Widget _buildSelectableButton(String text, String? selectedValue, Function(String) onPressed) {
    bool isSelected = selectedValue == text;
    
    return Container(
      height: 40,
      constraints: BoxConstraints(minWidth: 80),
      child: ElevatedButton(
        onPressed: () => onPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF1565C0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '250',
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  TextStyle _infoTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );
  }
}