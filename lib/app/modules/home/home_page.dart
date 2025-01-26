import 'package:flutter/material.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/page_life_cycle_state.dart';
import 'package:projeto_cuidapet/app/modules/home/home_controller.dart';
import 'package:projeto_cuidapet/app/modules/home/widgets/home_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends PageLifeCycleState<HomeController, HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      drawer: Drawer(),
      body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              HomeAppBar(),
            ];
          },
          body: Container()),
    );
  }
}
