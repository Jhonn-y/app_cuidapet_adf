part of '../login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        CuidapetTextFormField(label: 'Login'),
        SizedBox(
          height: 10,
        ),
        CuidapetTextFormField(
          label: 'Senha',
          obscureText: true,
        ),
        SizedBox(
          height: 10,
        ),
        DefaultButton(onPressed: () {}, label: 'Entrar')
      ],
    ));
  }
}
