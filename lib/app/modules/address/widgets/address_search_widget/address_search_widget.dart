// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../address_page.dart';

typedef AddressSelectedCallback = void Function(PlaceModel); 
class _AddressSearchWidget extends StatefulWidget {

  final AddressSelectedCallback addressSelectedCallback;

  _AddressSearchWidget({
    required this.addressSelectedCallback,
  });

  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  final _searchTextEC = TextEditingController();
  final _searchTextFN = FocusNode();

  final _controller = Modular.get<AddressSearchController>();

  @override
  void dispose() {
    _searchTextEC.dispose();
    _searchTextFN.dispose();
    super.dispose();
  }

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
          controller: _searchTextEC,
          focusNode: _searchTextFN,
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

  Future<List<PlaceModel>> _suggestionsCallback(String pattern) async {
    if (pattern.isNotEmpty) {
      return _controller.searchAddress(pattern);
    }

    return [];
  }

  void _onSelected(PlaceModel suggestion) {
    _searchTextEC.text = suggestion.address;
    widget.addressSelectedCallback(suggestion);

  }
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
