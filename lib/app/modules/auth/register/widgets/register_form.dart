part of '../register_page.dart';

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final _controller = Modular.get<RegisterController>();


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
            height: 20,
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
            height: 20,
          ),
          CuidapetTextFormField(
            label: 'Confirmar Senha',
            obscureText: true,
            validator: Validatorless.multiple([
              Validatorless.required('Confirmação da senha é obrigatória!'),
              Validatorless.compare(
                  _passwordEC, 'Confirmação da senha deve ser igual a senha!')
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          DefaultButton(onPressed: () async {
            final formValid = _formKey.currentState?.validate() ?? false;

            if(formValid){
              await _controller.register(email: _loginEC.text, password: _passwordEC.text);
            }
          }, label: 'Cadastrar')
        ],
      ),
    );
  }
}
