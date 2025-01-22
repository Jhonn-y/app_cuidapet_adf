part of '../address_page.dart';

class _AddressSearchWidget extends StatefulWidget {
  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(style: BorderStyle.none));

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(20),
      child: TypeAheadField<PlaceModel>(
        builder: (context, controller, focusNode) => TextField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.location_on),
              hintText: 'Insira um endereço',
              border: border,
              disabledBorder: border,
              enabledBorder: border),
        ),
        itemBuilder: (_, item) {
          return _ItemTile(
            address: item.address,
          );
        },
        onSelected: _onSelected,
        suggestionsCallback: _suggestionsCallback,
      ),
    );
  }

  FutureOr<List<PlaceModel>?> _suggestionsCallback(String pattern) {
    return [];
  }

  void _onSelected(PlaceModel suggestion) {}
}

class _ItemTile extends StatelessWidget {
  final String address;

  const _ItemTile({required this.address});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text(address),
    );
  }
}
