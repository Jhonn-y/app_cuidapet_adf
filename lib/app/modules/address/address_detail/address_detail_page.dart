import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/size_screen_extension.dart';
import 'package:projeto_cuidapet/app/core/ui/extensions/theme_extension.dart';
import 'package:projeto_cuidapet/app/core/ui/widgets/default_button.dart';
import 'package:projeto_cuidapet/app/model/place_model.dart';

class AddressDetailPage extends StatefulWidget {
  final PlaceModel place;
  const AddressDetailPage({super.key, required this.place});

  @override
  State<AddressDetailPage> createState() => _AddressDetailPageState();
}

class _AddressDetailPageState extends State<AddressDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0x00000000)),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0),
            child: Text(
              'Confirme seu endereço',
              style: context.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.place.lat,
                    widget.place.lng,
                  ),
                  zoom: 15,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('AddressID'),
                    position: LatLng(
                      widget.place.lat,
                      widget.place.lng,
                    ),
                    infoWindow: InfoWindow(title: widget.place.address),
                  ),
                }),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.place.address,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Endereço',
                suffixIcon: Icon(Icons.edit),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                decoration: InputDecoration(
              labelText: 'Complemento',
            )),
          ),
          SizedBox(
            height: 60.h,
            width: .9.sw,
            child: DefaultButton(
              onPressed: () {},
              label: 'Salvar',
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
