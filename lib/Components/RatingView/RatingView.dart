import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:foreastro/theme/Colors.dart';

Widget ViewRating({double initialRating = 0.0}) {
  return RatingBar.builder(
    initialRating: 3,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemSize: 16,
    unratedColor: AppColor.primary.withOpacity(0.1),
    itemPadding: EdgeInsets.symmetric(horizontal: 0),
    itemBuilder: (context, _) => Icon(
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: (rating) {
      print(rating);
    },
  );
}

class RatingReviewBox extends StatefulWidget {
  const RatingReviewBox({
    super.key,
  });

  @override
  State<RatingReviewBox> createState() => _RatingReviewBoxState();
}

class _RatingReviewBoxState extends State<RatingReviewBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: 320,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(width: 1, color: AppColor.primary.withOpacity(0.3))),
      child: Column(
        children: [
          Row(
            children: [
              viewImage(
                url:
                    "https://buffer.com/library/content/images/size/w1200/2023/10/free-images.jpg",
                boxDecoration: BoxDecoration(),
                width: 40,
                height: 40,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sourav Bapari",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3),
                  ViewRating()
                ],
              )
            ],
          ),
          SizedBox(height: 15),
          Text(
            "There’s no other program that walks you through exactly what you need to know to start an online store fast, written by someone who has built several 7-figure ecommerce businesses from scratch. What’s more, everything has been broken down in step-by-step detail with real action plans including finding your niche0.",
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
