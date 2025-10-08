import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'location_selection_screen.dart';
import 'services/auth_service.dart';

void main() async {
  // Asegurarse de que los widgets de Flutter estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ahora puedes ejecutar la app
  runApp(FieldOpsApp());
}

class FieldOpsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FieldOps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color(0xFF1565C0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _rememberData = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  // Cargar credenciales guardadas
  Future<void> _loadSavedCredentials() async {
    try {
      print('Intentando cargar credenciales guardadas');
      final prefs = await SharedPreferences.getInstance();
      final rememberData = prefs.getBool('rememberData') ?? false;
      print('RememberData encontrado: $rememberData');
      
      if (rememberData) {
        final dni = prefs.getString('dni') ?? '';
        final password = prefs.getString('password') ?? '';
        print('Credenciales encontradas: dni=$dni, password=***');
        
        setState(() {
          _dniController.text = dni;
          _passwordController.text = password;
          _rememberData = rememberData;
        });
        print('Estado actualizado con credenciales guardadas');
      } else {
        print('No hay datos guardados o rememberData es false');
      }
    } catch (e) {
      print('Error al cargar credenciales: $e');
    }
  }

  // Guardar credenciales
  Future<void> _saveCredentials(String dni, String password) async {
    try {
      print('Guardando credenciales: rememberData=$_rememberData, dni=$dni');
      final prefs = await SharedPreferences.getInstance();
      
      if (_rememberData) {
        await prefs.setString('dni', dni);
        await prefs.setString('password', password);
        await prefs.setBool('rememberData', true);
        print('Credenciales guardadas con éxito');
      } else {
        // Limpiar credenciales guardadas
        await prefs.remove('dni');
        await prefs.remove('password');
        await prefs.setBool('rememberData', false);
        print('Credenciales eliminadas');
      }
      
      // Verificar que se guardaron correctamente
      final testRemember = prefs.getBool('rememberData');
      final testDni = prefs.getString('dni');
      print('Verificación: rememberData=$testRemember, dni=$testDni');
    } catch (e) {
      print('Error al guardar credenciales: $e');
    }
  }

  void _login() async {
    final dni = _dniController.text.trim();
    final password = _passwordController.text.trim();

    if (dni.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Validar que el DNI tenga exactamente 8 dígitos
    if (dni.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El DNI debe tener exactamente 8 dígitos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.login(dni, password);

      if (result['success']) {
        // Guardar credenciales si se marcó "Recordar datos"
        await _saveCredentials(dni, password);
        
        // Navigate to next screen with user data
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LocationSelectionScreen(
              encargado: result['user'] as Map<String, String>,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60),
              
              // Logo FieldOps
              Container(
                height: 100,
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
              
              SizedBox(height: 60),
              
              // Campo DNI - Limitado a 8 dígitos
              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                maxLength: 8, // Limitar a 8 caracteres
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Solo permitir dígitos
                ],
                decoration: InputDecoration(
                  hintText: 'DNI',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  counterText: '', // Ocultar el contador de caracteres
                ),
              ),
              
              SizedBox(height: 20),
              
              // Campo Contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  filled: true,
                  fillColor: Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey[600],
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Recordar datos - Ahora funcional
              Row(
                children: [
                  Checkbox(
                    value: _rememberData,
                    onChanged: (value) {
                      setState(() {
                        _rememberData = value ?? false;
                      });
                    },
                    activeColor: Color(0xFF1565C0),
                  ),
                  Text(
                    'Recordar datos',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 40),
              
              // Botón Iniciar Sesión
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: 40),
              
              // Pie de página con versión
              Text(
                'FieldOps v1.0.0',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}