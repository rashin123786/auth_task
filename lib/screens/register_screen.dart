import 'package:auth_app/screens/home_screen.dart';
import 'package:auth_app/widgets/auth_textfield_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  final _passwordCtrl = TextEditingController();

  final _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              children: [
                SizedBox(height: 5),
                AuthTextFieldWidget(
                  controller: _nameCtrl,
                  labelText: "Name",
                  hintText: "Enter your name",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your name *';
                    } else if (value.length < 3) {
                      return 'Name must be more than 3 character';
                    }
                    return null;
                  },
                ),
                AuthTextFieldWidget(
                  controller: _emailCtrl,
                  labelText: "Email",
                  hintText: "Enter your Email",
                  validator: (value) =>
                      value!.contains('@') ? null : 'Enter valid email',
                ),

                Consumer<AuthProvider>(
                  builder: (context, value, child) => AuthTextFieldWidget(
                    controller: _passwordCtrl,
                    labelText: "Password",
                    hintText: "Enter your password",
                    isObsecure: value.isRegisterPasswordObscure,
                    validator: (value) =>
                        value!.length >= 6 ? null : 'Min 6 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        value.isRegisterPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: value.toggleRegisterPassword,
                    ),
                  ),
                ),

                Consumer<AuthProvider>(
                  builder: (context, value, child) => AuthTextFieldWidget(
                    controller: _confirmCtrl,
                    labelText: "Confirm Password",
                    hintText: "Confirm your password",
                    isObsecure: value.isRegisterConfirmPasswordObscure,
                    validator: (value) => value == _passwordCtrl.text
                        ? null
                        : 'Passwords do not match *',
                    suffixIcon: IconButton(
                      icon: Icon(
                        value.isRegisterConfirmPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: value.toggleRegisterConfirmPassword,
                    ),
                  ),
                ),

                Consumer<AuthProvider>(
                  builder: (context, value, child) => SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: value.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final result = await value.register(
                                  _emailCtrl.text.trim(),
                                  _passwordCtrl.text.trim(),
                                );

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(result)));

                                if (result == 'Registration Successful') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const HomeScreen(),
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 46, 28, 49),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                      child: Text(value.isLoading ? "Loading..." : 'Register'),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Login',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.pop(context),
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
