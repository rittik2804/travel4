// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

class ImagesCarousel extends StatefulWidget {
  final List<String> photos;
  bool isTrue;

  ImagesCarousel({
    required this.photos,
    this.isTrue = false,
  });

  @override
  _ImagesCarouselState createState() => _ImagesCarouselState();
}

class _ImagesCarouselState extends State<ImagesCarousel> {
  int _current = 0;

  CarouselController _carouselController = CarouselController();

  final min = 1;
  final max = 10000;
  final random = Random();
  int randomNumber = 0;

  @override
  void initState() {
    randomNumber = min + random.nextInt(max - min + 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              aspectRatio: widget.isTrue ? 10 / 9 : 16 / 9,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
            items: widget.photos
                .map((photo) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                          imageUrl: photo,
                          placeholder: (context, url) =>
                              Image.asset('assets/images/loading.gif'),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/no.jpg'),
                          imageBuilder: (context, imageProvider) =>
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration.zero,

                                        pageBuilder: (context, animation, secondaryAnimation) {
                                          return  ImageScreen(
                                            imageProvider: imageProvider,
                                            randomNumber: randomNumber,
                                          );
                                        },
                                      ));
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (context) => ImageScreen(
                                  //       imageProvider: imageProvider,
                                  //       randomNumber: randomNumber,
                                  //     ),
                                  //   ),
                                  // );
                                },
                                child: Hero(
                                  tag: 'imageHero$randomNumber',
                                  child: FadeInImage(
                                    image: imageProvider,
                                    placeholder:
                                        AssetImage('assets/images/loading.gif'),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              )),
                    ))
                .toList(),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.photos.map((photo) {
              int index = widget.photos.indexOf(photo);
              return GestureDetector(
                onTap: () {
                  _carouselController.jumpToPage(index);
                },
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: _current == index ? Colors.blue : Colors.grey,
                      width: _current == index ? 3.0 : 2.0,
                    ),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(3.0),
                      child: CachedNetworkImage(
                        imageUrl: photo,
                        placeholder: (context, url) =>
                            Image.asset('assets/images/loading.gif'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/images/no.jpg'),
                        imageBuilder: (context, imageProvider) => FadeInImage(
                          image: imageProvider,
                          placeholder: AssetImage('assets/images/loading.gif'),
                          fit: BoxFit.cover,
                        ),
                      )),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class ImageScreen extends StatelessWidget {
  final ImageProvider imageProvider;
  final randomNumber;

  const ImageScreen({
    Key? key,
    required this.imageProvider,
    required this.randomNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'imageHero$randomNumber',
            child: PhotoView(
              imageProvider: imageProvider,
            ),
          ),
        ),
      ),
    );
  }
}
