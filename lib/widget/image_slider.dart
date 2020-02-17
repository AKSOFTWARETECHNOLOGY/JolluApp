import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:next_hour/apidata/apidata.dart';
import 'package:next_hour/global.dart';

//  Image slider showed on home page used this widget
class ImageSlider extends StatelessWidget {

//  Image swiper
  Widget imageSwiper(){
    return Swiper(
      scrollDirection: Axis.horizontal,
      loop: true,
      autoplay: true,
      duration: 500,
      autoplayDelay: 10000,
      autoplayDisableOnInteraction: true,
      itemCount: sliderData == null ? 0 : sliderData.length,
      // index: 0,
      itemBuilder: (BuildContext context, int index) {
        if (sliderData.isEmpty ?? true) {
          return null;
        } else {
          if(sliderData[index]['movie_id'] == null){
            if ("${APIData.silderImageUri}" +"shows/"+ "${sliderData[index]['slide_image']}" ==
                "${APIData.silderImageUri}"+"shows/"+ "null") {
              return null;
            } else {
              return new Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
                child: new Image.network(
                  "${APIData.silderImageUri}"+"shows/"+"${sliderData[index]['slide_image']}",
                  fit: BoxFit.cover,
                ),
              );
            }
          }else{
            if ("${APIData.silderImageUri}" +"movies/"+ "${sliderData[index]['slide_image']}" ==
                "${APIData.silderImageUri}"+"movies/"+ "null") {
              return null;
            } else {
              return new Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
                child: new Image.network(
                  "${APIData.silderImageUri}"+"movies/"+"${sliderData[index]['slide_image']}",
                  fit: BoxFit.cover,
                ),
              );
            }
          }

        }
      },
      viewportFraction: 0.93,
      pagination: new SwiperPagination(margin: EdgeInsets.only(bottom: 30.0,),
        builder: new DotSwiperPaginationBuilder(
          color: Colors.white, activeColor: Color.fromRGBO(125,183,91, 1.0),),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: imageSwiper(),
    );
  }
}
