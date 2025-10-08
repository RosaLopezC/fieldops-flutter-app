// lib/poste_electrico_form_screen.dart
import 'poste_electrico_step2_screen.dart';
import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteElectricoFormScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;

  const PosteElectricoFormScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  @override
  _PosteElectricoFormScreenState createState() => _PosteElectricoFormScreenState();
}

class _PosteElectricoFormScreenState extends State<PosteElectricoFormScreen> {
  // Estados de los botones de tensión
  String? selectedTension;
  
  // Controladores de texto
  final _cablesElectricosController = TextEditingController();
  final _cablesTelematicosController = TextEditingController();
  final _codigoController = TextEditingController();
  
  // Estado del switch de código
  bool _tienecodigo = false;
  
  // Listas de elementos seleccionados (acumulativos)
  List<String> elementosElectricosSeleccionados = [];
  List<String> elementosTelematicosSeleccionados = [];

  // Datos mock para los checkboxes
  final List<String> elementosElectricos = [
    'Medidor eléctrico',
    'Recloser con secciones',
    'Fuente de poder',
    'Sifón Eléctrico',
    'Bajada de Sifón'
  ];
  
  final List<String> elementosTelematicos = [
    'Caja NAP',
    'Caja de conexión eléctrica',
    'Brazo extensor',
    'Cable DPI',
    'Cajas terminal telefónica'
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
              title: Text('Elementos eléctricos'),
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
        List<String> tempSelected = List.from(elementosTelematicosSeleccionados);
        
        return StatefulBuilder(
          builder: (context, setStateModal) {
            return AlertDialog(
              title: Text('Elementos telemáticos'),
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
    if (selectedTension == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor seleccione una tensión')),
      );
      return;
    }

    // Navegamos al paso 2
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteElectricoStep2Screen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          tensionSeleccionada: selectedTension!,
        ),
      ),
    );
  }

  Widget _buildCodigoFieldUnified() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Código',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _tienecodigo
                    ? TextFormField(
                        controller: _codigoController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ingrese código',
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(fontSize: 16),
                      )
                    : Text(
                        'ND',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
              ),
              SizedBox(width: 8),
              Switch(
                value: _tienecodigo,
                onChanged: (value) {
                  setState(() {
                    _tienecodigo = value;
                    if (!value) {
                      _codigoController.clear();
                    }
                  });
                },
                activeColor: Color(0xFFFF6B00),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownFieldUnified(
    String label,
    String? displayText, {
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    displayText ?? 'Seleccionar elementos',
                    style: TextStyle(
                      fontSize: 16,
                      color: displayText != null ? Colors.black : Colors.grey[500],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey[600],
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
        title: 'Poste Eléctrico - Reporte',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Resumen del proyecto unificado
              ProjectSummaryCard(
                tipoPoste: 'Poste Eléctrico',
                distrito: widget.distrito,
                zona: widget.zona,
                sector: widget.sector,
              ),
              
              SizedBox(height: 30),
              
              // Tensión usando OptionsSelector
              OptionsSelector(
                title: 'Tensión',
                options: ['BT', 'MT', 'AT'],
                selectedValue: selectedTension,
                onSelect: (value) => setState(() => selectedTension = value),
              ),
              
              SizedBox(height: 30),
              
              // Cables eléctricos
              CustomTextField(
                label: 'Cables eléctricos',
                controller: _cablesElectricosController,
                keyboardType: TextInputType.number,
                hintText: 'Ingrese número de cables',
              ),
              
              SizedBox(height: 20),
              
              // Cables telemáticos
              CustomTextField(
                label: 'Cables telemáticos',
                controller: _cablesTelematicosController,
                keyboardType: TextInputType.number,
                hintText: 'Ingrese número de cables',
              ),
              
              SizedBox(height: 20),
              
              // Código con switch unificado
              _buildCodigoFieldUnified(),
              
              SizedBox(height: 20),
              
              // Elementos eléctricos dropdown unificado
              _buildDropdownFieldUnified(
                'Elementos eléctricos',
                elementosElectricosSeleccionados.isEmpty 
                    ? null 
                    : elementosElectricosSeleccionados.join(', '),
                onTap: _showElementosElectricosModal,
              ),
              
              SizedBox(height: 20),
              
              // Elementos telemáticos dropdown unificado
              _buildDropdownFieldUnified(
                'Elementos telemáticos',
                elementosTelematicosSeleccionados.isEmpty 
                    ? null 
                    : elementosTelematicosSeleccionados.join(', '),
                onTap: _showElementosTelematicosModal,
              ),
              
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