import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/size_screen_extension.dart';

class RoundedButtonWithIcon extends StatelessWidget {
  final GestureTapCallback ontap;
  final Color color;
  final double width;
  final IconData icon;
  final String label;

  const RoundedButtonWithIcon(
      {super.key,
      required this.ontap,
      required this.color,
      required this.width,
      required this.icon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: width,
        height: 45.h,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 0, right: 2),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: VerticalDivider(
                color: Colors.white,
                thickness: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
