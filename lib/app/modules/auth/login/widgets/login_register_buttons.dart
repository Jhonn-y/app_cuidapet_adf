part of '../login_page.dart';

class _LoginRegisterButtons extends StatelessWidget {
  const _LoginRegisterButtons();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        RoundedButtonWithIcon(
          ontap: () {},
          color: Color(0xFF4267B3),
          width: .42.sw,
          icon: CuidapetIcons.facebook,
          label: 'Facebook',
        ),
        RoundedButtonWithIcon(
          ontap: () {},
          color: Color(0xFFE15031),
          width: .42.sw,
          icon: CuidapetIcons.google,
          label: 'Google',
        ),
        RoundedButtonWithIcon(
          ontap: () {
            Navigator.pushNamed(context, '/auth/register/');
          },
          color: context.primaryColorDark,
          width: .42.sw,
          icon: Icons.email,
          label: 'Cadastre-se',
        ),
      ],
    );
  }
}
