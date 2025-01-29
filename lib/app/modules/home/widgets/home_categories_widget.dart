part of '../home_page.dart';

class _HomeCategoriesWidget extends StatelessWidget {
  final HomeController _controller;
  const _HomeCategoriesWidget(this._controller);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 130,
        child: Observer(
          builder: (_) {
            return Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final category = _controller.listCategories[index];
                  return _CategoryItem(category,_controller);
                },
                scrollDirection: Axis.horizontal,
                itemCount: _controller.listCategories.length,
              ),
            );
          },
        ));
  }
}

class _CategoryItem extends StatelessWidget {
  final SupplierCategoryModel _categoryModel;
  final HomeController _controller;

  static const categoriesItem = {
    'P': Icons.pets,
    'V': Icons.local_hospital,
    'C': Icons.store_mall_directory
  };

  const _CategoryItem(this._categoryModel, this._controller);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _controller.filterCategory(_categoryModel),
      child: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Observer(
              builder: (_) {
                return CircleAvatar(
                  backgroundColor:
                      _controller.supplierCategoryFilterSelected?.id ==
                              _categoryModel.id
                          ? context.primaryColor
                          : Colors.grey[400],
                  radius: 30,
                  child: Icon(categoriesItem[_categoryModel.type],
                      size: 30, color: Colors.black),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(_categoryModel.name),
          ],
        ),
      ),
    );
  }
}
