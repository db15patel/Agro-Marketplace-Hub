import 'package:agrocart/utils/agrocart.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> imageUrls;
  CustomCarousel({this.imageUrls});
  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  var pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
          children:[ Container(
        width: double.infinity,
        child: CarouselSlider(
          options: CarouselOptions(
            height: 192,
            viewportFraction: 1.0,
            autoPlay: false,
            onPageChanged: (index, CarouselPageChangedReason reason) {
              setState(() {
                pageIndex = index;
              });
            },
          ),
          items: widget.imageUrls.map((i) {
            return Builder(builder: (BuildContext context) {
              return Ink(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: AgrocartUniversal.customBoxShadow),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FadeInImage(
                      image: NetworkImage(i),
                      fit: BoxFit.cover,
                      placeholder: AssetImage(
                        'assets/yello.jpg',
                      ),
                    ),
                  ));
            });
          }).toList(),
        ),),
        SizedBox(height: 5 ,),
         Container(
                  height: 12,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.imageUrls.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 5,
                                width: index == pageIndex ? 15 : 5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: AgrocartUniversal.contrastColor,
                                )));
                      })),
    
          ]);
  }
}
