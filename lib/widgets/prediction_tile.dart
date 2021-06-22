
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:uber/data_models/predection.dart';

import '../brand_colors.dart';


class PredictionTile extends StatelessWidget {

  final Prediction prediction;

  PredictionTile({this.prediction});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 8,),
          GestureDetector(
            onTap: (){

            },
            child: Row(
              children: [
                Icon(OMIcons.locationOn, color: BrandColors.colorDimText,),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prediction.mainText,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),),
                      SizedBox(height: 2,),
                      Text(prediction.secondaryText, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12, color: BrandColors.colorDimText),),

                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
