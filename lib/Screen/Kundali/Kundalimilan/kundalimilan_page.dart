import 'package:flutter/material.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/model/kundali/matchkundali/northkundali_model.dart';
import 'package:get/get.dart';
import 'dart:ui';

class KundaliMilan extends StatelessWidget {
  final KundaliController kundaliController = Get.put(KundaliController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.secondary,
      appBar: AppBar(
        title: const Text(
          'Kundali Matching',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColor.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader("Kundali Matching North Details"),
              const SizedBox(height: 20),
              _buildPlanetDetails(),
              const SizedBox(height: 30),
              _buildHeader("Kundali Matching South Details"),
              const SizedBox(height: 20),
              _buildOtherDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            thickness: 1.5,
            color: Colors.grey.shade400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColor.primary,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.5,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanetDetails() {
    return Obx(() {
      if (kundaliController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final response = kundaliController.northmatching.value.response;
        if (response == null) {
          return _buildNoDataMessage("No planetary details available.");
        } else if (response.boyPlanetaryDetails.isEmpty &&
            response.girlPlanetaryDetails.isEmpty) {
          return _buildNoDataMessage("No planetary details available.");
        } else {
          return _buildDataTable(
              response.boyPlanetaryDetails, response.girlPlanetaryDetails);
        }
      }
    });
  }

  Widget _buildDataTable(Map<String, PlanetaryDetail> boyDetails,
      Map<String, PlanetaryDetail> girlDetails) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateProperty.all(AppColor.grey50),
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Zodiac')),
              DataColumn(label: Text('Degree')),
              DataColumn(label: Text('Nakshatra')),
              DataColumn(label: Text('Rasi No.')),
              DataColumn(label: Text('House')),
            ],
            rows: [
              for (var entry in boyDetails.entries) _buildDataRow(entry.value),
              for (var entry in girlDetails.entries) _buildDataRow(entry.value),
            ],
          ),
        ),
      ),
    );
  }

  DataRow _buildDataRow(PlanetaryDetail planet) {
    return DataRow(
      cells: [
        DataCell(Text(planet.name ?? 'N/A')),
        DataCell(Text(planet.zodiac ?? 'N/A')),
        DataCell(Text((planet.localDegree != null)
            ? planet.localDegree!.toStringAsFixed(2)
            : 'N/A')),
        DataCell(Text(planet.nakshatra ?? 'N/A')),
        DataCell(Text(planet.rasiNo?.toString() ?? 'N/A')),
        DataCell(Text(planet.house?.toString() ?? 'N/A')),
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
          return _buildNoDataMessage("No additional details available.");
        } else {
          return _buildDetailsSection(response);
        }
      }
    });
  }

  Widget _buildDetailsSection(dynamic response) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataRowWidget(label: "Score", value: response.score?.toString()),
            DataRowWidget(label: "Bot Response", value: response.botResponse),
            const SizedBox(height: 10),
            if (response.tara != null) _buildDetailItem("Tara", response.tara!),
            if (response.gana != null) _buildDetailItem("Gana", response.gana!),
            if (response.nadi != null) _buildDetailItem("Nadi", response.nadi!),
            if (response.bhakoot != null)
              _buildDetailItem("Bhakoot", response.bhakoot!),
            // Add more sections if necessary
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, dynamic detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColor.primary,
          ),
        ),
        DataRowWidget(label: "Description", value: detail.description),
        DataRowWidget(
          label: "Full Score",
          value: detail.fullScore?.toString(),
        ),
      ],
    );
  }

  Widget _buildNoDataMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(color: AppColor.primary),
            ),
          ),
        ],
      ),
    );
  }
}
