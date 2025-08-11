import 'package:flutter/material.dart';
import 'package:login_app/Services/auth_methods.dart';
import 'package:login_app/utils/colors.dart';
// import 'package:login_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Méthode pour s'inscrire
  Future<void> _signUp() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs';
      });
      return;
    }

    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas';
      });
      return;
    }

    if (_passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Le mot de passe doit contenir au moins 6 caractères';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential? result = await _authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (result != null && mounted) {
        // Navigation vers l'écran principal
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [backgroundColor2, backgroundColor2, backgroundColor4],
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              SizedBox(height: size.height * 0.03),
              Text(
                "Créer un compte",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 37,
                  color: textColor1,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Rejoignez-nous aujourd'hui",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 27, color: textColor2, height: 1.2),
              ),
              SizedBox(height: size.height * 0.04),

              // Affichage des erreurs
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Champ email
              myTextField(
                hint: "Enter email",
                controller: _emailController,
                isPassword: false,
                keyboardType: TextInputType.emailAddress,
              ),

              // Champ mot de passe
              myTextField(
                hint: "Password",
                controller: _passwordController,
                isPassword: true,
                isPasswordVisible: _isPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),

              // Champ confirmation mot de passe
              myTextField(
                hint: "Confirm Password",
                controller: _confirmPasswordController,
                isPassword: true,
                isPasswordVisible: _isConfirmPasswordVisible,
                onVisibilityToggle: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),

              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // Bouton d'inscription
                    SizedBox(
                      width: size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: buttonColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: _isLoading ? null : _signUp,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.08),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            color: textColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: const [
                            TextSpan(
                              text: "Sign In",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container myTextField({
    required String hint,
    required TextEditingController controller,
    required bool isPassword,
    TextInputType keyboardType = TextInputType.text,
    bool isPasswordVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !isPasswordVisible : false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 22,
          ),
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15),
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 19),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black26,
                    ),
                    onPressed: onVisibilityToggle,
                  )
                  : null,
        ),
      ),
    );
  }
}
