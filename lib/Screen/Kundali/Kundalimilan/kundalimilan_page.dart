import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/model/kundali/matchkundali/northkundali_model.dart';
import 'package:foreastro/model/kundali/matchkundali/southkundali_model.dart';
import 'package:get/get.dart';

class KundaliMilan extends StatelessWidget {
  final KundaliController kundaliController = Get.put(KundaliController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // centerTitle: true,
          // title: const Text('Kundali Matching'),
          ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildHeader(context, "Kundali North Details"),
              _buildPlanetDetails(),
              const SizedBox(
                height: 20,
              ),
              _buildHeader(context, "Kundail Matching North Details"),
              const SizedBox(
                height: 20,
              ),
              _buildOtherDetails(),
              // const SizedBox(
              //   height: 20,
              // ),
              // _buildHeader(context, "Kundali South Details"),
              // const SizedBox(
              //   height: 20,
              // ),
              // _buildSouthDetails(),
              // // _buildPlanetDetails(),
              // const SizedBox(
              //   height: 20,
              // ),
              // _buildHeader(context, "Kundail Matching South Details"),
              // const SizedBox(
              //   height: 20,
              // ),
              // _buildSouthOtherDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
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

  Widget _buildPlanetDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Obx(() {
            if (kundaliController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final response = kundaliController.northmatching.value.response;
              if (response == null) {
                return const Center(child: Text('No data available.'));
              } else if (response.boyPlanetaryDetails.isEmpty &&
                  response.girlPlanetaryDetails.isEmpty) {
                return const Center(
                    child: Text('No planetary details available.'));
              } else {
                final boyPlanetaryDetails = response.boyPlanetaryDetails;
                final girlPlanetaryDetails = response.girlPlanetaryDetails;

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Full Name')),
                    DataColumn(label: Text('Zodiac')),
                    DataColumn(label: Text('Degree')),
                    DataColumn(label: Text('Zodiac Lord')),
                    DataColumn(label: Text('Nakshatra')),
                    DataColumn(label: Text('Nakshatra Lord')),
                    DataColumn(label: Text('Rasi no.')),
                    DataColumn(label: Text('House')),
                  ],
                  rows: [
                    // Iterate through boyPlanetaryDetails map
                    for (var entry in boyPlanetaryDetails.entries)
                      _buildDataRow(entry.value),
                    // Iterate through girlPlanetaryDetails map
                    for (var entry in girlPlanetaryDetails.entries)
                      _buildDataRow(entry.value),
                  ],
                );
              }
            }
          })),
    );
  }

  DataRow _buildDataRow(PlanetaryDetail planet) {
    return DataRow(
      cells: [
        DataCell(Text(planet.name ?? 'N/A')), // Handle null
        DataCell(Text(planet.fullName ?? 'N/A')),
        DataCell(Text(planet.zodiac ?? 'N/A')), // Handle null
        DataCell(Text(planet.localDegree?.toString() ?? 'N/A')), // Handle null
        DataCell(Text(planet.zodiacLord ?? 'N/A')), // Handle null
        DataCell(Text(planet.nakshatra ?? 'N/A')), // Handle null
        DataCell(Text(planet.nakshatraLord ?? 'N/A')),
        DataCell(Text(planet.rasiNo?.toString() ?? 'N/A')), // Handle null
        DataCell(Text(planet.house?.toString() ?? 'N/A')), // Handle null
      ],
    );
  }

  Widget _buildOtherDetails() {
    return Obx(() {
      if (kundaliController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final response = kundaliController.northmatching.value.response;

        if (response == null) {
          return const Center(child: Text('No data available.'));
        } else {
          return Column(
            children: [
              DataRowWidget(label: "Score", value: response.score?.toString()),
              DataRowWidget(
                label: "Bot Response",
                value: response.botResponse,
              ),
              // Display Tara
              if (response.tara != null)
                _buildDetailSection("Tara", response.tara!),

              if (response.gana != null)
                _buildDetailSection("Gana", response.gana!),

              if (response.yoni != null)
                _buildDetailSection("Yoni", response.yoni!),
              // Display Bhakoot
              if (response.bhakoot != null)
                _buildDetailSection("Bhakoot", response.bhakoot!),
              // Display Grahamaitri
              if (response.grahamaitri != null)
                _buildDetailSection("Grahamaitri", response.grahamaitri!),
              // Display Vasya
              if (response.vasya != null)
                _buildDetailSection("Vasya", response.vasya!),
              // Display Nadi
              if (response.nadi != null)
                _buildDetailSection("Nadi", response.nadi!),
              // Display Varna
              if (response.varna != null)
                _buildDetailSection("Varna", response.varna!),
              // Display Boy Astro Details
              if (response.boyAstroDetails != null)
                _buildAstroDetails(
                    "Boy Astro Details", response.boyAstroDetails!),
              // Display Girl Astro Details
              if (response.girlAstroDetails != null)
                _buildAstroDetails(
                    "Girl Astro Details", response.girlAstroDetails!),
            ],
          );
        }
      }
    });
  }

  Widget _buildDetailSection(String title, dynamic detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        DataRowWidget(label: "Description", value: detail.description),
        DataRowWidget(label: "Full Score", value: detail.fullScore?.toString()),
        // Add more fields as necessary
      ],
    );
  }

  Widget _buildAstroDetails(String title, AstroDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        DataRowWidget(label: "Gana", value: details.gana),
        DataRowWidget(label: "Yoni", value: details.yoni),
        DataRowWidget(label: "Vasya", value: details.vasya),
        DataRowWidget(label: "Nadi", value: details.nadi),
        DataRowWidget(label: "Varna", value: details.varna),
        DataRowWidget(label: "Paya", value: details.paya),
        DataRowWidget(label: "Tatva", value: details.tatva),
        DataRowWidget(label: "Birth Dasa", value: details.birthDasa),
        DataRowWidget(label: "Current Dasa", value: details.currentDasa),
        DataRowWidget(label: "Birth Dasa Time", value: details.birthDasaTime),
        DataRowWidget(
            label: "Current Dasa Time", value: details.currentDasaTime),
        DataRowWidget(label: "Rasi", value: details.rasi),
        DataRowWidget(label: "Nakshatra", value: details.nakshatra),
        DataRowWidget(
          label: "Nakshatra Pada",
          value: details.nakshatraPada.toString(),
        ),

        DataRowWidget(label: "Ascendant Sign", value: details.ascendantSign),
        // Add more fields as necessary
      ],
    );
  }

  Widget _buildSouthDetails() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Obx(() {
            if (kundaliController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final response = kundaliController.southmatching.value.response;
              if (response == null) {
                return const Center(child: Text('No data available.'));
              } else if (response.boyPlanetaryDetails.isEmpty &&
                  response.girlPlanetaryDetails.isEmpty) {
                return const Center(
                    child: Text('No planetary details available.'));
              } else {
                final boyPlanetaryDetails = response.boyPlanetaryDetails;
                final girlPlanetaryDetails = response.girlPlanetaryDetails;

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Full Name')),
                    DataColumn(label: Text('Zodiac')),
                    DataColumn(label: Text('Degree')),
                    DataColumn(label: Text('Zodiac Lord')),
                    DataColumn(label: Text('Nakshatra')),
                    DataColumn(label: Text('Nakshatra Lord')),
                    DataColumn(label: Text('Rasi no.')),
                    DataColumn(label: Text('House')),
                  ],
                  rows: [
                    // Iterate through boyPlanetaryDetails map
                    for (var entry in boyPlanetaryDetails.entries)
                      _buildSouthDataRow(entry.value),
                    // Iterate through girlPlanetaryDetails map
                    for (var entry in girlPlanetaryDetails.entries)
                      _buildSouthDataRow(entry.value),
                  ],
                );
              }
            }
          })),
    );
  }

  DataRow _buildSouthDataRow(PlanetarySouthDetail planet) {
    return DataRow(
      cells: [
        DataCell(Text(planet.name ?? 'N/A')), // Handle null
        DataCell(Text(planet.fullName ?? 'N/A')),
        DataCell(Text(planet.zodiac ?? 'N/A')), // Handle null
        DataCell(Text(planet.localDegree?.toString() ?? 'N/A')), // Handle null
        DataCell(Text(planet.zodiacLord ?? 'N/A')), // Handle null
        DataCell(Text(planet.nakshatra ?? 'N/A')), // Handle null
        DataCell(Text(planet.nakshatraLord ?? 'N/A')),
        DataCell(Text(planet.rasiNo?.toString() ?? 'N/A')), // Handle null
        DataCell(Text(planet.house?.toString() ?? 'N/A')), // Handle null
      ],
    );
  }

  Widget _buildSouthOtherDetails() {
    return Obx(() {
      if (kundaliController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final response = kundaliController.southmatching.value.response;

        if (response == null) {
          return const Center(child: Text('No data available.'));
        } else {
          return Column(
            children: [
              DataRowWidget(label: "Score", value: response.score?.toString()),
              DataRowWidget(
                label: "Bot Response",
                value: response.botResponse,
              ),
              // Display Tara
              if (response.dina != null)
                _buildDetailSouthSection("Dina", response.dina!),
              // Display Gana
              if (response.gana != null)
                _buildDetailSouthSection("Gana", response.gana!),
              // Display Yoni
              if (response.yoni != null)
                _buildDetailSouthSection("Yoni", response.yoni!),
              // Display Bhakoot
              if (response.mahendra != null)
                _buildDetailSouthSection("Mahendra", response.mahendra!),
              // Display Grahamaitri
              if (response.sthree != null)
                _buildDetailSouthSection("Sthree", response.sthree!),
              // Display Vasya
              if (response.vasya != null)
                _buildDetailSouthSection("Vasya", response.vasya!),
              // Display Nadi
              if (response.rasi != null)
                _buildDetailSouthSection("Rasi", response.rasi!),
              // Display Varna
              if (response.rasiathi != null)
                _buildDetailSouthSection("Rasiathi", response.rasiathi!),
              // Display Boy Astro Details
              if (response.boyAstroDetails != null)
                _buildAstroSouthDetails(
                    "Boy Astro Details", response.boyAstroDetails!),
              // Display Girl Astro Details
              if (response.girlAstroDetails != null)
                _buildAstroSouthDetails(
                    "Girl Astro Details", response.girlAstroDetails!),
            ],
          );
        }
      }
    });
  }

  Widget _buildDetailSouthSection(String title, dynamic detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        DataRowWidget(label: "Description", value: detail.description),
        DataRowWidget(label: "Full Score", value: detail.fullScore?.toString()),
        // Add more fields as necessary
      ],
    );
  }

  Widget _buildAstroSouthDetails(String title, AstroSouthDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        DataRowWidget(label: "Gana", value: details.gana),
        DataRowWidget(label: "Yoni", value: details.yoni),
        DataRowWidget(label: "Vasya", value: details.vasya),
        DataRowWidget(label: "Nadi", value: details.nadi),
        DataRowWidget(label: "Varna", value: details.varna),
        DataRowWidget(label: "Paya", value: details.paya),
        DataRowWidget(label: "Tatva", value: details.tatva),
        DataRowWidget(label: "Birth Dasa", value: details.birthDasa),
        DataRowWidget(label: "Current Dasa", value: details.currentDasa),
        DataRowWidget(label: "Birth Dasa Time", value: details.birthDasaTime),
        DataRowWidget(
            label: "Current Dasa Time", value: details.currentDasaTime),
        DataRowWidget(label: "Rasi", value: details.rasi),
        DataRowWidget(label: "Nakshatra", value: details.nakshatra),
        DataRowWidget(
          label: "Nakshatra Pada",
          value: details.nakshatraPada.toString(),
        ),

        DataRowWidget(label: "Ascendant Sign", value: details.ascendantSign),
        // Add more fields as necessary
      ],
    );
  }
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
            width: 180, // Adjust the width as needed
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              // padding: const EdgeInsets.all(8.0),
              child: Text(
                value ?? 'N/A',
                style: const TextStyle(
                  color: AppColor.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
