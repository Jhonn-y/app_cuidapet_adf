part of '../login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _controller = Modular.get<LoginController>();

  @override
  void dispose() {
    super.dispose();
    _loginEC.dispose();
    _passwordEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            CuidapetTextFormField(
              label: 'Login',
              controller: _loginEC,
              validator: Validatorless.multiple([
                Validatorless.required('Email é obrigatorio!'),
                Validatorless.email('Endereço de email deve ser valido!'),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            CuidapetTextFormField(
              label: 'Senha',
              obscureText: true,
              controller: _passwordEC,
              validator: Validatorless.multiple([
                Validatorless.required("Senha é obrigatoria!"),
                Validatorless.min(6, 'Senha deve ter pelo menos 6 caracteres'),
              ]),
            ),
            SizedBox(
              height: 10,
            ),
            DefaultButton(
                onPressed: () async {
                  final formValid = _formKey.currentState?.validate() ?? false;

                  if (formValid) {
                    final formValid =
                        _formKey.currentState?.validate() ?? false;

                    if (formValid) {
                      await _controller.login(
                          email: _loginEC.text, password: _passwordEC.text);
                    }
                  }
                },
                label: 'Entrar')
          ],
        ));
  }
}
