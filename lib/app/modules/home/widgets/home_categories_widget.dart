part of '../home_page.dart';

class _HomeCategoriesWidget extends StatelessWidget {
  const _HomeCategoriesWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _CategoryItem();
        },
        scrollDirection: Axis.horizontal,
        itemCount: 13,
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  _CategoryItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey[400],
            radius: 30,
            child: Icon(Icons.pets, size: 30, color: Colors.black),
          ),
          Text('Petshop'),
        ],
      ),
    );
  }
}
