// lib/screens/field_worker/poste_telematico_step2_screen.dart

import 'package:flutter/material.dart';
import 'poste_telematico_step3_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteTelematicoStep2Screen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final int numCablesTelematicos;
  final int numCablesElectricos;
  final String codigo;
  final List<String> elementosElectricos;
  final List<String> elementosTelematicos;

  const PosteTelematicoStep2Screen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.numCablesTelematicos,
    required this.numCablesElectricos,
    required this.codigo,
    required this.elementosElectricos,
    required this.elementosTelematicos,
  }) : super(key: key);

  @override
  _PosteTelematicoStep2ScreenState createState() => _PosteTelematicoStep2ScreenState();
}

class _PosteTelematicoStep2ScreenState extends State<PosteTelematicoStep2Screen> {
  String? _tipoEstructuraSimple;
  String? _tipoEstructuraMaterial;
  String? _zonaInstalacion;
  String? _resistenciaSeleccionada;
  final TextEditingController _resistenciaOtroController = TextEditingController();

  @override
  void dispose() {
    _resistenciaOtroController.dispose();
    super.dispose();
  }

  void _onSiguientePressed() {
    if (_tipoEstructuraSimple == null || _tipoEstructuraMaterial == null || 
        _zonaInstalacion == null || _resistenciaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Validar que si seleccionó "OTRO", debe llenar el campo
    if (_resistenciaSeleccionada == 'OTRO' && _resistenciaOtroController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor especifique el valor de resistencia')),
      );
      return;
    }

    String resistenciaFinal = _resistenciaSeleccionada == 'OTRO' 
        ? _resistenciaOtroController.text.trim()
        : _resistenciaSeleccionada!;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteTelematicoStep3Screen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          numCablesTelematicos: widget.numCablesTelematicos,
          numCablesElectricos: widget.numCablesElectricos,
          codigo: widget.codigo,
          elementosElectricos: widget.elementosElectricos,
          elementosTelematicos: widget.elementosTelematicos,
          tipoEstructuraSimple: _tipoEstructuraSimple!,
          tipoEstructuraMaterial: _tipoEstructuraMaterial!,
          zonaInstalacion: _zonaInstalacion!,
          resistencia: resistenciaFinal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Poste Telemático - Estructura',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Resumen del proyecto
              ProjectSummaryCard(
                tipoPoste: 'Poste Telemático',
                distrito: widget.distrito,
                zona: widget.zona,
                sector: widget.sector,
              ),

              SizedBox(height: 30),

              // Tipo de estructura (primera fila)
              OptionsSelector(
                title: 'Tipo de estructura',
                options: ['Simple', 'Doble', 'Triple'],
                selectedValue: _tipoEstructuraSimple,
                onSelect: (value) => setState(() => _tipoEstructuraSimple = value),
              ),

              SizedBox(height: 20),

              // Tipo de estructura (segunda fila)
              OptionsSelector(
                title: 'Tipo de Material',
                options: ['Madera', 'Concreto', 'Metal', 'Fibra'],
                selectedValue: _tipoEstructuraMaterial,
                onSelect: (value) => setState(() => _tipoEstructuraMaterial = value),
              ),

              SizedBox(height: 30),

              // Zona de instalación
              OptionsSelector(
                title: 'Zona de instalación',
                options: ['Tierra', 'Jardín', 'Rocoso', 'Vereda'],
                selectedValue: _zonaInstalacion,
                onSelect: (value) => setState(() => _zonaInstalacion = value),
              ),

              SizedBox(height: 30),

              // Resistencia
              _buildResistenciaSection(),

              SizedBox(height: 30),

              // Botón Siguiente
              CustomButton(
                text: 'Siguiente',
                onPressed: _onSiguientePressed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResistenciaSection() {
    final resistencias = ['100', '200', '250', '300', '400', '500', 'ND', 'OTRO'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resistencia',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1565C0),
          ),
        ),
        SizedBox(height: 10),
        
        // Primera fila: 100, 200, 250
        Row(
          children: [
            Expanded(child: _buildResistenciaButton('100')),
            SizedBox(width: 10),
            Expanded(child: _buildResistenciaButton('200')),
            SizedBox(width: 10),
            Expanded(child: _buildResistenciaButton('250')),
          ],
        ),
        
        SizedBox(height: 10),
        
        // Segunda fila: 300, 400, 500
        Row(
          children: [
            Expanded(child: _buildResistenciaButton('300')),
            SizedBox(width: 10),
            Expanded(child: _buildResistenciaButton('400')),
            SizedBox(width: 10),
            Expanded(child: _buildResistenciaButton('500')),
          ],
        ),
        
        SizedBox(height: 10),
        
        // Tercera fila: ND, OTRO
        Row(
          children: [
            Expanded(child: _buildResistenciaButton('ND')),
            SizedBox(width: 10),
            Expanded(child: _buildResistenciaButton('OTRO')),
            SizedBox(width: 10),
            Expanded(child: SizedBox()), // Espacio vacío
          ],
        ),
        
        if (_resistenciaSeleccionada == 'OTRO') ...[
          SizedBox(height: 15),
          CustomTextField(
            label: 'Especificar resistencia',
            controller: _resistenciaOtroController,
            hintText: 'Ingrese el valor de resistencia',
            keyboardType: TextInputType.number,
          ),
        ],
      ],
    );
  }

  Widget _buildResistenciaButton(String resistencia) {
    final isSelected = _resistenciaSeleccionada == resistencia;
    
    return Container(
      height: 50, // Aumentado de 45 a 50
      child: ElevatedButton(
        onPressed: () => setState(() => _resistenciaSeleccionada = resistencia),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Añadir padding
        ),
        child: Text(
          resistencia,
          textAlign: TextAlign.center, // Centrar el texto
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF1565C0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}