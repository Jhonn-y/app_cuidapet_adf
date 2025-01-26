import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/size_screen_extension.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/modules/home/home_controller.dart';

class HomeAppBar extends SliverAppBar {
  HomeAppBar(HomeController controller, {super.key})
      : super(
            expandedHeight: 100,
            collapsedHeight: 100,
            elevation: 0,
            flexibleSpace: _CuidapetAppBar(controller),
            iconTheme: IconThemeData(color: Colors.black),
            pinned: true);
}

class _CuidapetAppBar extends StatelessWidget {
  final HomeController controller;
  const _CuidapetAppBar(this.controller);

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.grey[200]!));

    return AppBar(
      backgroundColor: Colors.grey[100],
      centerTitle: true,
      title: Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: Text('Cuidapet'),
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.goToAddressPage();
          },
          icon: Icon(
            Icons.location_on,
            color: Colors.black,
          ),
        ),
      ],
      elevation: 0,
      flexibleSpace: Stack(
        children: [
          Container(
            height: 110.h,
            color: context.primaryColor,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(30),
              child: SizedBox(
                width: .9.sw,
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: Icon(
                      Icons.search,
                      size: 30,
                      color: Colors.deepPurple,
                    ),
                    border: outlineInputBorder,
                    enabledBorder: outlineInputBorder,
                    focusedBorder: outlineInputBorder,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
