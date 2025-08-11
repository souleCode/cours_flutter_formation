import 'package:flutter/material.dart';
import 'package:login_app/Services/auth_methods.dart';
import 'package:login_app/utils/colors.dart';
// import 'package:login_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Méthode pour se connecter
  Future<void> _signIn() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez remplir tous les champs';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential? result = await _authService.signInWithEmailAndPassword(
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

  // Méthode pour réinitialiser le mot de passe
  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      setState(() {
        _errorMessage =
            'Veuillez entrer votre email pour réinitialiser le mot de passe';
      });
      return;
    }

    try {
      await _authService.resetPassword(_emailController.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de réinitialisation envoyé !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
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
                "Salut!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 37,
                  color: textColor1,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Bienvenue sur mon App",
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
              ),

              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _resetPassword,
                  child: Text(
                    "Recovery Password               ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    // Bouton de connexion
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
                        onPressed: _isLoading ? null : _signIn,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : const Text(
                                  "Sign In",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.06),
                    // Suppression de la section "Or continue with" et des boutons sociaux
                    SizedBox(height: size.height * 0.07),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: Text.rich(
                        TextSpan(
                          text: "Not a member? ",
                          style: TextStyle(
                            color: textColor2,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          children: const [
                            TextSpan(
                              text: "Register now",
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
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? !_isPasswordVisible : false,
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
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black26,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )
                  : null,
        ),
      ),
    );
  }
}
