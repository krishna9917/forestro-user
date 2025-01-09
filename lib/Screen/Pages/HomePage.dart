import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/Drawer/AppDrawer.dart';
import 'package:foreastro/Components/HomeTitleBar.dart';
import 'package:foreastro/Components/TaskTabs.dart';
import 'package:foreastro/Components/User/LiveProfileView.dart';
import 'package:foreastro/Components/User/OnlineAstroCard.dart';
import 'package:foreastro/Components/Widgts/BottamBar.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/ExploreAstroPage.dart';
import 'package:foreastro/Screen/Pages/Explore/bloc_detailes.dart';
import 'package:foreastro/Screen/Pages/Explore/search_astro.dart';
import 'package:foreastro/Screen/Pages/NotificationsPage.dart';
import 'package:foreastro/Screen/Pages/WalletPage.dart';
import 'package:foreastro/Screen/Pages/innerpage/bloc_viewall.dart';
import 'package:foreastro/Screen/Pages/innerpage/celeb_insights.dart';
import 'package:foreastro/Screen/Pages/innerpage/our_client_says.dart';
import 'package:foreastro/Screen/Pages/innerpage/youtub_play.dart';
import 'package:foreastro/Screen/Pages/service_page.dart';
import 'package:foreastro/Screen/Profile/profilepage.dart';
import 'package:foreastro/Utils/Quick.dart';
import 'package:foreastro/controler/baner_controler.dart';
import 'package:foreastro/controler/bloc_controler.dart';
import 'package:foreastro/controler/celebrity_controler.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:foreastro/controler/listof_termination_controler.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/controler/soket_controler.dart';
import 'package:foreastro/model/listaustro_model.dart';
import 'package:foreastro/theme/Colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bannerController = Get.put(BannerList());
  final BlocList blocListController = Get.put(BlocList());
  final SocketController socketController = Get.put(SocketController());
  bool? isOnline;
  final TextEditingController _searchController = TextEditingController();

  RxList<Data> _astrologers = RxList<Data>();
  final profileController = Get.find<ProfileList>();

  @override
  void initState() {
    fetchAndInitProfile();
    Get.find<ProfileList>().fetchProfileData();
    Get.put(BlocList()).blocData();
    Get.put(CelibrityList()).celibrityData();
    Get.put(ClientSays()).clientsaysData();
    Get.put(GetAstrologerProfile()).astroData();
    socketController.initSocketConnection();
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void _onSearchChanged() {
    if (_searchController.text.length >= 3) {
      _filterAstrologers(_searchController.text);
    } else {
      _astrologers.clear();
    }
  }

  Future<void> fetchAndInitProfile() async {
    await Get.find<ProfileList>().fetchProfileData();
    await ZIMKit().init(
        appID: 2007373594,
        appSign:
            '387754e51af7af0caf777a6a742a2d7bcfdf3ea1599131e1ff6cf5d1826649ae');
    await chatzegocloud();
  }

  Future<void> chatzegocloud() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user_id = prefs.getString('user_id');

    if (user_id == null) {
      print('User ID not found in SharedPreferences');
      return;
    }

    String profile = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.profileImg
        : '';

    String name = profileController.profileDataList.isNotEmpty
        ? profileController.profileDataList.first.name
        : '';

    if (name.isEmpty) {
      print("Name not found");
      return;
    }

    print("name=======$name $user_id $profile  --   $user_id-user");

    await ZIMKit().connectUser(
      id: "$user_id-user",
      name: name,
      avatarUrl: profile,
    );
  }

  Future<void> _filterAstrologers(String query) async {
    final List<Data> astrologers =
        Get.find<GetAstrologerProfile>().astroDataList;
    final List<Data> filteredAstrologers = astrologers
        .where((astrologer) =>
            astrologer.name?.toLowerCase().contains(query.toUpperCase()) ??
            false)
        .toList();
    _astrologers.clear();
    _astrologers.addAll(filteredAstrologers);
  }

  String extractVideoId(String url) {
    RegExp regExp = RegExp(
        r"(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})");
    Iterable<RegExpMatch> matches = regExp.allMatches(url);
    if (matches.isNotEmpty) {
      return matches.first.group(1)!;
    }
    return '';
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var outlineInputBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(50)),
      borderSide: BorderSide(
        width: 1,
        color: Color.fromARGB(255, 226, 226, 226),
      ),
    );
    return PopScope(
      canPop: false,
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: AppColor.bgcolor,
          extendBody: true,
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: AppColor.bgcolor,
            leading: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState!.openDrawer();
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(left: 8.0),
                child: Center(
                  child: SvgPicture.asset(
                    "assets/icons/nav.svg",
                    height: 20,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    navigate.push(routeMe(const SearchPage()));
                  },
                  icon: Icon(
                    Icons.search,
                    color: AppColor.primary,
                    size: 30,
                  )),
              GestureDetector(
                onTap: () {
                  navigate.push(routeMe(const WalletPage()));
                },
                child: Container(
                  width: 95,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Obx(
                      () {
                        if (profileController.profileDataList != null &&
                            profileController.profileDataList.isNotEmpty) {
                          String wallet =
                              profileController.profileDataList.first.wallet ??
                                  '0';
                          String formattedWallet = '0';
                          if (wallet != '0') {
                            try {
                              formattedWallet =
                                  double.parse(wallet).toStringAsFixed(2);
                            } catch (e) {
                              print("Error parsing wallet value: $e");
                            }
                          }

                          return Text(
                            "₹ $formattedWallet",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          );
                        } else {
                          if (profileController.profileDataList == null) {
                          } else if (profileController
                              .profileDataList.isEmpty) {}
                          return Text(
                            '0',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.w500),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  navigate.push(routeMe(const NotificationPage()));
                },
                child: Badge(
                  backgroundColor: AppColor.primary,
                  label: const Text(
                    "24",
                    style: TextStyle(fontSize: 10),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/notic.svg",
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return _astrologers.isEmpty
                        ? const Center(child: Text(''))
                        : ListView.builder(
                            itemCount: _astrologers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_astrologers[index].name ?? 'NA'),
                              );
                            },
                          );
                  },
                ),
                Obx(
                  () {
                    if (bannerController.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      final bannerList = bannerController.dataList;

                      if (bannerList.isNotEmpty) {
                        return CarouselSlider(
                          options: CarouselOptions(
                            height: 160.0,
                            viewportFraction: 0.9,
                            autoPlay: true,
                          ),
                          items: bannerList.map((imageUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        );
                      } else {
                        return const Center(
                            child: Text('No banners available'));
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our Top Astrologers".toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                          "500+ Best Astrologers from India for Online Consultation")
                    ],
                  ),
                ),
                const HomeTitleBar(
                  title: "Live Video CAll",
                ),
                const SizedBox(height: 15),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      LiveProfileView(),
                      SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                HomeTitleBar(
                  title: "Astrologer",
                  onClick: () {
                    navigate.push(routeMe(const ExploreAstroPage()));
                  },
                ),

                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OnlineAstroCard(),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TaskTabs(),
                ////////////////////////////////////////////////////////////////////////////////////////////////////
                // Client Says //
/////////////////////////////////////////////////////////////////////////////////////////////////////////
                // const SizedBox(height: 20),
                HomeTitleBar(
                  title: "What our client Says",
                  desc: "Discover what our stargazers have to say",
                  onClick: () {
                    navigate.push(routeMe(const OurClientSays()));
                  },
                ),
                GetBuilder<ClientSays>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              controller.clientsaysDataList.length,
                              (index) {
                                final data =
                                    controller.clientsaysDataList[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        width: 1,
                                        color:
                                            AppColor.primary.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              child: data.image != null
                                                  ? Image.network(
                                                      data.image!,
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return const Icon(
                                                            Icons.error);
                                                      },
                                                    )
                                                  : const Icon(Icons.person,
                                                      size: 50),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data.name ?? 'NA',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  if (data.rating != null)
                                                    Row(
                                                      children: List.generate(
                                                        double.parse(controller
                                                                .clientsaysDataList[
                                                                    index]
                                                                .rating
                                                                .toString())
                                                            .toInt(),
                                                        (_) => Icon(
                                                          Icons.star,
                                                          color:
                                                              AppColor.primary,
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Builder(
                                            builder: (context) {
                                              final comment =
                                                  data.comment ?? 'NA';

                                              final words = comment.split(' ');
                                              final chunkedText = List.generate(
                                                (words.length / 7).ceil(),
                                                (index) => words
                                                    .skip(index * 7)
                                                    .take(7)
                                                    .join(' '),
                                              ).join('\n');

                                              return Text(
                                                chunkedText,
                                                maxLines: null,
                                                overflow: TextOverflow.visible,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),
                HomeTitleBar(
                  title: "Latest blogs",
                  desc: "Stay in the cosmic loop and explore our blogs!",
                  onClick: () {
                    navigate.push(routeMe(const BlocViewAll()));
                  },
                ),
                GetBuilder<BlocList>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          height: 210,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              controller.blocDataList.length,
                              (index) => GestureDetector(
                                onTap: () {
                                  var a = controller.blocDataList[index].id;

                                  String id = a.toString();
                                  navigate.push(routeMe(BlocDetailes(
                                    id: id,
                                  )));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 190,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: Image.network(
                                          controller
                                                  .blocDataList[index].image ??
                                              'NA',
                                          width: 450,
                                          height: 140,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // const SizedBox(height: 8),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            controller.blocDataList[index]
                                                    .title ??
                                                'NA',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),

                HomeTitleBar(
                  title: "Celeb Insights",
                  desc: "Celebrities Share Their Astrological Insights",
                  onClick: () {
                    navigate.push(routeMe(const Celebinsights()));
                  },
                ),

                GetBuilder<CelibrityList>(
                  builder: (controller) {
                    return Obx(() {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return Container(
                          height: 200,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              controller.celibrityDataList.length,
                              (index) {
                                final celebrity =
                                    controller.celibrityDataList[index];
                                var videoUrl = celebrity.video.toString();
                                print("videoUrl====$videoUrl");

                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  width: 210,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: InkWell(
                                          onTap: () {
                                            if (videoUrl != null) {
                                              navigate.push(routeMe(VideoPlay(
                                                videoUrl: videoUrl,
                                              )));
                                            } else {
                                              print(
                                                  'Video ID is null, cannot play video.');
                                            }
                                          },
                                          child: Image.network(
                                            celebrity.thumbnail ??
                                                'https://via.placeholder.com/550x140.png?text=No+Image',
                                            width: 550,
                                            height: 140,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // const SizedBox(height: 8),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            celebrity.title ?? 'NA',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                    });
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
          drawer: const AppDrawer(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.phone,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              navigate.push(routeMe(const ExploreAstroPage()));
            },
          ),
          bottomNavigationBar: const BottamBar(
            index: 0,
          )),
    );
  }
}

class BottamBar extends StatelessWidget {
  final int index;
  const BottamBar({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(useMaterial3: false),
      child: StylishBottomBar(
        // elevation: 0,
        option: AnimatedBarOptions(),
        items: [
          activeBottamBar(
            activeImage: "home-active.svg",
            inactiveImage: "home.svg",
            activeIndex: 0,
            index: index,
            title: "Home",
          ),
          activeBottamBar(
            activeImage: "chat-active.svg",
            inactiveImage: "chat.svg",
            activeIndex: 1,
            index: index,
            title: "Chat",
            alineRight: true,
          ),
          activeBottamBar(
            activeImage: "wallet-active.svg",
            inactiveImage: "wallet.svg",
            activeIndex: 1,
            index: index,
            title: "Wallet",
            alineLeft: true,
          ),
          activeBottamBar(
            activeImage: "profile-active.svg",
            inactiveImage: "profile.svg",
            activeIndex: 1,
            index: index,
            title: "Profile",
          )
        ],
        fabLocation: StylishBarFabLocation.center,
        hasNotch: true,
        notchStyle: NotchStyle.circle,
        currentIndex: index,
        onTap: (index) {
          switch (index) {
            case 1:
              navigate.push(routeMe(const ServicesPage()));
              break;
            case 2:
              navigate.push(routeMe(const WalletPage()));
              break;
            case 3:
              navigate.push(routeMe(const ProfilePage()));
              break;
            default:
          }
        },
      ),
    );
  }
}
