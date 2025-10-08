// lib/poste_electrico_fotos_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'widgets/custom_app_bar.dart';

class PosteElectricoFotosScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final String tensionSeleccionada;

  const PosteElectricoFotosScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.tensionSeleccionada,
  }) : super(key: key);

  @override
  _PosteElectricoFotosScreenState createState() => _PosteElectricoFotosScreenState();
}

class _PosteElectricoFotosScreenState extends State<PosteElectricoFotosScreen> {
  // Estados de los switches
  bool _fotosHabilitadas = false;
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
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => _tomarFoto(tipo),
        child: Container(
          height: foto != null ? 200 : 120,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[300]!, 
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(8),
            color: foto != null ? Colors.blue.shade50 : Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (foto != null) ...[
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
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1565C0),
                  ),
                ),
                Text(
                  'Foto capturada ✓',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                Icon(
                  Icons.camera_alt,
                  size: 40,
                  color: Color(0xFF1565C0),
                ),
                SizedBox(height: 8),
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
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
    
    // Navegar de vuelta al inicio o mostrar confirmación
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Fotos del Poste Eléctrico',
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Información superior
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Poste Eléctrico ${widget.tensionSeleccionada}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  Text('Distrito: ${widget.distrito}', style: _infoTextStyle()),
                  Text('Zona: ${widget.zona}', style: _infoTextStyle()),
                  Text('Sector: ${widget.sector}', style: _infoTextStyle()),
                ],
              ),
            ),
            
            // Contenido scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Switch Fotos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Fotos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        Switch(
                          value: _fotosHabilitadas,
                          onChanged: (value) {
                            setState(() {
                              _fotosHabilitadas = value;
                              if (!value) {
                                // Limpiar fotos si se desactiva
                                _fotoEstructuraCompleta = null;
                                _fotoCodigoEstructura = null;
                                _fotoBasePoste = null;
                                _fotoPerfilPoste = null;
                                _fotosOpcionalesHabilitadas = false;
                                _fotoLapida = null;
                              }
                            });
                          },
                          activeColor: Colors.orange,
                        ),
                      ],
                    ),
                    
                    // Fotos obligatorias
                    if (_fotosHabilitadas) ...[
                      SizedBox(height: 15),
                      _buildSeccionFoto('Estructura completa', 'estructura_completa', _fotoEstructuraCompleta),
                      _buildSeccionFoto('Código estructura', 'codigo_estructura', _fotoCodigoEstructura),
                      _buildSeccionFoto('Base poste', 'base_poste', _fotoBasePoste),
                      _buildSeccionFoto('Perfil poste', 'perfil_poste', _fotoPerfilPoste),
                      
                      // Switch Fotos opcionales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Fotos opcionales',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                          Switch(
                            value: _fotosOpcionalesHabilitadas,
                            onChanged: (value) {
                              setState(() {
                                _fotosOpcionalesHabilitadas = value;
                                if (!value) {
                                  _fotoLapida = null;
                                }
                              });
                            },
                            activeColor: Colors.orange,
                          ),
                        ],
                      ),
                      
                      // Fotos opcionales
                      if (_fotosOpcionalesHabilitadas) ...[
                        SizedBox(height: 15),
                        _buildSeccionFoto('Foto lápida', 'lapida', _fotoLapida),
                      ],
                    ],
                    
                    SizedBox(height: 20),
                    
                    // Campo Observaciones
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observaciones',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _observacionesController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Escriba sus observaciones aquí...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            
            // Botón Guardar
            Container(
              padding: EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validarYGuardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _infoTextStyle() {
    return TextStyle(fontSize: 12, color: Colors.grey[600]);
  }
}