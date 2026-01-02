import 'package:auth_app/screens/home_screen.dart';
import 'package:auth_app/screens/register_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_textfield_widget.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();

  final _passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AuthTextFieldWidget(
                  controller: _emailCtrl,
                  labelText: "Email",
                  hintText: "Enter your Email",
                  validator: (value) =>
                      value!.contains('@') ? null : 'Enter valid email',
                ),
                const SizedBox(height: 12),
                Consumer<AuthProvider>(
                  builder: (context, value, child) => AuthTextFieldWidget(
                    controller: _passwordCtrl,
                    labelText: "Password",
                    hintText: "Enter your password",
                    isObsecure: value.isLoginPasswordObscure,
                    validator: (value) =>
                        value!.length >= 6 ? null : 'Min 6 characters',
                    suffixIcon: IconButton(
                      icon: Icon(
                        value.isLoginPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: value.toggleLoginPassword,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 20),

                Consumer<AuthProvider>(
                  builder: (context, value, child) => SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      onPressed: value.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final result = await value.login(
                                  _emailCtrl.text.trim(),
                                  _passwordCtrl.text.trim(),
                                );

                                if (!context.mounted) return;

                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(result)));

                                if (result == 'Login Successful') {
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
                      child: Text(value.isLoading ? "Loading..." : 'Login'),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(child: Divider(indent: 10, endIndent: 10)),
                    Text("Or"),
                    Expanded(child: Divider(indent: 10, endIndent: 10)),
                  ],
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Register',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          ),
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
