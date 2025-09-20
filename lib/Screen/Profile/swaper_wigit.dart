// import 'package:flutter/material.dart';
// import 'package:foreastro/controler/baner_controler.dart';
// import 'package:foreastro/model/banner_model.dart';
// import 'package:get/get.dart';

// class SwiperWidget extends StatelessWidget {
//   const SwiperWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height * 0.20,
//       child: Swiper(
//         autoplayDelay: kDefaultAutoplayDelayMs,
//         viewportFraction: 1,
//         duration: kDefaultAutoplayDelayMs,
//         itemBuilder: (BuildContext context, int index) {
//           final List<BannerModel> banners = Get.find<BannerList>().bannerDataList;
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Image.network(
//               banners[index % banners.length].bannerUrl,
//               fit: BoxFit.fill,
//             ),
//           );
//         },
//         itemCount: Get.find<BannerList>().bannerDataList.length,
//         autoplay: true,
//         pagination: const SwiperPagination(alignment: Alignment.bottomCenter),
//         control: const SwiperControl(),
//       ),
//     );
//   }
// }
