// lib/screens/field_worker/poste_telematico_fotos_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteTelematicoFotosScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  // Agregar parámetros GPS
  final double latitudUsuario;
  final double longitudUsuario;
  final double precision;
  final String fechaActualizacion;

  const PosteTelematicoFotosScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.latitudUsuario,
    required this.longitudUsuario,
    required this.precision,
    required this.fechaActualizacion,
  }) : super(key: key);

  @override
  _PosteTelematicoFotosScreenState createState() =>
      _PosteTelematicoFotosScreenState();
}

class _PosteTelematicoFotosScreenState
    extends State<PosteTelematicoFotosScreen> {
  // Estados de los switches - fotos principales activas por defecto
  bool _fotosHabilitadas = true;
  bool _fotosOpcionalesHabilitadas = false;

  // ImagePicker instance
  final ImagePicker _picker = ImagePicker();

  // Almacenar las fotos
  File? _fotoEstructuraCompleta;
  File? _fotoCodigoEstructura;
  File? _fotoBasePoste;
  File? _fotoPerfilPoste;
  File? _fotoLapida;

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
            case 'estructura_completa':
              _fotoEstructuraCompleta = File(imagen.path);
              break;
            case 'codigo_estructura':
              _fotoCodigoEstructura = File(imagen.path);
              break;
            case 'base_poste':
              _fotoBasePoste = File(imagen.path);
              break;
            case 'perfil_poste':
              _fotoPerfilPoste = File(imagen.path);
              break;
            case 'lapida':
              _fotoLapida = File(imagen.path);
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
      List<String> fotosFaltantes = [];
      
      if (_fotoEstructuraCompleta == null) fotosFaltantes.add('Estructura completa');
      if (_fotoCodigoEstructura == null) fotosFaltantes.add('Código estructura');
      if (_fotoBasePoste == null) fotosFaltantes.add('Base poste');
      if (_fotoPerfilPoste == null) fotosFaltantes.add('Perfil poste');

      if (fotosFaltantes.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debe tomar las siguientes fotos: ${fotosFaltantes.join(', ')}'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Aquí iría la lógica para guardar todos los datos del reporte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reporte guardado correctamente'),
        backgroundColor: Colors.green,
      ),
    );

    // Navegar de vuelta al inicio
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Fotos del Poste Telemático',
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
                    tipoPoste: 'Poste Telemático',
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

            // Resto del contenido permanece igual...
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
                            _fotoEstructuraCompleta = null;
                            _fotoCodigoEstructura = null;
                            _fotoBasePoste = null;
                            _fotoPerfilPoste = null;
                            _fotosOpcionalesHabilitadas = false;
                            _fotoLapida = null;
                          }
                        });
                      },
                    ),

                    // Resto del contenido de fotos...
                    if (_fotosHabilitadas) ...[
                      SizedBox(height: 20),
                      _buildSeccionFoto('Estructura completa', 'estructura_completa', _fotoEstructuraCompleta),
                      _buildSeccionFoto('Código estructura', 'codigo_estructura', _fotoCodigoEstructura),
                      _buildSeccionFoto('Base poste', 'base_poste', _fotoBasePoste),
                      _buildSeccionFoto('Perfil poste', 'perfil_poste', _fotoPerfilPoste),

                      SizedBox(height: 10),

                      CustomSwitchRow(
                        title: 'Fotos opcionales',
                        value: _fotosOpcionalesHabilitadas,
                        onChanged: (value) {
                          setState(() {
                            _fotosOpcionalesHabilitadas = value;
                            if (!value) {
                              _fotoLapida = null;
                            }
                          });
                        },
                      ),

                      if (_fotosOpcionalesHabilitadas) ...[
                        SizedBox(height: 15),
                        _buildSeccionFoto('Foto lápida', 'lapida', _fotoLapida),
                      ],
                    ],

                    SizedBox(height: 20),

                    CustomTextField(
                      label: 'Observaciones',
                      controller: _observacionesController,
                      hintText: 'Escriba sus observaciones aquí...',
                      maxLines: 3,
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