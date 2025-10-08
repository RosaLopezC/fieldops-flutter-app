import 'package:flutter/material.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';
import 'predio_form_screen.dart';

class PendientesScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;

  const PendientesScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  @override
  _PendientesScreenState createState() => _PendientesScreenState();
}

class _PendientesScreenState extends State<PendientesScreen> {
  // Lista simulada de reportes pendientes
  final List<Map<String, dynamic>> _reportesPendientes = [
    {
      'tipo': 'Poste Telemático',
      'fecha': '08/10/2023',
      'hora': '09:45',
      'ubicacion': 'Jr. Los Olivos 123',
      'progreso': 0.7,
      'estado': 'GPS Pendiente'
    },
    {
      'tipo': 'Predio',
      'fecha': '08/10/2023',
      'hora': '11:20',
      'ubicacion': 'Av. Brasil 456',
      'progreso': 0.3,
      'estado': 'Fotos Pendientes'
    },
    {
      'tipo': 'Poste Eléctrico',
      'fecha': '07/10/2023',
      'hora': '16:35',
      'ubicacion': 'Ca. San Martín 789',
      'progreso': 0.5,
      'estado': 'GPS Pendiente'
    },
    {
      'tipo': 'Predio',
      'fecha': '07/10/2023',
      'hora': '14:10',
      'ubicacion': 'Mz. B Lt. 15 Urb. El Carmen',
      'progreso': 0.8,
      'estado': 'Revisión Pendiente'
    },
  ];

  bool _isFiltering = false;
  String _selectedFilter = 'Todos';
  final List<String> _filterOptions = ['Todos', 'Poste Telemático', 'Poste Eléctrico', 'Predio'];

  List<Map<String, dynamic>> get _filteredReportes {
    if (_selectedFilter == 'Todos') {
      return _reportesPendientes;
    }
    return _reportesPendientes.where((reporte) => reporte['tipo'] == _selectedFilter).toList();
  }

  void _continuarReporte(Map<String, dynamic> reporte) {
    // Aquí implementaríamos la lógica para continuar con el reporte
    // según el tipo y el estado
    
    String mensaje = 'Continuando reporte ${reporte['tipo']} - ${reporte['estado']}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
    
    // Por ahora, solo navegamos al formulario de predio como ejemplo
    // y mostramos un mensaje para los otros tipos
    switch (reporte['tipo']) {
      case 'Predio':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredioFormScreen(
              distrito: widget.distrito,
              zona: widget.zona,
              sector: widget.sector,
            ),
          ),
        );
        break;
        
      case 'Poste Telemático':
        // Por ahora solo mostrar un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navegación a poste telemático no implementada')),
        );
        break;
        
      case 'Poste Eléctrico':
        // Por ahora solo mostrar un mensaje
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navegación a poste eléctrico no implementada')),
        );
        break;
    }
  }

  void _eliminarReporte(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Reporte'),
          content: Text('¿Está seguro que desea eliminar este reporte pendiente? Esta acción no se puede deshacer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _reportesPendientes.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Reporte eliminado')),
                );
              },
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Reportes Pendientes',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Información superior con resumen unificado
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen del proyecto unificado
                  ProjectSummaryCard(
                    tipoPoste: 'Reportes Pendientes',
                    distrito: widget.distrito,
                    zona: widget.zona,
                    sector: widget.sector,
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Filtro de reportes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filtrar por tipo:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isFiltering = !_isFiltering;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _isFiltering ? Color(0xFF1565C0) : Colors.transparent,
                            border: Border.all(color: Color(0xFF1565C0)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _selectedFilter,
                                style: TextStyle(
                                  color: _isFiltering ? Colors.white : Color(0xFF1565C0),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                _isFiltering ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                                color: _isFiltering ? Colors.white : Color(0xFF1565C0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Opciones de filtro desplegables
                  if (_isFiltering)
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: _filterOptions.map((option) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilter = option;
                                _isFiltering = false;
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: option != _filterOptions.last ? Colors.grey[200]! : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                option,
                                style: TextStyle(
                                  color: option == _selectedFilter ? Color(0xFF1565C0) : Colors.black87,
                                  fontWeight: option == _selectedFilter ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
            
            // Lista de reportes pendientes
            Expanded(
              child: _filteredReportes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay reportes pendientes',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filteredReportes.length,
                    itemBuilder: (context, index) {
                      final reporte = _filteredReportes[index];
                      final originalIndex = _reportesPendientes.indexOf(reporte);
                      return _buildReporteCard(reporte, originalIndex);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildReporteCard(Map<String, dynamic> reporte, int index) {
    Color getTipoColor() {
      switch (reporte['tipo']) {
        case 'Poste Telemático':
          return Colors.blue;
        case 'Poste Eléctrico':
          return Colors.orange;
        case 'Predio':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Cabecera con tipo y fecha
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: getTipoColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      reporte['tipo'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
                Text(
                  '${reporte['fecha']} - ${reporte['hora']}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Contenido
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubicación: ${reporte['ubicacion']}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                
                SizedBox(height: 12),
                
                // Barra de progreso
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estado: ${reporte['estado']}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        Text(
                          '${(reporte['progreso'] * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: reporte['progreso'],
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          getTipoColor(),
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 16),
                
                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _continuarReporte(reporte),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1565C0),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Continuar',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: () => _eliminarReporte(index),
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        tooltip: 'Eliminar reporte',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}