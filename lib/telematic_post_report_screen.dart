// lib/telematic_post_report_screen.dart

import 'package:flutter/material.dart';
import 'poste_telematico_step2_screen.dart';
import 'widgets/custom_app_bar.dart';  // Agregar esta línea
import 'widgets/shared_components.dart';

class TelematicPostReportScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;

  const TelematicPostReportScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  @override
  _TelematicPostReportScreenState createState() =>
      _TelematicPostReportScreenState();
}

class _TelematicPostReportScreenState
    extends State<TelematicPostReportScreen> {
  // Controladores de texto
  final _cablesElectricosController = TextEditingController();
  final _cablesTelematicosController = TextEditingController();
  final _codigoController = TextEditingController();

  // Estados de los switches
  bool _addElectricCables = false;
  bool _tienecodigo = false;

  // Listas de elementos seleccionados (acumulativos)
  List<String> elementosElectricosSeleccionados = [];
  List<String> elementosTelematicosSeleccionados = [];

  // Actualiza las listas de elementos con los mismos que usa el poste eléctrico
  final List<String> elementosElectricos = [
    'Transformador',
    'Tablero de distribución',
    'Luminaria',
    'Medidor eléctrico',
    'Pararrayo',
    'Bajada a tierra',
    'Cut Out',
  ];

  final List<String> elementosTelematicos = [
    'Caja NAP',
    'Caja FAT',
    'Caja terminal telefónica',
    'Cable DPI',
    'Brazo extensor',
    'Caja de conexión eléctrica',
  ];

  @override
  void dispose() {
    _cablesElectricosController.dispose();
    _cablesTelematicosController.dispose();
    _codigoController.dispose();
    super.dispose();
  }

  void _showElementosElectricosModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelected = List.from(elementosElectricosSeleccionados);

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text(
                'Elementos eléctricos',
                style: TextStyle(color: Color(0xFF1565C0)),
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: elementosElectricos.map((elemento) {
                    bool isSelected = tempSelected.contains(elemento);
                    return CheckboxListTile(
                      title: Text(elemento),
                      value: isSelected,
                      activeColor: Color(0xFF1565C0),
                      onChanged: (bool? value) {
                        setStateModal(() {
                          if (value == true) {
                            tempSelected.add(elemento);
                          } else {
                            tempSelected.remove(elemento);
                          }
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
                      elementosElectricosSeleccionados = tempSelected;
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

  void _showElementosTelematicosModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List<String> tempSelected =
            List.from(elementosTelematicosSeleccionados);

        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text(
                'Elementos telemáticos',
                style: TextStyle(color: Color(0xFF1565C0)),
              ),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: elementosTelematicos.map((elemento) {
                    bool isSelected = tempSelected.contains(elemento);
                    return CheckboxListTile(
                      title: Text(elemento),
                      value: isSelected,
                      activeColor: Color(0xFF1565C0),
                      onChanged: (bool? value) {
                        setStateModal(() {
                          if (value == true) {
                            tempSelected.add(elemento);
                          } else {
                            tempSelected.remove(elemento);
                          }
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
                      elementosTelematicosSeleccionados = tempSelected;
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
    // Validación básica
    if (_cablesTelematicosController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Por favor ingrese la cantidad de cables telemáticos')),
      );
      return;
    }

    // Navegamos al paso 2
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteTelematicoStep2Screen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          numCablesTelematicos:
              int.tryParse(_cablesTelematicosController.text) ?? 0,
          numCablesElectricos: _addElectricCables
              ? int.tryParse(_cablesElectricosController.text) ?? 0
              : 0,
          codigo: _tienecodigo ? _codigoController.text : 'ND',
          elementosElectricos: elementosElectricosSeleccionados,
          elementosTelematicos: elementosTelematicosSeleccionados,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Reporte de Poste Telemático',
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

              // Switch: Añadir cables eléctricos
              CustomSwitchRow(
                title: 'Añadir cables eléctricos',
                value: _addElectricCables,
                onChanged: (value) {
                  setState(() {
                    _addElectricCables = value;
                    if (!value) {
                      _cablesElectricosController.clear();
                      elementosElectricosSeleccionados.clear();
                    }
                  });
                },
              ),

              // Campo cables eléctricos (solo visible si switch está activo)
              if (_addElectricCables) ...[
                SizedBox(height: 15),
                CustomTextField(
                  label: 'Cables eléctricos',
                  controller: _cablesElectricosController,
                  keyboardType: TextInputType.number,
                  hintText: 'Ingrese cantidad',
                ),
                SizedBox(height: 15),
                // Campo Elementos eléctricos (dentro del if _addElectricCables)
                _buildDropdownField(
                  'Elementos eléctricos',
                  elementosElectricosSeleccionados,
                  onTap: _showElementosElectricosModal,
                ),
              ],

              SizedBox(height: 15),

              // Cables telemáticos (siempre visible)
              CustomTextField(
                label: 'Cables telemáticos',
                controller: _cablesTelematicosController,
                keyboardType: TextInputType.number,
                hintText: 'Ingrese cantidad',
              ),

              SizedBox(height: 15),

              // Elementos telemáticos (siempre visible)
              _buildDropdownField(
                'Elementos telemáticos',
                elementosTelematicosSeleccionados,
                onTap: _showElementosTelematicosModal,
              ),

              SizedBox(height: 15),

              // Campo código con switch integrado
              _buildCodigoField(),

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

  // Switch Row con título a la izquierda
  Widget _buildSwitchRow(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1565C0),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF6B00), // Color naranja consistente
        ),
      ],
    );
  }

  // Campo estático (no editable, solo muestra valor)
  Widget _buildStaticField(String label, TextEditingController controller, {bool enabled = true}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Ingrese cantidad',
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // Método _buildCodigoField() actualizado
  Widget _buildCodigoField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Código',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codigoController,
                  enabled: _tienecodigo,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _tienecodigo ? 'Ingrese código' : 'ND',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(
                    fontSize: 16,
                    color: _tienecodigo ? Colors.black : Colors.grey[500],
                  ),
                  // Mostrar ND cuando está desactivado
                  readOnly: !_tienecodigo,
                ),
              ),
              Switch(
                value: _tienecodigo,
                onChanged: (value) {
                  setState(() {
                    _tienecodigo = value;
                    if (!value) {
                      _codigoController.text = 'ND'; // Establecer ND cuando se desactiva
                    } else {
                      _codigoController.clear(); // Limpiar cuando se activa
                    }
                  });
                },
                activeColor: Color(0xFFFF6B00),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Método _buildDropdownField() actualizado para mostrar elementos seleccionados
  Widget _buildDropdownField(String label, List<String> selectedItems, {VoidCallback? onTap}) {
    String displayText;
    
    if (selectedItems.isEmpty) {
      displayText = 'Seleccionar elementos';
    } else {
      // Mostrar todos los elementos seleccionados separados por coma
      displayText = selectedItems.join(', ');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedItems.isEmpty ? Colors.grey[500] : Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2, // Permitir 2 líneas para mostrar más elementos
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _infoTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );
  }
}