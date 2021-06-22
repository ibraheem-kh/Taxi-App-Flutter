import 'package:flutter/material.dart';
import 'package:uber/brand_colors.dart';


class TaxiButton extends StatelessWidget {

  const TaxiButton({@required this.buttonText,@required this.buttonColor, @required this.onPressed});

  final String buttonText;
  final Color buttonColor;
  final Function onPressed;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(buttonText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Brand-Bold',
          ),
        ),
      ),
    );
  }
}
