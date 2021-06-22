import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:uber/helpers/helperMethods.dart';
import 'package:uber/styles/styles.dart';
import 'package:uber/widgets/brand_divider.dart';
import 'package:uber/widgets/menu_top_corner.dart';
import 'package:uber/widgets/search_bottom_sheet.dart';

class MainPage extends StatefulWidget {
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.963158, 35.930359),
    zoom: 14.4746,
  );
  static const String id = 'main_page';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  double searchSheetHeight = (Platform.isAndroid) ? 250 : 300;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  double mapBottomPadding = 0;
  double mapTopPadding = -10.0;

  static var geoLocator = Geolocator();
  Position currentPosition;

  void setupPositionLocator() async {
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = new CameraPosition(target: pos, zoom: 14);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cp));

    final String address = await HelperMethods.findCordinateAddress(position, context);
    print(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
        width: 256,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Container(
                color: Colors.white,
                height: 175,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'images/user_icon.png',
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'User Name',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Brand-Bold',
                            ),
                          ),
                          TextButton(
                            child: Text('View Profile'),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              BrandDivider(),
              ListTileDrawer(
                title: 'Free Rides',
                iconData: OMIcons.cardGiftcard,
                onPressed: () async {
                  print(await geoLocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.bestForNavigation));
                },
              ),
              ListTileDrawer(
                title: 'Payment',
                iconData: OMIcons.payment,
                onPressed: () {
                },
              ),
              ListTileDrawer(
                title: 'Rides History',
                iconData: OMIcons.history,
                onPressed: () {},
              ),
              ListTileDrawer(
                title: 'Support',
                iconData: OMIcons.contactSupport,
                onPressed: () {},
              ),
              ListTileDrawer(
                title: 'about',
                iconData: OMIcons.info,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapBottomPadding, top: mapTopPadding),
            initialCameraPosition: MainPage._kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              mapController = controller;

              setState(() {
                mapBottomPadding = (Platform.isAndroid) ? 250 : 280;
                mapTopPadding = (Platform.isAndroid)? 60 : 80;
              });

              setupPositionLocator();
            },
          ),

          ///MenuButton
          Positioned(
            left: 15,
            top: 60,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5.0,
                          spreadRadius: 0.5,
                          offset: Offset(
                            0.7,
                            0.7,
                          )),
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),

          /// SearchSheet
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomMenu(
                sheetHeight: searchSheetHeight,
              )),

          // Positioned(
          //   left: 0,
          //   right: 340,
          //   top: 15,
          //   child: MenuButton(),
          // ),
        ],
      ),
    );
  }
}

class ListTileDrawer extends StatelessWidget {
  ListTileDrawer({this.title, this.iconData, @required this.onPressed});
  final String title;
  final Function onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: KDrawerItemStyle),
      leading: Icon(iconData),
      onTap: onPressed,
    );
  }
}
