// lib/screens/field_worker/poste_telematico_step3_screen.dart

import 'package:flutter/material.dart';
import 'poste_telematico_step4_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteTelematicoStep3Screen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final int numCablesTelematicos;
  final int numCablesElectricos;
  final String codigo;
  final List<String> elementosElectricos;
  final List<String> elementosTelematicos;
  final String tipoEstructuraSimple;
  final String tipoEstructuraMaterial;
  final String zonaInstalacion;
  final String resistencia;

  const PosteTelematicoStep3Screen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.numCablesTelematicos,
    required this.numCablesElectricos,
    required this.codigo,
    required this.elementosElectricos,
    required this.elementosTelematicos,
    required this.tipoEstructuraSimple,
    required this.tipoEstructuraMaterial,
    required this.zonaInstalacion,
    required this.resistencia,
  }) : super(key: key);

  @override
  _PosteTelematicoStep3ScreenState createState() =>
      _PosteTelematicoStep3ScreenState();
}

class _PosteTelematicoStep3ScreenState
    extends State<PosteTelematicoStep3Screen> {
  // Estado
  String? _estadoSeleccionado;

  // Inclinación
  String? _inclinacionSeleccionada;

  // Altura
  final _alturaController = TextEditingController();

  // Propietario
  String? _propietarioSeleccionado;
  bool _tienePropietario = false;

  // Lista de propietarios
  final List<String> _propietarios = [
    'CLARO',
    'TELEFÓNICA',
    'MUNICIPALIDAD',
    'TELMEX',
    'BITEL',
    'ENTEL',
  ];

  @override
  void dispose() {
    _alturaController.dispose();
    super.dispose();
  }

  void _showPropietariosModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String? tempSelected = _propietarioSeleccionado;

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Propietarios',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ..._propietarios.map((propietario) {
                      bool isSelected = tempSelected == propietario;
                      return RadioListTile<String>(
                        title: Text(propietario),
                        value: propietario,
                        groupValue: tempSelected,
                        activeColor: Color(0xFF1565C0),
                        onChanged: (String? value) {
                          setStateModal(() {
                            tempSelected = value;
                          });
                        },
                      );
                    }).toList(),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancelar'),
                        ),
                        SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _propietarioSeleccionado = tempSelected;
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSiguientePressed() {
    // Validaciones
    if (_estadoSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione el estado del poste')),
      );
      return;
    }

    if (_inclinacionSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione la inclinación')),
      );
      return;
    }

    if (_alturaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor ingrese la altura')),
      );
      return;
    }

    // Si el switch de propietario está activo, debe seleccionar uno
    if (_tienePropietario && _propietarioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione un propietario')),
      );
      return;
    }

    // Navegar al paso 4 (GPS y fotos) con TODOS los datos
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteTelematicoStep4Screen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          numCablesTelematicos: widget.numCablesTelematicos,
          numCablesElectricos: widget.numCablesElectricos,
          codigo: widget.codigo,
          elementosElectricos: widget.elementosElectricos,
          elementosTelematicos: widget.elementosTelematicos,
          tipoEstructuraSimple: widget.tipoEstructuraSimple,
          tipoEstructuraMaterial: widget.tipoEstructuraMaterial,
          zonaInstalacion: widget.zonaInstalacion,
          resistencia: widget.resistencia,
          estado: _estadoSeleccionado ?? '',
          inclinacion: _inclinacionSeleccionada ?? '',
          altura: _alturaController.text,
          propietario: _tienePropietario ? (_propietarioSeleccionado ?? 'No asignado') : 'No asignado',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Poste Telemático - Detalles',
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

              // Estado
              OptionsSelector(
                title: 'Estado',
                options: ['Pequeñas grietas', 'Grandes grietas / corroído'],
                selectedValue: _estadoSeleccionado,
                onSelect: (value) => setState(() => _estadoSeleccionado = value),
              ),

              SizedBox(height: 30),

              // Inclinación
              OptionsSelector(
                title: 'Inclinación',
                options: ['Ligera inclinación', 'Muy inclinado'],
                selectedValue: _inclinacionSeleccionada,
                onSelect: (value) => setState(() => _inclinacionSeleccionada = value),
              ),

              SizedBox(height: 30),

              // Altura
              CustomTextField(
                label: 'Altura',
                controller: _alturaController,
                keyboardType: TextInputType.number,
                hintText: 'Ingrese altura',
              ),

              SizedBox(height: 30),

              // Propietario con switch
              _buildPropietarioFieldUnified(),

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

  // Campo propietario unificado con switch
  Widget _buildPropietarioFieldUnified() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Propietario',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: _tienePropietario ? _showPropietariosModal : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _tienePropietario
                        ? (_propietarioSeleccionado ?? 'Seleccionar propietario')
                        : 'No asignado',
                    style: TextStyle(
                      fontSize: 16,
                      color: _tienePropietario 
                          ? (_propietarioSeleccionado != null ? Colors.black : Colors.grey[500])
                          : Colors.grey[500],
                    ),
                  ),
                ),
                if (_tienePropietario)
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                SizedBox(width: 8),
                Switch(
                  value: _tienePropietario,
                  onChanged: (value) {
                    setState(() {
                      _tienePropietario = value;
                      if (!value) {
                        _propietarioSeleccionado = null;
                      }
                    });
                  },
                  activeColor: Color(0xFFFF6B00),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}