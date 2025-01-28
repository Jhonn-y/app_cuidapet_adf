part of '../home_page.dart';

class _HomeSupplierTab extends StatelessWidget {
  final HomeController _controller;

  const _HomeSupplierTab({required HomeController controller})
      : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HomeTabHeader(_controller),
        Expanded(
          child: Observer(
            builder: (_) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: _controller.pageTypeSelected == SupplierPageType.list
                    ? _HomeSupplierList(_controller)
                    : _HomeSupplierGrid(),
              );
            },
          ),
        )
      ],
    );
  }
}

class _HomeTabHeader extends StatelessWidget {
  final HomeController _controller;
  const _HomeTabHeader(this._controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Text('Estabelecimentos'),
          Spacer(),
          InkWell(
            onTap: () => _controller.changeTabSupplier(SupplierPageType.list),
            child: Observer(
              builder: (_) {
                return Icon(
                  Icons.view_headline,
                  color: _controller.pageTypeSelected == SupplierPageType.list
                      ? Colors.black
                      : Colors.grey,
                );
              },
            ),
          ),
          InkWell(
            onTap: () => _controller.changeTabSupplier(SupplierPageType.grid),
            child: Observer(
              builder: (_) {
                return Icon(
                  Icons.view_comfy,
                  color: _controller.pageTypeSelected == SupplierPageType.grid
                      ? Colors.black
                      : Colors.grey,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSupplierList extends StatelessWidget {
  final HomeController _controller;
  const _HomeSupplierList(this._controller);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        Observer(
          builder: (_) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: _controller.listSupplierByAddress.length,
                (context, index) {
                  final supplier = _controller.listSupplierByAddress[index];
                  return _HomeSupplierItemList(supplier);
                },
              ),
            );
          },
        )
      ],
    );
  }
}

class _HomeSupplierItemList extends StatelessWidget {
  final SupplierNearByMeModel _model;
  const _HomeSupplierItemList(this._model);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30),
            width: 1.sw,
            height: 80.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _model.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                            ),
                            Text(
                                '${_model.distance.toStringAsFixed(2)} Km de distância'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: CircleAvatar(
                    backgroundColor: context.primaryColor,
                    maxRadius: 15,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 1),
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 5,
                ),
                color: Colors.grey,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: AssetImage(_model.logo),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeSupplierGrid extends StatelessWidget {
  // ignore: unused_element
  const _HomeSupplierGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}
