import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PredioFotosScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final Map<String, dynamic> predioData;
  
  // Agregar parámetros GPS desde el mapa de datos
  final double latitudUsuario;
  final double longitudUsuario;
  final double precision;
  final String fechaActualizacion;

  const PredioFotosScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.predioData,
    required this.latitudUsuario,
    required this.longitudUsuario,
    required this.precision,
    required this.fechaActualizacion,
  }) : super(key: key);

  @override
  _PredioFotosScreenState createState() => _PredioFotosScreenState();
}

class _PredioFotosScreenState extends State<PredioFotosScreen> {
  // Estados de los switches - fotos principales activas por defecto
  bool _fotosHabilitadas = true;
  bool _fotosOpcionalesHabilitadas = false;

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // Almacenar las fotos
  File? _fotoFachada;
  File? _fotoLateralIzquierda;
  File? _fotoLateralDerecha;
  File? _fotoMedidor;

  // Controlador para observaciones
  final _observacionesController = TextEditingController();

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto(String tipoFoto) async {
    try {
      final XFile? imagen = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (imagen != null) {
        setState(() {
          switch (tipoFoto) {
            case 'Foto fachada':
              _fotoFachada = File(imagen.path);
              break;
            case 'Foto lateral izquierda':
              _fotoLateralIzquierda = File(imagen.path);
              break;
            case 'lateral_derecha':
              _fotoLateralDerecha = File(imagen.path);
              break;
            case 'Foto medidor / intercomunicador':
              _fotoMedidor = File(imagen.path);
              break;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto capturada correctamente')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar la foto: $e')),
      );
    }
  }

  Widget _buildSeccionFoto(String titulo, String tipo, File? foto) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => _tomarFoto(tipo),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: foto != null ? 200 : 100,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: foto != null ? Color(0xFFE3F2FD) : Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: foto != null ? Color(0xFF1565C0) : Colors.grey[300]!,
              width: 2,
            ),
          ),
          child: foto != null
              ? Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: FileImage(foto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 32,
                      color: Color(0xFF1565C0),
                    ),
                    SizedBox(height: 8),
                    Text(
                      titulo,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _validarYGuardar() {
    if (_fotosHabilitadas) {
      // Validar que las fotos obligatorias estén tomadas
      if (_fotoFachada == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe tomar la foto de fachada'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Aquí iría la lógica para guardar todos los datos del reporte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reporte de predio guardado correctamente'),
        backgroundColor: Colors.green,
      ),
    );

    // Navegar de vuelta al inicio
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    String tipoPredio = widget.predioData['tipoPredio'] ?? 'Predio';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Fotos del Predio',
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
                  ProjectSummaryCard(
                    tipoPoste: 'Predio', // Usamos simplemente "Predio" en lugar del tipo específico
                    distrito: widget.distrito,
                    zona: widget.zona,
                    sector: widget.sector,
                  ),
                  
                  SizedBox(height: 15),
                  
                  // Información de posición del usuario
                  Text(
                    'Posición del usuario:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildCoordinateField('Latitud', 
                          widget.latitudUsuario.toStringAsFixed(7)
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildCoordinateField('Longitud', 
                          widget.longitudUsuario.toStringAsFixed(7)
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 10),
                  
                  Text(
                    'Precisión: ${widget.precision.toStringAsFixed(1)} metros',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  
                  Text(
                    'actualizado el: ${widget.fechaActualizacion}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Contenido principal con fotos
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Switch Fotos principales
                    CustomSwitchRow(
                      title: 'Fotos',
                      value: _fotosHabilitadas,
                      onChanged: (value) {
                        setState(() {
                          _fotosHabilitadas = value;
                          if (!value) {
                            _fotoFachada = null;
                            _fotosOpcionalesHabilitadas = false;
                            _fotoLateralIzquierda = null;
                            _fotoLateralDerecha = null;
                            _fotoMedidor = null;
                          }
                        });
                      },
                    ),

                    // Fotos principales
                    if (_fotosHabilitadas) ...[
                      SizedBox(height: 20),
                      _buildSeccionFoto('Foto Fachada', 'fachada', _fotoFachada),

                      SizedBox(height: 10),

                      CustomSwitchRow(
                        title: 'Fotos opcionales',
                        value: _fotosOpcionalesHabilitadas,
                        onChanged: (value) {
                          setState(() {
                            _fotosOpcionalesHabilitadas = value;
                            if (!value) {
                              _fotoLateralIzquierda = null;
                              _fotoLateralDerecha = null;
                              _fotoMedidor = null;
                            }
                          });
                        },
                      ),

                      if (_fotosOpcionalesHabilitadas) ...[
                        SizedBox(height: 15),
                        _buildSeccionFoto('Foto Lateral izquierda', 'lateral_izquierda', _fotoLateralIzquierda),
                        _buildSeccionFoto('Foto Lateral derecha', 'lateral_derecha', _fotoLateralDerecha),
                        _buildSeccionFoto('Foto Medidor / Intercomunicador', 'medidor', _fotoMedidor),
                      ],
                    ],

                    SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observaciones',
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
                            controller: _observacionesController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              hintText: 'Escriba sus observaciones aquí...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                            style: TextStyle(fontSize: 16),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.all(20),
              child: CustomButton(
                text: 'Guardar',
                onPressed: _validarYGuardar,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinateField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800])),
      ],
    );
  }
}