part of '../address_page.dart';

class _AddressItem extends StatelessWidget {
  final VoidCallback? callback;
  final String address;
  final String additional;
  const _AddressItem(
      {this.callback, required this.address, required this.additional});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        onTap: callback,
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Icon(
            Icons.location_on,
            color: Colors.black,
          ),
        ),
        title: Text(address),
        subtitle: Text(additional),
      ),
    );
  }
}
