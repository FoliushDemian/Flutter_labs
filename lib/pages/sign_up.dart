import 'package:flutter/material.dart';
import 'package:my_project/logic/services/auth_service.dart';
import 'package:my_project/widgets/widget_button.dart';
import 'package:my_project/widgets/widget_text.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService =
      AuthService();

  void _register() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    final String? result = await _authService.register(name, email, password);
    if (result == null) {
      if(mounted) {
        Navigator.pushReplacementNamed(context,
          '/',);
      }
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(result),),);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    final horizontalPadding = isTablet ? screenWidth * 0.2 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          text: 'Registration',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: 16,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: 'Sign Up',
                onPressed:
                    _register,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(
                      context,);
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.purple,
                ),
                child: const CustomText(text: 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
