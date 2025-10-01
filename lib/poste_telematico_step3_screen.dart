// lib/screens/field_worker/poste_telematico_step3_screen.dart

import 'package:flutter/material.dart';
import 'poste_telematico_step4_screen.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              Text(
                'Poste Telemático',
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

              // ESTADO
              Text(
                'Estado',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      'Pequeñas grietas',
                      _estadoSeleccionado == 'Pequeñas grietas',
                      () {
                        setState(() {
                          _estadoSeleccionado = 'Pequeñas grietas';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildOptionButton(
                      'Grandes grietas / corroído',
                      _estadoSeleccionado == 'Grandes grietas / corroído',
                      () {
                        setState(() {
                          _estadoSeleccionado = 'Grandes grietas / corroído';
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // INCLINACIÓN
              Text(
                'Inclinación',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1565C0),
                ),
              ),

              SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      'Ligera inclinación',
                      _inclinacionSeleccionada == 'Ligera inclinación',
                      () {
                        setState(() {
                          _inclinacionSeleccionada = 'Ligera inclinación';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _buildOptionButton(
                      'Muy inclinado',
                      _inclinacionSeleccionada == 'Muy inclinado',
                      () {
                        setState(() {
                          _inclinacionSeleccionada = 'Muy inclinado';
                        });
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              // ALTURA (campo editable)
              _buildStaticField('Altura', _alturaController),

              SizedBox(height: 20),

              // PROPIETARIO con switch y dropdown
              _buildPropietarioField(),

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

  Widget _buildOptionButton(String text, bool isSelected, VoidCallback onTap) {
    return Container(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF1565C0),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Campo estático (solo muestra valor)
  Widget _buildStaticField(String label, TextEditingController controller) {
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
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Ingrese altura',
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

  // Campo propietario con dropdown y switch
  Widget _buildPropietarioField() {
    return GestureDetector(
      onTap: _tienePropietario ? _showPropietariosModal : null,
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
              'Propietario',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _tienePropietario
                        ? (_propietarioSeleccionado ?? '')
                        : 'No asignado',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
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