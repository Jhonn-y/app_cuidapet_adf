import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

typedef TryAgain = void Function();

mixin LocationMixin<E extends StatefulWidget> on State<E> {
  void showDialogLocationUnavailable() {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text('Precisamos do seu permissão para usar a localização.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Geolocator.openLocationSettings(),
              child: Text('Abrir configurações'),
            ),
          ],
        );
      },
    );
  }

  void showDialogLocationDenied(TryAgain? tryAgain) {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text('Precisamos do seu permissão para usar a localização.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                if (tryAgain != null) {
                  tryAgain();
                }
              },
              child: Text('Tentar Novamente'),
            ),
          ],
        );
      },
    );
  }

  void showDialogLocationDeniedForever() {
    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text(
              'Precisamos do seu permissão para usar a localização, clique no botão para abrir as Configurações!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(contextDialog);
                Geolocator.openLocationSettings();
              },
              child: Text('Abrir Configurações'),
            ),
          ],
        );
      },
    );
  }
}
