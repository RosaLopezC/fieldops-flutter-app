// lib/poste_electrico_form_screen.dart
import 'poste_electrico_step2_screen.dart';
import 'package:flutter/material.dart';

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
        title: Container(
          height: 40,
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.launch, color: Color(0xFF1565C0)),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Poste Eléctrico',
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
              
              // Tensión
              Text(
                'Tensión',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),
              
              SizedBox(height: 10),
              
              // Botones de tensión
              Row(
                children: [
                  Expanded(child: _buildTensionButton('BT')),
                  SizedBox(width: 10),
                  Expanded(child: _buildTensionButton('MT')),
                  SizedBox(width: 10),
                  Expanded(child: _buildTensionButton('AT')),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Cables eléctricos
              _buildNumberField('Cables eléctricos', _cablesElectricosController),
              
              SizedBox(height: 15),
              
              // Cables telemáticos
              _buildNumberField('Cables telemáticos', _cablesTelematicosController),
              
              SizedBox(height: 20),
              
              // Código con switch
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Código',
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
                          activeColor: Color(0xFF1565C0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Elementos eléctricos dropdown
              _buildDropdownField(
                'Elementos eléctricos',
                elementosElectricosSeleccionados.isEmpty 
                    ? null 
                    : elementosElectricosSeleccionados.join(', '),
                onTap: _showElementosElectricosModal,
              ),
              
              SizedBox(height: 15),
              
              // Elementos telemáticos dropdown
              _buildDropdownField(
                'Elementos telemáticos',
                elementosTelematicosSeleccionados.isEmpty 
                    ? null 
                    : elementosTelematicosSeleccionados.join(', '),
                onTap: _showElementosTelematicosModal,
              ),
              
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

  Widget _buildTensionButton(String text) {
    bool isSelected = selectedTension == text;
    return Container(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedTension = text;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF1565C0) : Color(0xFFE3F2FD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
              hintText: '',
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(
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
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 5),
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
                    displayText ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: displayText != null ? Colors.grey[700] : Colors.grey[500],
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

  TextStyle _infoTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );
  }
}