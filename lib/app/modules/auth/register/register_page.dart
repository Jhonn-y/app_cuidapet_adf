import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/size_screen_extension.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/cuidapet_textform_field.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/default_button.dart';

part './widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Usuario'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 162.w,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _RegisterForm(),
            ],
          ),
        ),
      ),
    );
  }
}
