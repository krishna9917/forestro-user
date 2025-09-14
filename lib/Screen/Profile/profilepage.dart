import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Screen/Profile/update_profile.dart';
import 'package:foreastro/Screen/Profile/wigit/title_widget.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/extensions/build_context.dart';
import 'package:foreastro/model/profile_model.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Components/Widgts/shadow_widget.dart';
import 'package:foreastro/Components/Widgts/status_indicator_widget.dart';
// Import the profile model
import 'package:foreastro/Utils/assets.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const ProfilePage({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profileController = Get.find<ProfileList>();
  bool? isOnline;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
    Get.find<ProfileList>().fetchProfileData();
  }
  // @override
  // void initState() {
  //   Get.find<ProfileList>().fetchProfileData();
  //   super.initState();
  // }

  void changeProfileDetails(Data profileData) {
    // navigate.push(routeMe(UpdateProfileScreen(profileData: profileData)));
    context.go(UpdateProfileScreen(profileData: profileData));
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        automaticallyImplyLeading: true,
        backgroundColor: AppColor.secondary,
      ),
      body: Obx(() {
        if (profileController.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else {
          final profileDataList = profileController.profileDataList;
          if (profileDataList.isNotEmpty) {
            return SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Gap(1.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                          width: 75,
                          height: 75,
                          child: profileDataList.first.profileImg != null
                              ? File(profileDataList.first.profileImg!)
                                      .existsSync()
                                  ? Image.file(
                                      File(profileDataList.first.profileImg!),
                                      fit: BoxFit.fill,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          profileDataList.first.profileImg!,
                                      placeholder: (context, url) =>
                                          CircularProgressIndicator(),
                                      fit: BoxFit.fill,
                                    )
                              : Image.asset(
                                  "assets/images/bg_astro.png",
                                  fit: BoxFit.fill,
                                ),
                        ),
                      ),

                      Gap(1.h),

                      /// Full Name
                      GestureDetector(
                          // onTap: changeProfileDetails,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            Gap(5.w),
                            Text(
                              (profileDataList.first.name != null &&
                                      profileDataList.first.name.isNotEmpty)
                                  ? profileDataList.first.name![0]
                                          .toUpperCase() +
                                      profileDataList.first.name!.substring(1)
                                  : 'NA',
                              style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.dp),
                            ),
                            Gap(2.w),
                          ])),
                      Gap(3.h),

                      /// Personal Details
                      GestureDetector(
                        onTap: () =>
                            changeProfileDetails(profileDataList.first),
                        child: ShadowContainer(
                          blurRadius: 0.5,
                          borderRadius: 10,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Column(
                            children: [
                              Gap(1.h),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(
                                    horizontal: -4, vertical: -4),
                                title: Text(
                                  "Personal Details",
                                  style: GoogleFonts.inter(),
                                  // style: textStyle
                                ),
                                trailing: SvgPicture.asset(
                                  Assets.iconEditPencil,
                                  height: 2.5.h,
                                ),
                              ),
                              FlexibleGridView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                axisCount: GridLayoutEnum.twoElementsInRow,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                children: [
                                  TitleWidget(
                                    title: "Email",
                                    subTitle:
                                        profileDataList.first.email ?? 'NA',
                                  ),

                                  TitleWidget(
                                    title: "Phone No",
                                    subTitle:
                                        profileDataList.first.phone ?? 'NA',
                                  ),

                                  TitleWidget(
                                    title: "Gender",
                                    subTitle:
                                        profileDataList.first.gender ?? 'NA',
                                  ),

                                  TitleWidget(
                                    title: "Zodiac Sign",
                                    subTitle:
                                        profileDataList.first.sign ?? 'NA',
                                  ),

                                  TitleWidget(
                                    title: "State",
                                    subTitle:
                                        profileDataList.first.state ?? 'NA',
                                  ),

                                  TitleWidget(
                                    title: "City",
                                    subTitle:
                                        profileDataList.first.city ?? 'NA',
                                  ),
                                  TitleWidget(
                                    title: "Birth Time",
                                    subTitle:
                                        profileDataList.first.birthTime ?? 'NA',
                                  ),
                                  TitleWidget(
                                    title: "Date of Birth",
                                    subTitle:
                                        profileDataList.first.dateOfBirth ??
                                            'NA',
                                  ),

                                  /// DOB
                                  // Text(profileDataList.first.name ?? 'NA')
                                ],
                              ),
                              Gap(2.h),
                            ],
                          ),
                        ),
                      ),
                      // child: Container(
                      //   //...
                      //   child: Column(
                      //     children: [
                      //       // Display profile data here
                      //       for (var data in profileDataList) Text(data.name ?? 'NA'),
                      //       //...
                      //     ],
                      //   ),
                      // ),
                    ])));
          } else {
            return Center(child: Text('No data found'));
          }
        }
      }),
    );
  }
}
