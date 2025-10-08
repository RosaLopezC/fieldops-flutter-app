// lib/poste_electrico_step2_screen.dart
import 'package:flutter/material.dart';
import 'poste_electrico_step3_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteElectricoStep2Screen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final String tensionSeleccionada;

  const PosteElectricoStep2Screen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.tensionSeleccionada,
  }) : super(key: key);

  @override
  _PosteElectricoStep2ScreenState createState() => _PosteElectricoStep2ScreenState();
}

class _PosteElectricoStep2ScreenState extends State<PosteElectricoStep2Screen> {
  // Estados de selección (mantener todos los datos existentes)
  String? tipoEstructura1; // Simple/Doble/Triple
  String? tipoEstructura2; // Concreto/Madera/Metal/Fibra
  String? zonaInstalacion1; // Tierra/Jardín/Rocoso/Vereda
  String? zonaInstalacion2; // 100/200/250/300/400/500/ND/OTRO
  
  // Campo de texto para "OTRO"
  final _resistenciaController = TextEditingController();
  bool _mostrarCampoOtro = false;

  @override
  void dispose() {
    _resistenciaController.dispose();
    super.dispose();
  }

  void _onZonaInstalacion2Changed(String value) {
    setState(() {
      zonaInstalacion2 = value;
      _mostrarCampoOtro = value == 'OTRO';
      if (!_mostrarCampoOtro) {
        _resistenciaController.clear();
      }
    });
  }

  void _onSiguientePressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteElectricoStep3Screen(
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
        title: 'Poste Eléctrico - Estructura',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Resumen del proyecto unificado
              ProjectSummaryCard(
                tipoPoste: 'Poste Eléctrico ${widget.tensionSeleccionada}',
                distrito: widget.distrito,
                zona: widget.zona,
                sector: widget.sector,
              ),
              
              SizedBox(height: 30),
              
              // Tipo de estructura (Simple/Doble/Triple)
              OptionsSelector(
                title: 'Tipo de estructura',
                options: ['Simple', 'Doble', 'Triple'],
                selectedValue: tipoEstructura1,
                onSelect: (value) => setState(() => tipoEstructura1 = value),
              ),
              
              SizedBox(height: 30),
              
              // Tipo de estructura (Material)
              OptionsSelector(
                title: 'Material de estructura',
                options: ['Concreto', 'Madera', 'Metal', 'Fibra'],
                selectedValue: tipoEstructura2,
                onSelect: (value) => setState(() => tipoEstructura2 = value),
              ),
              
              SizedBox(height: 30),
              
              // Zona de instalación (Ubicación)
              OptionsSelector(
                title: 'Zona de instalación',
                options: ['Tierra', 'Jardín', 'Rocoso', 'Vereda'],
                selectedValue: zonaInstalacion1,
                onSelect: (value) => setState(() => zonaInstalacion1 = value),
              ),
              
              SizedBox(height: 30),
              
              // Resistencia
              OptionsSelector(
                title: 'Resistencia',
                options: ['100', '200', '250', '300', '400', '500', 'ND', 'OTRO'],
                selectedValue: zonaInstalacion2,
                onSelect: _onZonaInstalacion2Changed,
              ),
              
              // Campo para "OTRO"
              if (_mostrarCampoOtro) ...[
                SizedBox(height: 20),
                CustomTextField(
                  label: 'Especifica resistencia',
                  controller: _resistenciaController,
                  keyboardType: TextInputType.number,
                  hintText: 'Ingresa resistencia',
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
}