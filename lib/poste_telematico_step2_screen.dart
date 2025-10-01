// lib/screens/field_worker/poste_telematico_step2_screen.dart

import 'package:flutter/material.dart';
import 'poste_telematico_step3_screen.dart';

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
  _PosteTelematicoStep2ScreenState createState() =>
      _PosteTelematicoStep2ScreenState();
}

class _PosteTelematicoStep2ScreenState
    extends State<PosteTelematicoStep2Screen> {
  // Tipo de estructura (primera fila)
  String? _tipoEstructuraSimple;

  // Tipo de estructura (segunda fila)
  String? _tipoEstructuraMaterial;

  // Zona de instalación (primera sección)
  String? _zonaInstalacion;

  // Resistencia (segunda sección "Zona de instalación")
  String? _resistenciaSeleccionada;

  // Controller para input personalizado
  final _resistenciaOtroController = TextEditingController();

  @override
  void dispose() {
    _resistenciaOtroController.dispose();
    super.dispose();
  }

  void _onSiguientePressed() {
    // Validaciones
    if (_tipoEstructuraSimple == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor seleccione el tipo de estructura (Simple/Doble/Triple)')),
      );
      return;
    }

    if (_tipoEstructuraMaterial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Por favor seleccione el material de la estructura')),
      );
      return;
    }

    if (_zonaInstalacion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione la zona de instalación')),
      );
      return;
    }

    if (_resistenciaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione la resistencia')),
      );
      return;
    }

    // Si seleccionó "OTRO" debe ingresar un valor
    if (_resistenciaSeleccionada == 'OTRO' &&
        _resistenciaOtroController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingrese la resistencia personalizada')),
      );
      return;
    }

    // Navegar al paso 3
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
      tipoEstructuraSimple: _tipoEstructuraSimple ?? '',
      tipoEstructuraMaterial: _tipoEstructuraMaterial ?? '',
      zonaInstalacion: _zonaInstalacion ?? '',
      resistencia: _resistenciaSeleccionada ?? '',
    ),
  ),
);
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
        title: Text(
          'Poste Telemático - Estructura',
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tipo de estructura (primera fila)
              Text(
                'Tipo de estructura',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),
              SizedBox(height: 10),
              _buildOptionsRow(
                ['Simple', 'Doble', 'Triple'],
                _tipoEstructuraSimple,
                (value) => setState(() => _tipoEstructuraSimple = value),
              ),

              SizedBox(height: 20),

              // Tipo de estructura (segunda fila)
              _buildOptionsRow(
                ['Madera', 'Concreto', 'Metal', 'Plástico'],
                _tipoEstructuraMaterial,
                (value) => setState(() => _tipoEstructuraMaterial = value),
              ),

              SizedBox(height: 30),

              // Zona de instalación (primera sección)
              Text(
                'Zona de instalación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),
              SizedBox(height: 10),
              _buildOptionsRow(
                ['Rural', 'Urbana'],
                _zonaInstalacion,
                (value) => setState(() => _zonaInstalacion = value),
              ),

              SizedBox(height: 30),

              // Resistencia (segunda sección)
              Text(
                'Resistencia',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),
              SizedBox(height: 10),
              _buildResistenciaSection(),

              SizedBox(height: 30),

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

  Widget _buildOptionsRow(List<String> options, String? selectedValue, Function(String) onSelect) {
    return Container(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (context, index) => SizedBox(width: 10),
        itemBuilder: (context, index) {
          final option = options[index];
          final isSelected = selectedValue == option;
          
          return InkWell(
            onTap: () => onSelect(option),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF1565C0) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Color(0xFF1565C0) : Colors.grey[300]!,
                ),
              ),
              child: Center(
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResistenciaSection() {
    final resistencias = ['500N', '1000N', '1500N', 'OTRO'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: resistencias.length,
            separatorBuilder: (context, index) => SizedBox(width: 10),
            itemBuilder: (context, index) {
              final resistencia = resistencias[index];
              final isSelected = _resistenciaSeleccionada == resistencia;
              
              return InkWell(
                onTap: () => setState(() => _resistenciaSeleccionada = resistencia),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF1565C0) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Color(0xFF1565C0) : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      resistencia,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[600],
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_resistenciaSeleccionada == 'OTRO') ...[
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _resistenciaOtroController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Ingrese otro valor',
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ],
    );
  }
}