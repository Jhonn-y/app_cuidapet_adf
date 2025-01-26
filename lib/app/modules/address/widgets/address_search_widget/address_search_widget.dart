// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../../address_page.dart';

typedef AddressSelectedCallback = void Function(PlaceModel);

class _AddressSearchWidget extends StatefulWidget {
  final AddressSelectedCallback addressSelectedCallback;
  final PlaceModel? place;

  const _AddressSearchWidget({
    super.key,
    required this.addressSelectedCallback,
    required this.place,
  });

  @override
  State<_AddressSearchWidget> createState() => _AddressSearchWidgetState();
}

class _AddressSearchWidgetState extends State<_AddressSearchWidget> {
  final _searchTextEC = TextEditingController();
  final _searchTextFN = FocusNode();

  final _controller = Modular.get<AddressSearchController>();

  @override
  void initState() {
    super.initState();
    if (widget.place != null) {
      _searchTextEC.text = widget.place?.address ?? '';
      _searchTextFN.requestFocus();
    }
  }

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
        controller: _searchTextEC,
        focusNode: _searchTextFN,
        builder: (_, controller, focusNode) => TextField(
          controller: controller,
          focusNode: focusNode,
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
  const _ItemTile({
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.location_on),
      title: Text(address),
    );
  }
}
