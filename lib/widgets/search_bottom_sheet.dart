import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';
import 'package:uber/brand_colors.dart';
import 'package:uber/data_provider/app_data.dart';
import 'package:uber/screens/main_page.dart';
import 'package:uber/screens/search_page.dart';
import 'package:uber/widgets/brand_divider.dart';

class BottomMenu extends StatefulWidget {

  BottomMenu({@required this.sheetHeight});

  double sheetHeight;

  @override
  _BottomMenuState createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15.0,
            spreadRadius: 0.5,
            offset: Offset(
             0.7,
             0.7,
            )
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
        ),),
      height:widget.sheetHeight,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Nice to see you!',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Where are you going?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => SearchPage()
                  ));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                    ),
                    SizedBox(width: 20,),
                    Text(
                      'Search destination',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BottomCard(
              icon: OMIcons.home,
              title: 'Add Home',
              destination: 'Your residental address',
              onPressed: ()async{
              },
            ),
            BrandDivider(),


            BottomCard(
              icon: OMIcons.workOutline,
              title: 'Work',
              destination: 'Your office address',
              onPressed: (){

              },
            ),
          ],
        ),
      ),
    );
  }
}

class BottomCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final Function onPressed;
  final String destination;

  const BottomCard({this.icon, this.title, this.onPressed,this.destination});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Icon(
            icon,
            color: BrandColors.colorDimText,
          ),
          SizedBox(
            width: 15.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: TextStyle(color:Colors.black87,),),
              Text(destination,style: TextStyle(color:BrandColors.colorDimText,fontSize: 10),),
            ],
          ),

        ],
      ),
    );
  }
}
