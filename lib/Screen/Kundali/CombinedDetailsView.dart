import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/horoscope_kundali/chart_image_controler.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/controler/profile_controler.dart';
import 'package:foreastro/model/kundali/plannet_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CombinedDetailsView extends StatefulWidget {
  final String dob;
  final String tob;
  final String place;
  final double lati;
  final double long;
  const CombinedDetailsView({
    super.key,
    // required this.name,
    required this.dob,
    required this.tob,
    required this.place,
    required this.lati,
    required this.long,
    // required this.place,
    // required this.lat,
    // required this.log,
  });
  @override
  State<CombinedDetailsView> createState() => _CombinedDetailsViewState();
}

class _CombinedDetailsViewState extends State<CombinedDetailsView> {
  final KundaliController kundaliController = Get.put(KundaliController());

  final CartImageControler controller = Get.put(CartImageControler());
  final ProfileList profilecontoler = Get.put(ProfileList());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Kundali'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ButtonsTabBar(
                // width: 180,
                height: 40,
                contentCenter: true,
                backgroundColor: AppColor.primary,
                unselectedBackgroundColor: Colors.grey[300],
                unselectedLabelStyle: const TextStyle(color: Colors.black),
                labelStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: " Basic "),
                  Tab(text: " Planet "),
                  Tab(text: " Ascendant Report "),
                  // Tab(text: " Kundali "),
                  // Tab(text: " Personal Characteristics "),
                  Tab(text: " Binnashtakvarga "),
                  Tab(text: " Dasha "),
                  Tab(text: " KP "),
                ],
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              _buildBasicSection(context),
              _buildPlanetSection(context),
              _buildAscendantReportSection(context),
              // _buildKundaliSection(context),
              // _buildPersonalCharacteristicsSection(context),
              _buildBinnashtakvargaSection(context),
              _buildvimsotridashaSection(context),

              _buildKPHousesSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSectionTitle(context, "Basic Details"),
          ),
          _buildesimage(),
          _basicDetailes(),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: _buildBasicAccidentDetails()),
        ],
      ),
    );
  }

  Widget _buildPlanetSection(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildSectionTitle(context, "Planets"),
        ),
        _buildPlanetDetails(),
      ],
    );
  }

  Widget _buildAscendantReportSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSectionTitle(context, "Ascendant Report"),
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: _buildAccidentDetails()),
        ],
      ),
    );
  }

  // Widget _buildKundaliSection(BuildContext context) {
  //   return Column(
  //     children: [
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: _buildSectionTitle(context, "Kundali"),
  //       ),
  //       _buildesimage(),
  //     ],
  //   );
  // }

  Widget _buildPersonalCharacteristicsSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSectionTitle(context, "Personal Characteristics"),
          ),
          _buildParsonalCharectristicDetails(),
        ],
      ),
    );
  }

  Widget _buildBinnashtakvargaSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSectionTitle(context, "Binnashtakvarga"),
          ),
          _buildBinnashtakvargaDetails(),
          // const SizedBox(
          //   height: 5,
          // ),
          // _buildAccidentDetails()
        ],
      ),
    );
  }

  Widget _buildKPHousesSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSectionTitle(context, "Bhav Chalit Chart"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildeskpimage(),
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: _buildKpHouse()),
        ],
      ),
    );
  }

  Widget _buildvimsotridashaSection(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSectionTitle(context, "Vimshottri Dasha"),
          ),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
                color: Colors.white,
              ),
              child: _buildKpHouse()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: 7.w, right: 2.w),
            child: const Divider(
              height: 1,
              color: Colors.black45,
            ),
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
        ),
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: 7.w, left: 2.w),
            child: const Divider(
              height: 1,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _basicDetailes() {
    var name = profilecontoler.profileDataList.first.name ?? '';
    return Column(
      children: [
        // _buildesimage(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey),
              color: Colors.white,
            ),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(150.0),
                1: FlexColumnWidth(),
              },
              border: const TableBorder.symmetric(),
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Name:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(name.toString()),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Date of Birth:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.dob),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Time of Birth:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.tob),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Place:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.place.toString()),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Latitude:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.lati.toString()),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Longitude:'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.long.toString()),
                    ),
                  ],
                ),
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Timezone:'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("GMT+5.5"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanetDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(() {
          if (kundaliController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (kundaliController.planetDataList.value?.response == null) {
              return const Center(child: Text('No data available.'));
            } else {
              final response =
                  kundaliController.planetDataList.value?.response!;
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColor.primary), // Add border to table
                  borderRadius:
                      BorderRadius.circular(8.0), // Optional: Rounded corners
                ),
                child: DataTable(
                  columnSpacing: 20.0, // Increase space between columns
                  headingRowColor: WidgetStateProperty.all(
                      AppColor.primary), // Set header background color
                  dataRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      // Alternate row color
                      return states.contains(WidgetState.selected)
                          ? Colors.grey.shade300
                          : Colors.white;
                    },
                  ),
                  columns: const [
                    DataColumn(
                        label: Text('Planets',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text('R Sign',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text('Degree',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text('Sign Lord',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text('Nakshatra',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text('Nakshatra Lord',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    DataColumn(
                        label: Text('House',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                  ],
                  rows: response!.planets.values
                      .map((planet) => _buildDataRow(planet))
                      .toList(),
                ),
              );
            }
          }
        }),
      ),
    );
  }

  DataRow _buildDataRow(Planet planet) {
    return DataRow(
      cells: [
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0), // Add padding to cells
          child: Text(planet.fullName ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(planet.zodiac ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(planet.localDegree.toString()),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(planet.zodiacLord ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(planet.nakshatra ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(planet.nakshatraLord ?? ''),
        )),
        DataCell(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(planet.house.toString()),
        )),
      ],
    );
  }

  Widget _buildParsonalCharectristicDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(() {
          if (kundaliController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (kundaliController.personalcharacteristics.value.response ==
                null) {
              return const Center(child: Text('No data available.'));
            } else {
              final response =
                  kundaliController.personalcharacteristics.value.response!;
              return FittedBox(
                child: DataTable(
                  border: TableBorder.all(color: Colors.black, width: 0.2),
                  columns: const [
                    DataColumn(label: Text('CurrentHouse')),
                    DataColumn(label: Text('VerbalLocation')),
                    DataColumn(label: Text('CurrentZodiac')),
                    DataColumn(label: Text('Lord_of_Zodiac')),
                    DataColumn(label: Text('Lord_Zodiac_Location')),
                    DataColumn(label: Text('Lord_House_Location')),
                    DataColumn(label: Text('Personalised_Prediction')),
                    DataColumn(label: Text('Lord_Strength')),
                    // Add more DataColumn widgets as needed
                  ],
                  rows: response
                      .map((data) => _buildPersonalcharetristDataRow(data))
                      .toList(),
                ),
              );
            }
          }
        }),
      ),
    );
  }

  DataRow _buildPersonalcharetristDataRow(dynamic data) {
    return DataRow(
      cells: [
        DataCell(Text(data.currentHouse?.toString() ?? '')),
        DataCell(Text(data.verbalLocation ?? '')),
        DataCell(Text(data.currentZodiac ?? '')),
        DataCell(Text(data.lordOfZodiac ?? '')),
        DataCell(Text(data.lordZodiacLocation ?? '')),
        DataCell(Text(data.lordHouseLocation?.toString() ?? '')),
        DataCell(Text(data.personalisedPrediction ?? '')),
        DataCell(Text(data.lordStrength ?? '')),
        // Add more DataCell widgets as needed
      ],
    );
  }

  Widget _buildBinnashtakvargaDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(() {
          if (kundaliController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (kundaliController.binnashtakvarga.value.response == null) {
              return const Center(child: Text('No data available.'));
            } else {
              final response =
                  kundaliController.binnashtakvarga.value.response!;
              return FittedBox(
                child: DataTable(
                  border: TableBorder.all(color: Colors.black, width: 0.2),
                  columns: const [
                    DataColumn(label: Text('Ascendant')),
                    DataColumn(label: Text('Sun')),
                    DataColumn(label: Text('Moon')),
                    DataColumn(label: Text('Mars')),
                    DataColumn(label: Text('Mercury')),
                    DataColumn(label: Text('Jupiter')),
                    DataColumn(label: Text('Saturn')),
                    DataColumn(label: Text('Venus')),
                  ],
                  rows: List<DataRow>.generate(
                    response.jupiter!.length,
                    (index) => _buildBinnashtakvargaDataRow(response, index),
                  ),
                ),
              );
            }
          }
        }),
      ),
    );
  }

  DataRow _buildBinnashtakvargaDataRow(dynamic response, int index) {
    return DataRow(
      cells: [
        DataCell(Text(response.ascendant![index].toString())),
        DataCell(Text(response.sun![index].toString())),
        DataCell(Text(response.moon![index].toString())),
        DataCell(Text(response.mars![index].toString())),
        DataCell(Text(response.mercury![index].toString())),
        DataCell(Text(response.jupiter![index].toString())),
        DataCell(Text(response.saturn![index].toString())),
        DataCell(Text(response.venus![index].toString())),
      ],
    );
  }

  Widget _buildAccidentDetails() {
    return SingleChildScrollView(
      child: Obx(() {
        if (kundaliController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (kundaliController.assedentDataList.value.response == null) {
            return const Center(child: Text('No data available.'));
          } else {
            final response = kundaliController.assedentDataList.value.response!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response.map((item) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DataRowWidget(label: 'Ascendant', value: item.ascendant),
                      // Container(
                      //   color: const Color.fromARGB(181, 241, 235, 179),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 3),
                      //     child: DataRowWidget(
                      //       label: 'Ascendant Lord',
                      //       value: item.ascendantLord,
                      //     ),
                      //   ),
                      // ),

                      // DataRowWidget(
                      //     label: 'Ascendant Lord Location',
                      //     value: item.ascendantLordLocation),
                      Container(
                        color: const Color.fromARGB(181, 241, 235, 179),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: DataRowWidget(
                              label: 'Ascendant Lord House Location',
                              value:
                                  item.ascendantLordHouseLocation.toString()),
                        ),
                      ),
                      // DataRowWidget(
                      //     label: 'General Prediction',
                      //     value: item.generalPrediction),
                      // Container(
                      //   color: const Color.fromARGB(181, 241, 235, 179),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 3),
                      //     child: DataRowWidget(
                      //         label: 'Personalised Prediction',
                      //         value: item.personalisedPrediction),
                      //   ),
                      // ),
                      DataRowWidget(
                          label: 'Verbal Location', value: item.verbalLocation),
                      DataRowWidget(
                          label: 'Ascendant Lord Strength',
                          value: item.ascendantLordStrength),
                      DataRowWidget(label: 'Symbol', value: item.symbol),
                      Container(
                        color: const Color.fromARGB(181, 241, 235, 179),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: DataRowWidget(
                              label: 'Zodiac Characteristics',
                              value: item.zodiacCharacteristics),
                        ),
                      ),
                      DataRowWidget(label: 'Lucky Gem', value: item.luckyGem),
                      DataRowWidget(
                          label: 'Day For Fasting', value: item.dayForFasting),
                      Container(
                        color: const Color.fromARGB(181, 241, 235, 179),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: DataRowWidget(
                              label: 'Gayatri Mantra',
                              value: item.gayatriMantra),
                        ),
                      ),
                      DataRowWidget(
                          label: 'Flagship Qualities',
                          value: item.flagshipQualities),
                      DataRowWidget(
                          label: 'Spirituality Advice',
                          value: item.spiritualityAdvice),
                      // Container(
                      //   color: const Color.fromARGB(181, 241, 235, 179),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 3),
                      //     child: DataRowWidget(
                      //         label: 'Good Qualities',
                      //         value: item.goodQualities),
                      //   ),
                      // ),
                      // DataRowWidget(
                      //     label: 'Bad Qualities', value: item.badQualities),
                      const SizedBox(
                          height: 16), // Add some spacing between rows
                    ],
                  );
                }).toList(),
              ),
            );
          }
        }
      }),
    );
  }

  Widget _buildBasicAccidentDetails() {
    return SingleChildScrollView(
      child: Obx(() {
        if (kundaliController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (kundaliController.assedentDataList.value.response == null) {
            return const Center(child: Text('No data available.'));
          } else {
            final response = kundaliController.assedentDataList.value.response!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: response.map((item) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataRowWidget(label: 'Ascendant', value: item.ascendant),
                      Container(
                        color: const Color.fromARGB(181, 241, 235, 179),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: DataRowWidget(
                            label: 'Ascendant Lord',
                            value: item.ascendantLord,
                          ),
                        ),
                      ),

                      DataRowWidget(
                          label: 'Ascendant Lord Location',
                          value: item.ascendantLordLocation),
                      // Container(
                      //   color: const Color.fromARGB(181, 241, 235, 179),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 3),
                      //     child: DataRowWidget(
                      //         label: 'Ascendant Lord House Location',
                      //         value:
                      //             item.ascendantLordHouseLocation.toString()),
                      //   ),
                      // ),
                      DataRowWidget(
                          label: 'General Prediction',
                          value: item.generalPrediction),
                      Container(
                        color: const Color.fromARGB(181, 241, 235, 179),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: DataRowWidget(
                              label: 'Personalised Prediction',
                              value: item.personalisedPrediction),
                        ),
                      ),
                      // DataRowWidget(
                      //     label: 'Verbal Location', value: item.verbalLocation),
                      // DataRowWidget(
                      //     label: 'Ascendant Lord Strength',
                      //     value: item.ascendantLordStrength),
                      // DataRowWidget(label: 'Symbol', value: item.symbol),
                      // Container(
                      //   color: const Color.fromARGB(181, 241, 235, 179),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 3),
                      //     child: DataRowWidget(
                      //         label: 'Zodiac Characteristics',
                      //         value: item.zodiacCharacteristics),
                      //   ),
                      // ),
                      // DataRowWidget(label: 'Lucky Gem', value: item.luckyGem),
                      // DataRowWidget(
                      //     label: 'Day For Fasting', value: item.dayForFasting),
                      // Container(
                      //   color: const Color.fromARGB(181, 241, 235, 179),
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 3),
                      //     child: DataRowWidget(
                      //         label: 'Gayatri Mantra',
                      //         value: item.gayatriMantra),
                      //   ),
                      // ),
                      // DataRowWidget(
                      //     label: 'Flagship Qualities',
                      //     value: item.flagshipQualities),
                      // DataRowWidget(
                      //     label: 'Spirituality Advice',
                      //     value: item.spiritualityAdvice),
                      Container(
                        color: const Color.fromARGB(181, 241, 235, 179),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: DataRowWidget(
                              label: 'Good Qualities',
                              value: item.goodQualities),
                        ),
                      ),
                      DataRowWidget(
                          label: 'Bad Qualities', value: item.badQualities),
                      const SizedBox(
                          height: 16), // Add some spacing between rows
                    ],
                  );
                }).toList(),
              ),
            );
          }
        }
      }),
    );
  }

  Widget _buildesimage() {
    return Center(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const CircularProgressIndicator();
        } else if (controller.svgData.value.isEmpty) {
          return const Text('No image data');
        } else {
          return SvgPicture.string(
            controller.svgData.value,
            width: 300,
            height: 300,
          );
        }
      }),
    );
  }

  Widget _buildeskpimage() {
    return Center(
      child: Obx(() {
        if (controller.isLoading.value) {
          return const CircularProgressIndicator();
        } else if (controller.kpData.value.isEmpty) {
          return const Text('No image data');
        } else {
          return SvgPicture.string(
            controller.kpData.value,
            width: 300,
            height: 300,
          );
        }
      }),
    );
  }

  Widget _buildKpHouse() {
    return SingleChildScrollView(
      child: Obx(() {
        if (kundaliController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (kundaliController.vimsotridasadatalist.value.response == null ||
              kundaliController
                      .vimsotridasadatalist.value.response!.mahadasha ==
                  null) {
            return const Center(child: Text('No data available.'));
          } else {
            final mahadashaList = kundaliController
                .vimsotridasadatalist.value.response!.mahadasha!;
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mahadasha Details',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DataTable(
                    columnSpacing: 20, // Increased spacing
                    columns: const [
                      DataColumn(label: Text('Planet')),
                      DataColumn(label: Text('Start Date')),
                      DataColumn(label: Text('End Date')),
                      DataColumn(
                          label: Text(
                              '')), // Updated to describe the purpose of this column
                    ],
                    rows: mahadashaList.map((mahadasha) {
                      return DataRow(
                        cells: [
                          DataCell(Text(
                            mahadasha.name ?? 'N/A',
                            style: const TextStyle(fontSize: 10),
                          )),
                          DataCell(Text(
                            mahadasha.start != null
                                ? (mahadasha.start!.length > 16
                                    ? '${mahadasha.start!.substring(0, 16)}'
                                    : mahadasha.start!)
                                : 'N/A',
                            style: const TextStyle(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          DataCell(Text(
                            mahadasha.end != null
                                ? (mahadasha.end!.length > 16
                                    ? '${mahadasha.end!.substring(0, 16)}   '
                                    : mahadasha.end!)
                                : 'N/A',
                            style: const TextStyle(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                          DataCell(
                            Icon(Icons
                                .keyboard_arrow_right), // Should render correctly now
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
        }
      }),
    );
  }

// Helper function to format date
}

class DataRowWidget extends StatelessWidget {
  final String label;
  final String? value;

  const DataRowWidget({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150, // Adjust the width as needed
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.grey),
              //   borderRadius: BorderRadius.circular(4.0),
              // ),
              child: Text(value ?? 'N/A'),
            ),
          ),
        ],
      ),
    );
  }
}
