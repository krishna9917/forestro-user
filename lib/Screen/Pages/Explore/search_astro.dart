import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foreastro/Helper/InAppKeys.dart';
import 'package:foreastro/Screen/Pages/Explore/astrology_detailes.dart';
import 'package:foreastro/controler/listaustro_controler.dart';
import 'package:get/get.dart';
import 'package:foreastro/model/listaustro_model.dart';
import 'package:foreastro/core/function/navigation.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GetAstrologerProfile astroController = Get.put(GetAstrologerProfile());

  final TextEditingController _searchController = TextEditingController();

  final Rx<List<Data>> _filteredAstrologers = Rx<List<Data>>([]);
  Timer? _updateTimer;
  @override
  void initState() {
    super.initState();

    // Periodically update the astrologer data every 5 seconds
    _updateTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      astroController.astroData(); // Re-fetch data from the server
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Astrologer"),
      ),
      body: Obx(() {
        if (astroController.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        _filteredAstrologers.value = astroController.astroDataList;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (query) {
                  final filtered =
                      astroController.astroDataList.where((astrologer) {
                    final nameLower = astrologer.name!.toLowerCase();
                    final queryLower = query.toLowerCase();
                    return nameLower.contains(queryLower);
                  }).toList();
                  _filteredAstrologers.value = filtered;
                },
                decoration: InputDecoration(
                  hintText: "Search by name",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: _filteredAstrologers.value.length,
                  itemBuilder: (context, index) {
                    final astrologer = _filteredAstrologers.value[index];
                    return ListTile(
                      leading: ClipOval(
                        child: astrologer.profileImg != null &&
                                File(astrologer.profileImg!).existsSync()
                            ? Image.file(
                                File(astrologer.profileImg!),
                                width: 55,
                                height: 55,
                                fit: BoxFit.fill,
                              )
                            : CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                imageUrl: astrologer.profileImg ?? '',
                                width: 55,
                                height: 55,
                                fit: BoxFit.fill,
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  'assets/default_profile_pic.png',
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.fill,
                                ),
                              ),
                      ),
                      title: Text(astrologer.name ?? 'NA'),
                      subtitle: Text(astrologer.specialization ?? ''),
                      onTap: () {
                        navigate.push(routeMe(
                            AustrologyDetailes(astrologer: astrologer)));
                      },
                    );
                  },
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}
