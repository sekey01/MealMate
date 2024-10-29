import 'package:card_loading/card_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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



/// THIS DISPLAYS IF  THE LOADING OUTLOOK FOR EMPTY COLLECTION
class NewSearchLoadingOutLook extends StatelessWidget {
  const NewSearchLoadingOutLook({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: LinearProgressIndicator( color: Colors.grey.shade50,),
          ),
          SizedBox(height: 10),
          Container(
            height: 20,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: LinearProgressIndicator(color: Colors.grey.shade50,),

          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LinearProgressIndicator(color: Colors.grey.shade50,),

              ),
              SizedBox(width: 10),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LinearProgressIndicator(color: Colors.grey.shade50,),

              ),
              SizedBox(width: 10),
              Container(
                height: 20,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: LinearProgressIndicator(color: Colors.grey.shade50,),

              ),
            ],
          )
        ],
      ),
    );
  }
}

//// THIS DISPLAYS IF  THE LOADING OUTLOOK FOR EMPTY COLLECTION

class EmptyCollection extends StatefulWidget {
  const EmptyCollection({super.key});

  @override
  State<EmptyCollection> createState() => _EmptyCollectionState();
}

class _EmptyCollectionState extends State<EmptyCollection> {
  @override
  Widget build(BuildContext context) {
    return   CardLoading(
        animationDuration: Duration(seconds: 5),
        animationDurationTwo: Duration(seconds: 5),cardLoadingTheme: CardLoadingTheme.defaultTheme,
        borderRadius: BorderRadius.circular(10),
        height: 100,
        child: Container(
          height: 200,
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image(image: AssetImage("assets/Icon/no_food_found.png"), height: 50, width: 150,),
              ),
              SizedBox(height: 10),
              Container(
                height: 20,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    height: 20,
                    width: 110,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
    );;
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
