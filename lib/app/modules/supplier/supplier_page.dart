import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:projeto_cuidapet/app/core/life_cycle/page_life_cycle_state.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/modules/supplier/supplier_controller.dart';
import 'package:projeto_cuidapet/app/modules/supplier/widgets/supplier_detail_widget.dart';
import 'package:projeto_cuidapet/app/modules/supplier/widgets/supplier_service_widget.dart';

class SupplierPage extends StatefulWidget {
  final int _supplierID;
  const SupplierPage({super.key, required int supplierID})
      : _supplierID = supplierID;

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState
    extends PageLifeCycleState<SupplierController, SupplierPage> {
  late ScrollController _scrollController;
  final sliverColapsedVN = ValueNotifier(false);

  @override
  Map<String, dynamic>? get params => {'supplierId': widget._supplierID};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 180 &&
          !_scrollController.position.outOfRange) {
        sliverColapsedVN.value = true;
      } else if (_scrollController.offset <= 180 &&
          !_scrollController.position.outOfRange) {
        sliverColapsedVN.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text(
            'Fazer agendamento',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(
            Icons.schedule,
            color: Colors.white,
          ),
          backgroundColor: context.primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Observer(
          builder: (_) {
            final supplier = controller.supplierModel;

            if (supplier == null) {
              return Text('Buscando dados do fornecedor');
            }
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  title: ValueListenableBuilder(
                    valueListenable: sliverColapsedVN,
                    builder: (_, sliverColapsedVN, child) {
                      return Visibility(
                        visible: sliverColapsedVN,
                        child: Text(
                          supplier.name,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: [
                      StretchMode.zoomBackground,
                      StretchMode.fadeTitle,
                    ],
                    background: Image.network(
                      supplier.logo,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          SizedBox.shrink(),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SupplierDetailWidget(
                    supplier: supplier,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Serviços (0 selecionados)',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: controller.supplierServiceModel.length,
                        (context, index) {
                  final service = controller.supplierServiceModel[index];

                  return SupplierServiceWidget(
                    serviceModel: service,
                  );
                }))
              ],
            );
          },
        ));
  }
}
