import 'package:flutter/material.dart';
import 'poste_electrico_gps_screen.dart';
import 'widgets/custom_app_bar.dart';

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
  // Estados de selección
  String? estadoSeleccionado;
  String? inclinacionSeleccionada;
  
  // Controladores de texto
  final _alturaController = TextEditingController();
  
  // Estado del switch de propietario
  bool _tienePropietario = true;
  String? propietarioSeleccionado = 'SEAL';
  
  // Opciones para el dropdown/modal
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
              
              // Estado
              _buildSectionTitle('Estado'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableButton('Pequeñas grietas', estadoSeleccionado, (value) {
                      setState(() { estadoSeleccionado = value; });
                    })
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildSelectableButton('Grandes grietas /\ncorroído', estadoSeleccionado, (value) {
                      setState(() { estadoSeleccionado = value; });
                    })
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Inclinación
              _buildSectionTitle('Inclinación'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildSelectableButton('Ligera inclinación', inclinacionSeleccionada, (value) {
                      setState(() { inclinacionSeleccionada = value; });
                    })
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildSelectableButton('Muy inclinado', inclinacionSeleccionada, (value) {
                      setState(() { inclinacionSeleccionada = value; });
                    })
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Altura
              _buildNumberField('Altura', _alturaController),
              
              SizedBox(height: 20),
              
              // Propietario con switch
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Propietario',
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
                          child: _tienePropietario
                              ? GestureDetector(
                                  onTap: _showPropietariosModal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        propietarioSeleccionado ?? 'Seleccionar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.grey[600],
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  'No asignado',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                        ),
                        Switch(
                          value: _tienePropietario,
                          onChanged: (value) {
                            setState(() {
                              _tienePropietario = value;
                              if (!value) {
                                propietarioSeleccionado = null;
                              } else {
                                propietarioSeleccionado = 'SEAL'; // Valor por defecto
                              }
                            });
                          },
                          activeColor: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ],
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
      height: 50,
      child: ElevatedButton(
        onPressed: () => onPressed(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF1565C0),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
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

  TextStyle _infoTextStyle() {
    return TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );
  }
}