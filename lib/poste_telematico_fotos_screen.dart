// lib/screens/field_worker/poste_telematico_fotos_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PosteTelematicoFotosScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;

  const PosteTelematicoFotosScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
  }) : super(key: key);

  @override
  _PosteTelematicoFotosScreenState createState() =>
      _PosteTelematicoFotosScreenState();
}

class _PosteTelematicoFotosScreenState
    extends State<PosteTelematicoFotosScreen> {
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

  Future<void> _tomarFoto(String tipoFoto) async {
    try {
      final XFile? imagen = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar la foto: $e')),
      );
    }
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
        title: Text(
          'Fotos del Poste Telemático',
          style: TextStyle(
            color: Color(0xFF1565C0),
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                        });
                      },
                      activeColor: Color(0xFFFF6B00),
                    ),
                  ],
                ),

                if (_fotosHabilitadas) ...[
                  SizedBox(height: 15),
                  _buildFotoSection('Estructura completa', 'estructura_completa',
                      _fotoEstructuraCompleta),
                  _buildFotoSection('Código estructura', 'codigo_estructura',
                      _fotoCodigoEstructura),
                  _buildFotoSection('Base poste', 'base_poste', _fotoBasePoste),
                  _buildFotoSection('Perfil poste', 'perfil_poste', _fotoPerfilPoste),

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
                          });
                        },
                        activeColor: Color(0xFFFF6B00),
                      ),
                    ],
                  ),

                  if (_fotosOpcionalesHabilitadas) ...[
                    SizedBox(height: 15),
                    _buildFotoSection('Foto lápida', 'lapida', _fotoLapida),
                  ],
                ],

                SizedBox(height: 20),

                // Botón Guardar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _validarYGuardar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1565C0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Guardar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFotoSection(String titulo, String tipo, File? foto) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () => _tomarFoto(tipo),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: foto != null ? Colors.blue.shade50 : Colors.white,
          ),
          child: Column(
            children: [
              foto != null
                  ? Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(foto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : Icon(
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
              if (foto != null)
                Text(
                  'Foto capturada ✓',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
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
      if (_fotoEstructuraCompleta == null ||
          _fotoCodigoEstructura == null ||
          _fotoBasePoste == null ||
          _fotoPerfilPoste == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Debe tomar todas las fotos obligatorias')),
        );
        return;
      }
    }

    // Aquí iría la lógica para guardar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reporte guardado correctamente')),
    );

    // Regresar al inicio
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}