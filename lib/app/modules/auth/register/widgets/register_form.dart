part of '../register_page.dart';

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          CuidapetTextFormField(label: 'Login'),
          SizedBox(
            height: 20,
          ),
          CuidapetTextFormField(
            label: 'Senha',
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          CuidapetTextFormField(
            label: 'Confirmar Senha',
            obscureText: true,
          ),
          SizedBox(
            height: 20,
          ),
          DefaultButton(onPressed: () {}, label: 'Cadastrar')
        ],
      ),
    );
  }
}
