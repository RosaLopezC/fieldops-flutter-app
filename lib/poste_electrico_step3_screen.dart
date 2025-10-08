import 'package:flutter/material.dart';
import 'poste_electrico_gps_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteElectricoStep3Screen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final String tensionSeleccionada;

  const PosteElectricoStep3Screen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.tensionSeleccionada,
  }) : super(key: key);

  @override
  _PosteElectricoStep3ScreenState createState() => _PosteElectricoStep3ScreenState();
}

class _PosteElectricoStep3ScreenState extends State<PosteElectricoStep3Screen> {
  // Estados de selección (mantener todos los datos existentes)
  String? estadoSeleccionado;
  String? inclinacionSeleccionada;
  
  // Controladores de texto
  final _alturaController = TextEditingController();
  
  // Estado del switch de propietario
  bool _tienePropietario = true;
  String? propietarioSeleccionado; // Sin valor por defecto
  
  // Opciones para el dropdown/modal (mantener las mismas)
  final List<String> propietarios = ['SEAL', 'REP', 'TES', 'EGA', 'YUR'];

  @override
  void dispose() {
    _alturaController.dispose();
    super.dispose();
  }

  void _showPropietariosModal() {
    String? tempSelected = propietarioSeleccionado;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text('Propietarios'),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: propietarios.map((propietario) {
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
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      propietarioSeleccionado = tempSelected;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onSiguientePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteElectricoGpsScreen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          tensionSeleccionada: widget.tensionSeleccionada,
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
                        ? (propietarioSeleccionado ?? 'Asignar propietario')
                        : 'No asignado',
                    style: TextStyle(
                      fontSize: 16,
                      color: _tienePropietario 
                          ? (propietarioSeleccionado != null ? Colors.black : Colors.grey[500])
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
                        propietarioSeleccionado = null;
                      }
                      // No asignar valor por defecto cuando se activa
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Poste Eléctrico - Detalles',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Resumen del proyecto unificado
              ProjectSummaryCard(
                tipoPoste: 'Poste Eléctrico ${widget.tensionSeleccionada}',
                distrito: widget.distrito,
                zona: widget.zona,
                sector: widget.sector,
              ),

              SizedBox(height: 30),

              // Estado usando OptionsSelector
              OptionsSelector(
                title: 'Estado',
                options: ['Pequeñas grietas', 'Grandes grietas / corroído'],
                selectedValue: estadoSeleccionado,
                onSelect: (value) => setState(() => estadoSeleccionado = value),
              ),

              SizedBox(height: 30),

              // Inclinación usando OptionsSelector
              OptionsSelector(
                title: 'Inclinación',
                options: ['Ligera inclinación', 'Muy inclinado'],
                selectedValue: inclinacionSeleccionada,
                onSelect: (value) => setState(() => inclinacionSeleccionada = value),
              ),

              SizedBox(height: 30),

              // Altura usando CustomTextField
              CustomTextField(
                label: 'Altura',
                controller: _alturaController,
                keyboardType: TextInputType.number,
                hintText: 'Ingrese altura',
              ),

              SizedBox(height: 30),

              // Propietario con switch unificado
              _buildPropietarioFieldUnified(),

              SizedBox(height: 30),

              // Botón Siguiente usando componente unificado
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
}