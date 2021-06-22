import 'package:flutter/cupertino.dart';
import 'package:uber/data_models/address.dart';

class AppData extends ChangeNotifier{

  Address pickupAddress;

  void updatePickupAddress(Address pickup){
    pickupAddress = pickup;
    notifyListeners();
  }
}