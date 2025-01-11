import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/cuidapet_textform_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _testeEC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CuidapetTextFormField(
                  label: 'Nome',
                  obscureText: false,
                  controller: _testeEC,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                ),
                Text(_testeEC.text),
                ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.validate();
                    },
                    child: Text('Validar'))
              ],
            ),
          ),
        ));
  }
}
