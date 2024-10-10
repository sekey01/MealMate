import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';

class CustomLoGoLoading extends StatelessWidget {
  const CustomLoGoLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardLoading(
        borderRadius: BorderRadius.circular(10),
        height: 100,
        child: Image(
          image: AssetImage("assets/images/logo.png"),
          height: 50, width: 150,
          //borderRadius: BorderRadius.all(Radius.circular(10)),
          //margin: EdgeInsets.only(bottom: 10),
          //animationDuration: Duration(seconds: 2),
        ));
  }
}



class SearchLoadingOutLook extends StatelessWidget {
  const SearchLoadingOutLook({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardLoading(
        borderRadius: BorderRadius.circular(10),
        height: 100,
        child: Image(
          image: AssetImage("assets/images/logo.png"),
          height: 50, width: 150,
          //borderRadius: BorderRadius.all(Radius.circular(10)),
          //margin: EdgeInsets.only(bottom: 10),
          //animationDuration: Duration(seconds: 2),
        ));
  }
}
