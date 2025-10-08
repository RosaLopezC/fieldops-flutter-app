// lib/poste_electrico_gps_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'poste_electrico_fotos_screen.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/shared_components.dart';

class PosteElectricoGpsScreen extends StatefulWidget {
  final String distrito;
  final String zona;
  final String sector;
  final String tensionSeleccionada;

  const PosteElectricoGpsScreen({
    Key? key,
    required this.distrito,
    required this.zona,
    required this.sector,
    required this.tensionSeleccionada,
  }) : super(key: key);

  @override
  _PosteElectricoGpsScreenState createState() => _PosteElectricoGpsScreenState();
}

class _PosteElectricoGpsScreenState extends State<PosteElectricoGpsScreen> {
  // Controlador del mapa
  Completer<GoogleMapController> _controller = Completer();
  
  // Posiciones
  double? latitudUsuario;
  double? longitudUsuario;
  double precision = 0.0;
  String fechaActualizacion = "";
  
  // Posición del sector (viene de BD)
  double latitudSector = -12.0419815;
  double longitudSector = -77.013401;
  
  // Posición seleccionada para el poste
  double? latitudPosteSeleccionado;
  double? longitudPosteSeleccionado;
  
  bool _isUpdatingLocation = false;
  bool _mostrandoUsuario = true;
  bool _permisosConcedidos = false;
  
  // Configuración del mapa
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(-12.0419735, -77.0134697),
    zoom: 18.0,
  );
  
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _checkPermissions();
    if (_permisosConcedidos) {
      await _getCurrentLocation();
    }
  }

  Future<void> _checkPermissions() async {
    // Verificar si los servicios de ubicación están habilitados
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationServiceDialog();
      return;
    }

    // Verificar permisos
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionDeniedForeverDialog();
      return;
    }

    setState(() {
      _permisosConcedidos = true;
    });
  }

  Future<void> _getCurrentLocation() async {
    if (!_permisosConcedidos) {
      await _checkPermissions();
      return;
    }

    setState(() {
      _isUpdatingLocation = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      
      setState(() {
        latitudUsuario = position.latitude;
        longitudUsuario = position.longitude;
        precision = position.accuracy;
        fechaActualizacion = _getCurrentTimestamp();
        _isUpdatingLocation = false;
        
        // Inicialmente el poste está en la posición del sector
        if (latitudPosteSeleccionado == null) {
          latitudPosteSeleccionado = latitudSector;
          longitudPosteSeleccionado = longitudSector;
        }
      });

      _updateMapMarkers();
      await _moveCamera();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ubicación actualizada con precisión de ${precision.toStringAsFixed(1)}m')),
      );
    } catch (e) {
      setState(() {
        _isUpdatingLocation = false;
      });
      _showLocationErrorDialog();
    }
  }

  void _updateMapMarkers() {
    Set<Marker> markers = {};
    Set<Circle> circles = {};
    
    if (latitudUsuario != null) {
      // Marcador del usuario
      markers.add(
        Marker(
          markerId: MarkerId('usuario'),
          position: LatLng(latitudUsuario!, longitudUsuario!),
          infoWindow: InfoWindow(
            title: 'Tu ubicación',
            snippet: 'Precisión: ${precision.toStringAsFixed(1)}m',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
      
      // Círculo de 35 metros alrededor del usuario
      circles.add(
        Circle(
          circleId: CircleId('area_valida'),
          center: LatLng(latitudUsuario!, longitudUsuario!),
          radius: 35,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 2,
        ),
      );
    }
    
    // Marcador del poste
    if (latitudPosteSeleccionado != null) {
      markers.add(
        Marker(
          markerId: MarkerId('poste'),
          position: LatLng(latitudPosteSeleccionado!, longitudPosteSeleccionado!),
          infoWindow: InfoWindow(
            title: 'Posición del poste',
            snippet: 'Arrastra para mover',
          ),
          draggable: true,
          onDragEnd: (LatLng newPosition) {
            _onPosteMoved(newPosition);
          },
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
    
    setState(() {
      _markers = markers;
      _circles = circles;
    });
  }

  void _onPosteMoved(LatLng newPosition) {
    if (latitudUsuario == null) return;
    
    double distancia = _calcularDistancia(
      latitudUsuario!, longitudUsuario!,
      newPosition.latitude, newPosition.longitude
    );
    
    if (distancia <= 35) {
      setState(() {
        latitudPosteSeleccionado = newPosition.latitude;
        longitudPosteSeleccionado = newPosition.longitude;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Poste reposicionado (${distancia.toStringAsFixed(1)}m del usuario)')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Muy lejos del usuario (${distancia.toStringAsFixed(1)}m). Máximo: 35m'),
          backgroundColor: Colors.orange,
        ),
      );
      // Revertir posición
      _updateMapMarkers();
    }
  }

  Future<void> _moveCamera() async {
    if (latitudUsuario != null) {
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latitudUsuario!, longitudUsuario!)
        ),
      );
    }
  }

  void _toggleView() {
    setState(() {
      _mostrandoUsuario = !_mostrandoUsuario;
    });
  }

  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    double deltaLat = (lat2 - lat1) * math.pi / 180;
    double deltaLon = (lon2 - lon1) * math.pi / 180;
    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1 * math.pi / 180) * math.cos(lat2 * math.pi / 180) *
        math.sin(deltaLon / 2) * math.sin(deltaLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return 6371000 * c;
  }

  String _getCurrentTimestamp() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year.toString().substring(2)} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GPS Desactivado'),
          content: Text('Los servicios de ubicación están deshabilitados. Por favor, activa el GPS en la configuración de tu dispositivo.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: Text('Abrir Configuración'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permisos Denegados'),
          content: Text('Sin acceso a la ubicación, no se puede registrar la posición del poste. ¿Desea intentar nuevamente?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _checkPermissions();
              },
              child: Text('Intentar de nuevo'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDeniedForeverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permisos Denegados Permanentemente'),
          content: Text('Los permisos de ubicación han sido denegados permanentemente. Debe habilitarlos manualmente en la configuración del dispositivo.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openAppSettings();
              },
              child: Text('Abrir Configuración'),
            ),
          ],
        );
      },
    );
  }

  void _showLocationErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de GPS'),
          content: Text('No se pudo obtener la ubicación. Verifica que el GPS esté activado y que tengas señal.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _getCurrentLocation();
              },
              child: Text('Reintentar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _onSiguientePressed() {
    if (latitudUsuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Primero debe obtener su ubicación GPS')),
      );
      return;
    }

    // Navegar al paso de fotos con TODOS los datos incluyendo GPS
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PosteElectricoFotosScreen(
          distrito: widget.distrito,
          zona: widget.zona,
          sector: widget.sector,
          tensionSeleccionada: widget.tensionSeleccionada,
          // Pasar datos GPS
          latitudUsuario: latitudUsuario!,
          longitudUsuario: longitudUsuario!,
          precision: precision,
          fechaActualizacion: fechaActualizacion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Poste Eléctrico - GPS',
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
                    tipoPoste: 'Poste Eléctrico ${widget.tensionSeleccionada}',
                    distrito: widget.distrito,
                    zona: widget.zona,
                    sector: widget.sector,
                  ),
                  
                  SizedBox(height: 15),
                  
                  Text(
                    'Posición del usuario:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  if (!_permisosConcedidos)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Se necesitan permisos de ubicación para mostrar Google Maps',
                              style: TextStyle(color: Colors.orange.shade800),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (latitudUsuario == null)
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CircularProgressIndicator(strokeWidth: 2),
                          SizedBox(width: 10),
                          Text('Obteniendo ubicación GPS...'),
                        ],
                      ),
                    )
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildCoordinateField('Latitud', 
                            _mostrandoUsuario 
                              ? latitudUsuario!.toStringAsFixed(7)
                              : latitudPosteSeleccionado!.toStringAsFixed(7)
                          ),
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: _buildCoordinateField('Longitud', 
                            _mostrandoUsuario 
                              ? longitudUsuario!.toStringAsFixed(7)
                              : longitudPosteSeleccionado!.toStringAsFixed(7)
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 10),
                    
                    Text(
                      'Precisión: ${precision.toStringAsFixed(1)} metros',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    
                    Text(
                      'actualizado el: $fechaActualizacion',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                  
                  SizedBox(height: 15),
                  
                  // Botones de control
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _isUpdatingLocation ? null : _getCurrentLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _mostrandoUsuario ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: _isUpdatingLocation
                                ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                                : Icon(Icons.my_location, 
                                    color: _mostrandoUsuario ? Colors.white : Color(0xFF1565C0), 
                                    size: 20
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Container(
                          height: 45,
                          child: ElevatedButton(
                            onPressed: latitudUsuario != null ? _toggleView : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !_mostrandoUsuario ? Color(0xFF1565C0) : Color(0xFFBBDEFB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Icon(Icons.place, 
                              color: !_mostrandoUsuario ? Colors.white : Color(0xFF1565C0), 
                              size: 20
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Google Maps
            Expanded(
              child: latitudUsuario != null
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: _initialPosition,
                          markers: _markers,
                          circles: _circles,
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                          },
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: true,
                          compassEnabled: true,
                          tiltGesturesEnabled: false,
                        ),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off, size: 64, color: Colors.grey[400]),
                            SizedBox(height: 16),
                            Text(
                              'Obtenga su ubicación GPS para ver el mapa',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            
            // Botón Siguiente usando el componente unificado
            Container(
              padding: EdgeInsets.all(20),
              child: CustomButton(
                text: 'Siguiente',
                onPressed: latitudUsuario != null ? _onSiguientePressed : null,
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