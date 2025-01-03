import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PromotionAdsCard extends StatefulWidget {
  const PromotionAdsCard({super.key, required this.heading, required this.headingColor, required this.content, required this.contentColor, required this.image, required this.backgroundColor});
final String heading;
final Color headingColor;
final String content;
final Color contentColor;
final String image;
final Color backgroundColor;

  @override
  State<PromotionAdsCard> createState() => _PromotionAdsCardState();
}

class _PromotionAdsCardState extends State<PromotionAdsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 340,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${widget.heading}',
                    style: TextStyle(
                      fontFamily: 'Righteous',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                      //letterSpacing: 2,
                      color: widget.headingColor,
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    '${widget.content}',
                    softWrap: true,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: widget.contentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(60),
                  bottomLeft: Radius.circular(60),
                ),
                child: Image(
                  fit: BoxFit.fill,
                  image: AssetImage(widget.image),
                  height: 50,
                  width: 150,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}