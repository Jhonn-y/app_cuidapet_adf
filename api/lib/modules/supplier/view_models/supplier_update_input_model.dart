
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class SupplierUpdateInputModel extends RequestMapping{

  int supplierID;
  late String name;
  late String logo;
  late String address;
  late String phone;
  late double lat;
  late double lng;
  late int categoryID;


  
  SupplierUpdateInputModel({required this.supplierID, required String dataRequest}) : super(dataRequest);

  @override
  void map() {
    name = data['name'];
    logo = data['logo'];
    address = data['address'];
    phone = data['phone'];
    lat = data['lat'];
    lng = data['lng'];
    categoryID = data['category'];
  }
  
}