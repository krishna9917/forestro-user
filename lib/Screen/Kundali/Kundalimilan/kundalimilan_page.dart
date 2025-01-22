import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Screen/Kundali/CombinedDetailsView.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/model/kundali/matchkundali/southkundali_model.dart'; // Import the SouthKundaliModel
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
              // _buildHeader(context, "Kundali North Details"),
              // _buildPlanetDetails(),
              // const SizedBox(height: 20),
              // _buildHeader(context, "Kundali Matching North Details"),
              // const SizedBox(height: 20),
              // _buildOtherDetails(),
              const SizedBox(height: 20),
              // _buildHeader(context, "Kundali South Details"),
              const SizedBox(height: 20),
              _buildSouthDetails(), // Add South Details
              const SizedBox(height: 20),
              // _buildHeader(context, "Kundali Matching South Details"),
              const SizedBox(height: 20),
              _buildSouthOtherDetails(), // Add South Other Details
            ],
          ),
        ),
      ),
    );
  }

  // Existing methods...

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
        }),
      ),
    );
  }

  DataRow _buildSouthDataRow(PlanetarySouthDetail planet) {
    return DataRow(
      cells: [
        DataCell(Text(planet.name ?? 'N/A')),
        DataCell(Text(planet.fullName ?? 'N/A')),
        DataCell(Text(planet.zodiac ?? 'N/A')),
        DataCell(Text(planet.localDegree?.toString() ?? 'N/A')),
        DataCell(Text(planet.zodiacLord ?? 'N/A')),
        DataCell(Text(planet.nakshatra ?? 'N/A')),
        DataCell(Text(planet.nakshatraLord ?? 'N/A')),
        DataCell(Text(planet.rasiNo?.toString() ?? 'N/A')),
        DataCell(Text(planet.house?.toString() ?? 'N/A')),
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
              // Display Dina
              if (response.dina != null)
                _buildDetailSouthSection("Dina", response.dina!),
              // Display Gana
              if (response.gana != null)
                _buildDetailSouthSection("Gana", response.gana!),
              // Display Yoni
              if (response.yoni != null)
                _buildDetailSouthSection("Yoni", response.yoni!),
              // Display Mahendra
              if (response.mahendra != null)
                _buildDetailSouthSection("Mahendra", response.mahendra!),
              // Display Sthree
              if (response.sthree != null)
                _buildDetailSouthSection("Sthree", response.sthree!),
              // Display Vasya
              if (response.vasya != null)
                _buildDetailSouthSection("Vasya", response.vasya!),
              // Display Rasi
              if (response.rasi != null)
                _buildDetailSouthSection("Rasi", response.rasi!),
              // Display Rasiathi
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
            label: "Nakshatra Pada", value: details.nakshatraPada.toString()),
        DataRowWidget(label: "Ascendant Sign", value: details.ascendantSign),
        // Add more fields as necessary
      ],
    );
  }
}
