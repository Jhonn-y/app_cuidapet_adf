
import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class ScheduleSaveInputModel extends RequestMapping{
  int userID;
  late DateTime scheduleDate;
  late String name;
  late String petName;
  late int supplierID;
  late  List<int> services;

  ScheduleSaveInputModel({required this.userID, required String dataRequest }) : super(dataRequest);
  
  @override
  void map() {
    
    scheduleDate = DateTime.parse(data['schedule_date']);
    supplierID = data['supplier_id'];
    services = List.castFrom<dynamic,int>(data['services']);
    name = data['name'];
    petName = data['pet_name'];
  }



}