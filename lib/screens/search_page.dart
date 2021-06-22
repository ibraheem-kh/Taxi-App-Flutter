import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber/data_models/predection.dart';
import 'package:uber/data_provider/app_data.dart';
import 'package:uber/global_variables.dart';
import 'package:uber/helpers/request_helpers.dart';
import 'package:uber/widgets/brand_divider.dart';
import 'package:uber/widgets/prediction_tile.dart';

import '../brand_colors.dart';


class SearchPage extends StatefulWidget {

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var pickupController = TextEditingController();
  var destinationController = TextEditingController();


  List<Prediction> destinationPredictionList = [];

  void searchPlace(String placeName) async{

    if(placeName.length > 1){
      String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:jo';
      var response= await RequestHelper.getRequest(url);

      if(response == 'failed'){
        return;
      }

      if(response['status'] == 'OK'){
        var predictionJson = response['predictions'];

        var thisList = (predictionJson as List).map((e) => Prediction.fromjson(e)).toList();

        setState(() {
          destinationPredictionList = thisList;
        });
        
      }

    }

  }


  @override
  Widget build(BuildContext context) {

    String address = Provider.of<AppData>(context).pickupAddress.placeName ?? '';
    pickupController.text = address;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 210,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5.0,
                  spreadRadius: 0.5,
                  offset: Offset(
                    0.7,
                    0.7,
                  ),
                ),
              ]
            ),
            child: Padding(
              padding: EdgeInsets.only(top:48, left: 24, right: 24, bottom: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        child: Icon(OMIcons.arrowBack),
                      onTap: (){
                          Navigator.pop(context);
                      },
                      ),
                      Center(
                        child: Text('Set Destination',
                          style: TextStyle(
                            fontSize: 15
                        ),),
                      ),
                    ],
                  ),
                  SizedBox(height: 18,),
                  Row(
                    children: [
                      Image.asset('images/pickicon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: TextField(
                              controller: pickupController,
                              decoration: InputDecoration(
                                hintText: 'Pickup location',
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 10,top: 8,bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Image.asset('images/desticon.png', height: 16, width: 16,),
                      SizedBox(width: 18,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: BrandColors.colorLightGrayFair,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(2.0),
                            child: TextField(
                              onChanged: (value){
                                searchPlace(value);
                              },
                              autofocus: true,
                              controller: destinationController,
                              decoration: InputDecoration(
                                hintText: 'Where to?',
                                fillColor: BrandColors.colorLightGrayFair,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 10,top: 8,bottom: 8),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
            ),
          ),

          (destinationPredictionList.length > 0) ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0),
                itemBuilder: (context, index){
                  return PredictionTile(
                    prediction: destinationPredictionList[index],
                  );
                },
                separatorBuilder: (BuildContext context, int index) => BrandDivider(),
                itemCount: destinationPredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
              : Container(),
        ],
      ),
    );
  }
}

