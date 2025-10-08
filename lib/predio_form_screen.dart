import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';
import 'predio_gps_screen.dart'; // Importar directamente la pantalla GPS

class PredioFormScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;

  const PredioFormScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  @override
  _PredioFormScreenState createState() => _PredioFormScreenState();
}

class _PredioFormScreenState extends State<PredioFormScreen> {
  // Switches
  bool _viaAccesoEnabled = true;
  bool _numeroViaEnabled = true;
  bool _numeroMunicipalEnabled = true;

  // Via de acceso seleccionada
  String? _tipoViaSeleccionada;
  
  // Controladores de texto
  final _nombreViaController = TextEditingController();
  final _numeroViaController = TextEditingController();
  final _numeroMunicipalController = TextEditingController();
  final _manzanaController = TextEditingController();
  final _loteController = TextEditingController();
  final _urbanizacionController = TextEditingController();
  final _centroController = TextEditingController();
  final _comercioController = TextEditingController();
  final _viviendaController = TextEditingController();
  final _denominacionController = TextEditingController();
  
  // Dropdown para actividad comercial
  String? _actividadComercial;
  final List<String> _opcionesActividad = [
    'Tienda',
    'Restaurante',
    'Farmacia',
    'Ferretería',
    'Panadería',
    'Otro'
  ];
  
  // Tipo de predio seleccionado
  String? _tipoPredioSeleccionado;
  
  // Opciones de vía (incluyendo Mz.)
  final List<String> _tiposVia = ['Av.', 'Jr.', 'Psj.', 'Ca.', 'Mz.'];

  @override
  void dispose() {
    _nombreViaController.dispose();
    _numeroViaController.dispose();
    _numeroMunicipalController.dispose();
    _manzanaController.dispose();
    _loteController.dispose();
    _urbanizacionController.dispose();
    _centroController.dispose();
    _comercioController.dispose();
    _viviendaController.dispose();
    _denominacionController.dispose();
    super.dispose();
  }

  void _onSiguientePressed() {
    // Validación básica
    if (_viaAccesoEnabled) {
      if (_tipoViaSeleccionada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seleccione un tipo de vía de acceso')),
        );
        return;
      }
      
      if (_nombreViaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingrese el nombre de la vía de acceso')),
        );
        return;
      }
      
      if (_numeroViaEnabled && _numeroViaController.text.isEmpty && _tipoViaSeleccionada != 'Mz.') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingrese el número de la vía')),
        );
        return;
      }
    }
    
    if (_tipoPredioSeleccionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Seleccione un tipo de predio')),
      );
      return;
    }
    
    // Validar actividad comercial si hay comercios
    if (_comercioController.text.isNotEmpty && 
        int.tryParse(_comercioController.text) != null && 
        int.parse(_comercioController.text) > 0) {
      if (_actividadComercial == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Seleccione una actividad comercial')),
        );
        return;
      }
      
      if (_denominacionController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ingrese la denominación del comercio')),
        );
        return;
      }
    }

    // Obtener el nombre legible del tipo de predio
    String tipoPredioLegible = '';
    switch (_tipoPredioSeleccionado) {
      case 'terreno_sin':
        tipoPredioLegible = 'Terreno sin construcción';
        break;
      case 'terreno_en':
        tipoPredioLegible = 'Terreno en construcción';
        break;
      case 'parque':
        tipoPredioLegible = 'Parque/Plaza';
        break;
      case 'losa':
        tipoPredioLegible = 'Losa';
        break;
      case 'iglesia':
        tipoPredioLegible = 'Iglesia';
        break;
      case 'entidad':
        tipoPredioLegible = 'Entidad del estado';
        break;
      default:
        tipoPredioLegible = 'Predio';
    }
    
    // Recopilar todos los datos del formulario
    final Map<String, dynamic> predioData = {
      'tipoPredio': tipoPredioLegible,
      'viaAcceso': _viaAccesoEnabled ? {
        'tipo': _tipoViaSeleccionada,
        'nombre': _nombreViaController.text,
        'numero': _tipoViaSeleccionada != 'Mz.' && _numeroViaEnabled ? 
          _numeroViaController.text : null,
        'sinNumero': _tipoViaSeleccionada != 'Mz.' && !_numeroViaEnabled,
      } : null,
      'numeroMunicipal': _numeroMunicipalEnabled ? _numeroMunicipalController.text : null,
      'sinNumeroMunicipal': !_numeroMunicipalEnabled,
      'manzana': _tipoViaSeleccionada == 'Mz.' ? _nombreViaController.text : _manzanaController.text,
      'lote': _loteController.text,
      'urbanizacion': _urbanizacionController.text,
      'centroPoblado': _centroController.text,
      'comercio': _comercioController.text.isEmpty ? 
        0 : int.tryParse(_comercioController.text) ?? 0,
      'actividadComercial': _actividadComercial,
      'denominacionComercio': _mostrarCamposComercio ? _denominacionController.text : null,
      'denominacionEspecial': (_tipoPredioSeleccionado == 'parque' || 
                              _tipoPredioSeleccionado == 'losa' || 
                              _tipoPredioSeleccionado == 'iglesia' ||
                              _tipoPredioSeleccionado == 'entidad') ? 
                              _denominacionController.text : null,
      'vivienda': _viviendaController.text.isEmpty ? 
        0 : int.tryParse(_viviendaController.text) ?? 0,
    };
    
    // Navegar directamente a la pantalla GPS
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PredioGpsScreen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          predioData: predioData,
        ),
      ),
    );
  }

  // Campo con switch sencillo
  Widget _buildSwitchField({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1565C0),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Color(0xFFFF6B00),
        ),
      ],
    );
  }
  
  // Mostrar/ocultar campos de actividad comercial
  bool get _mostrarCamposComercio {
    return _comercioController.text.isNotEmpty && 
           int.tryParse(_comercioController.text) != null && 
           int.parse(_comercioController.text) > 0;
  }

  // Verifica si es un tipo especial que no requiere datos de vivienda/comercio
  bool get _esTipoEspecial {
    List<String> tiposEspeciales = [
      'terreno_sin', 'parque', 'losa', 'iglesia', 'entidad'
    ];
    
    return _tipoPredioSeleccionado != null && 
           tiposEspeciales.contains(_tipoPredioSeleccionado);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Predio',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Resumen del proyecto unificado
              ProjectSummaryCard(
                tipoPoste: 'Predio',
                distrito: widget.distrito,
                zona: widget.zona,
                sector: widget.sector,
              ),
              
              SizedBox(height: 30),
              
              // Vía de acceso con switch
              _buildSwitchField(
                title: 'Vía de acceso',
                value: _viaAccesoEnabled,
                onChanged: (value) {
                  setState(() {
                    _viaAccesoEnabled = value;
                    if (!value) {
                      _tipoViaSeleccionada = null;
                      _nombreViaController.clear();
                      _numeroViaController.clear();
                    }
                  });
                },
              ),
              
              SizedBox(height: 10),
              
              // Botones de tipo de vía (incluyendo Mz.)
              if (_viaAccesoEnabled)
                Row(
                  children: _tiposVia.map((tipo) {
                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: tipo != _tiposVia.last ? 5 : 0),
                        child: ElevatedButton(
                          onPressed: () => setState(() => _tipoViaSeleccionada = tipo),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: _tipoViaSeleccionada == tipo 
                                ? Color(0xFF0D47A1) 
                                : Color(0xFF1565C0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            tipo,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              
              SizedBox(height: 10),
              
              // Campo para nombre de la vía
              if (_viaAccesoEnabled)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _nombreViaController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: _tipoViaSeleccionada == 'Mz.' 
                          ? 'Ingrese letra de la manzana (ej: A, B, J)' 
                          : 'Ingrese nombre de la vía (ej: Brasil, Junín)',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              
              SizedBox(height: 20),
              
              // Número de vía con switch
              if (_viaAccesoEnabled && _tipoViaSeleccionada != 'Mz.')
                _buildSwitchField(
                  title: 'N° de vía',
                  value: _numeroViaEnabled,
                  onChanged: (value) {
                    setState(() {
                      _numeroViaEnabled = value;
                      if (!value) {
                        _numeroViaController.clear();
                      }
                    });
                  },
                ),
              
              SizedBox(height: 10),
              
              // Campo para número de vía
              if (_viaAccesoEnabled && _tipoViaSeleccionada != 'Mz.')
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _numeroViaEnabled
                    ? TextFormField(
                        controller: _numeroViaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese número (ej: 156, 865)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      )
                    : Text(
                        'Sin número',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                ),
              
              // Campo para lote (si es Mz.)
              if (_viaAccesoEnabled && _tipoViaSeleccionada == 'Mz.')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Lote',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _loteController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese número de lote (ej: 8, 13)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              
              SizedBox(height: 20),
              
              // Número municipal con switch
              _buildSwitchField(
                title: 'N° Municipal',
                value: _numeroMunicipalEnabled,
                onChanged: (value) {
                  setState(() {
                    _numeroMunicipalEnabled = value;
                    if (!value) {
                      _numeroMunicipalController.clear();
                    }
                  });
                },
              ),
              
              SizedBox(height: 10),
              
              // Campo para número municipal
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _numeroMunicipalEnabled
                  ? TextFormField(
                      controller: _numeroMunicipalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Ingrese número municipal',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      style: TextStyle(fontSize: 16),
                    )
                  : Text(
                      'No tiene número municipal',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
              ),
              
              // Ocultar estos campos si seleccionó Mz.
              if (_tipoViaSeleccionada != 'Mz.') ...[
                SizedBox(height: 20),
                
                // Manzana (usando texto manual en lugar de CustomTextField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manzana',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _manzanaController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese letra de manzana (ej: A, B, J)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // Lote (usando texto manual en lugar de CustomTextField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lote',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _loteController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese número de lote (ej: 8, 13)',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
              
              SizedBox(height: 20),
              
              // Urbanización (usando texto manual en lugar de CustomTextField)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Urbanización',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _urbanizacionController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Ingrese nombre sin incluir "Urbanización" (ej: El Carmen)',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20),
              
              // Centro poblado (usando texto manual en lugar de CustomTextField)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Centro poblado/Asentamiento Urbano',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      controller: _centroController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Ingrese nombre sin incluir tipo (ej: Huarochirí)',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 30),
              
              // Características del predio
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Características del predio',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
              
              SizedBox(height: 15),
              
              // Tipo de predio - Organizado en filas manualmente
              _buildPredioTypeSelector(),
              
              SizedBox(height: 20),
              
              // Campo denominación para tipos especiales
              if (_tipoPredioSeleccionado == 'parque' || 
                  _tipoPredioSeleccionado == 'losa' || 
                  _tipoPredioSeleccionado == 'iglesia')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Denominación',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _denominacionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese nombre de la ${
                            _tipoPredioSeleccionado == 'parque' ? 'plaza/parque' : 
                            _tipoPredioSeleccionado == 'losa' ? 'losa deportiva' : 
                            'iglesia'
                          }',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              
              // Campo para entidades del estado
              if (_tipoPredioSeleccionado == 'entidad')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nombre de la Institución P.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _denominacionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese nombre de la institución pública',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              
              // Comercio (mostrar solo si no es tipo especial o es terreno en construcción)
              if (!_esTipoEspecial || _tipoPredioSeleccionado == 'terreno_en') ...[
                SizedBox(height: 20),
                
                // Comercio (usando texto manual en lugar de CustomTextField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comercio',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _comercioController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Ingrese cantidad de comercios',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        onChanged: (value) {
                          setState(() {}); // Actualizar UI cuando cambie el valor
                        },
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                
                // Campos adicionales para comercio
                if (_mostrarCamposComercio) ...[
                  SizedBox(height: 20),
                  
                  // Actividad comercial
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actividad',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _actividadComercial,
                            hint: Text('Seleccione actividad principal'),
                            isExpanded: true,
                            items: _opcionesActividad.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _actividadComercial = newValue;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Denominación del comercio
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Denominación del comercio',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextFormField(
                          controller: _denominacionController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Ingrese nombre del comercio principal',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                          ),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
              
              // Vivienda (mostrar solo si no es tipo especial o es terreno en construcción)
              if (!_esTipoEspecial || _tipoPredioSeleccionado == 'terreno_en') ...[
                SizedBox(height: 20),
                
                // Vivienda (usando texto manual en lugar de CustomTextField)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vivienda',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _viviendaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: _tipoPredioSeleccionado == 'terreno_en' 
                              ? 'Ingrese cantidad de niveles en construcción' 
                              : 'Ingrese cantidad de viviendas',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
              
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
  
  // Widget para organizar los botones de tipo de predio
  Widget _buildPredioTypeSelector() {
    final List<Map<String, dynamic>> predioTypes = [
      {'title': 'Terreno sin construcción', 'value': 'terreno_sin'},
      {'title': 'Terreno en construcción', 'value': 'terreno_en'},
      {'title': 'Parque/Plaza', 'value': 'parque'},
      {'title': 'Losa', 'value': 'losa'},
      {'title': 'Iglesia', 'value': 'iglesia'},
      {'title': 'Entidad del estado', 'value': 'entidad'},
    ];

    // Crear lista para organizar los botones en 2 filas
    List<Widget> rows = [];
    
    // Primera fila: primeros 3 botones
    rows.add(
      Row(
        children: predioTypes.sublist(0, 3).map((type) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: type != predioTypes[2] ? 5 : 0, bottom: 5),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _tipoPredioSeleccionado = type['value']);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                  backgroundColor: _tipoPredioSeleccionado == type['value'] 
                    ? Color(0xFF0D47A1) 
                    : Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  type['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
    
    // Segunda fila: últimos 3 botones
    rows.add(
      Row(
        children: predioTypes.sublist(3).map((type) {
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: type != predioTypes[5] ? 5 : 0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() => _tipoPredioSeleccionado = type['value']);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                  backgroundColor: _tipoPredioSeleccionado == type['value'] 
                    ? Color(0xFF0D47A1) 
                    : Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  type['title'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
    
    return Column(children: rows);
  }
}