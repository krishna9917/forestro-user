import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:foreastro/Components/Widgts/colors.dart';
import 'package:foreastro/Screen/Kundali/CombinedDetailsView.dart';
import 'package:foreastro/controler/horoscope_kundali/kundali_horoscope.dart';
import 'package:foreastro/model/kundali/matchkundali/southkundali_model.dart';
import 'package:get/get.dart';
import 'package:score_progress_pretty_display/score_progress_pretty_display.dart';

class KundaliMilan extends StatelessWidget {
  final KundaliController kundaliController = Get.put(KundaliController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Kundali Millan",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primary,
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
            
              _buildResponseDetails(),
           
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

  Widget _buildResponseDetails() {
    return Obx(() {
      if (kundaliController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final response = kundaliController.northmatching.value.response;
        if (response == null) {
          return const Center(child: Text('No data available.'));
        } else {
          return SizedBox(
            height: 90.h,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PrimaryArcAnimationComponent(
                    score: (response.score is double)
                        ? response.score
                        : double.tryParse(response.score.toString()) ?? 0.0,
                    maxScore: 36,
                    arcHeight: 340,
                    arcWidth: 340,
                    backgroundArcStrokeThickness: 10,
                    progressArcStrokeThickness: 10,
                    enableStepperEffect: false,
                    isRoundEdges: false,
                    minScoreTextFontSize: 30,
                    maxScoreTextFontSize: 50,
                    isRoundOffScoreWhileProgress: true,
                    isRoundOffScore: true,
                    showOutOfScoreFormat: true,
                    isPrgressCurveFilled: false,
                    scoreAnimationDuration: const Duration(seconds: 2),
                    scoreTextAnimationDuration:
                        const Duration(milliseconds: 500),
                    scoreTextStyle: const TextStyle(
                        fontWeight: FontWeight.normal, height: 1),
                    arcBackgroundColor: Colors.black12,
                    arcProgressGradientColors: const [
                      AppColor.peach,
                      AppColor.primary,
                      AppColor.primary,
                    ],
                  ),
                ),
                Center(
                  child: _buildDetailRow(
                      'Bot Response', response.botResponse.toString() ?? 'N/A'),
                ),
                _buildDetailCard(
                  title: 'Compatibility (Varna)',
                  description:
                      'Varna refers to the mental compatibility of the two persons involved. It holds nominal effect in the matters of marriage compatibility.',
                  score: response.varna?.varna.toString() ?? 'N/A',
                  maxScore: 1,
                  color: Colors.orange,
                ),
                _buildDetailCard(
                  title: 'Love (Bhakut)',
                  description:
                      'Bhakut is related to the couple\'s joys and sorrows together and assesses the wealth and health after their wedding.',
                  score: response.bhakoot?.bhakoot.toString() ?? 'N/A',
                  maxScore: 7,
                  color: Colors.green,
                ),
                _buildDetailCard(
                  title: 'Mental Compatibility (Maitri)',
                  description:
                      'Maitri assesses the mental compatibility and mutual love between the partners to be married.',
                  score: response.grahamaitri?.grahamaitri.toString() ?? 'N/A',
                  maxScore: 5,
                  color: Colors.purple,
                ),
                _buildDetailCard(
                  title: 'Health (Nadi)',
                  description:
                      'Nadi is related to the health compatibility of the couple. Matters of childbirth and progeny are also determined with this Guna.',
                  score: response.nadi?.nadi.toString() ?? 'N/A',
                  maxScore: 8,
                  color: Colors.blue,
                ),
                _buildDetailCard(
                  title: 'Dominance (Vashya)',
                  description:
                      'Vashya indicates the bride and the groom\'s tendency to dominate or influence each other in a marriage.',
                  score: response.vasya?.vasya.toString() ?? 'N/A',
                  maxScore: 2,
                  color: Colors.pink,
                ),
                _buildDetailCard(
                  title: 'Temperament (Gana)',
                  description:
                      'Gana is the indicator of the behaviour, character and temperament of the potential bride and groom towards each other.',
                  score: response.gana?.gana.toString() ?? 'N/A',
                  maxScore: 6,
                  color: Colors.orange,
                ),
                _buildDetailCard(
                  title: 'Destiny (Tara)',
                  description:
                      'Tara is the indicator of the birth star compatibility of the bride and the groom. It also indicates the fortune of the couple.',
                  score: response.tara?.tara.toString() ?? 'N/A',
                  maxScore: 3,
                  color: Colors.green,
                ),
                _buildDetailCard(
                  title: 'Physical Compatibility (Yoni)',
                  description:
                      'Yoni is the indicator of the sexual or physical compatibility between the bride and the groom in question.',
                  score: response.yoni?.yoni.toString() ?? 'N/A',
                  maxScore: 4,
                  color: Colors.purple,
                ),
              ],
            ),
          );
        }
      }
    });
  }

  Widget _buildDetailCard({
    required String title,
    required String description,
    required String score,
    required int maxScore,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        // color: color,
        border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Card(
        elevation: 0, // Remove the default card shadow if necessary
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: color.withOpacity(0.2),
                    child: Text(
                      "$score/$maxScore",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Flexible(child: Text(value)),
        ],
      ),
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
              if (response.dina != null)
                _buildDetailSouthSection("Dina", response.dina!),
              if (response.gana != null)
                _buildDetailSouthSection("Gana", response.gana!),
              if (response.yoni != null)
                _buildDetailSouthSection("Yoni", response.yoni!),
              if (response.mahendra != null)
                _buildDetailSouthSection("Mahendra", response.mahendra!),
              if (response.sthree != null)
                _buildDetailSouthSection("Sthree", response.sthree!),
              if (response.vasya != null)
                _buildDetailSouthSection("Vasya", response.vasya!),
              if (response.rasi != null)
                _buildDetailSouthSection("Rasi", response.rasi!),
              if (response.rasiathi != null)
                _buildDetailSouthSection("Rasiathi", response.rasiathi!),
              if (response.boyAstroDetails != null)
                _buildAstroSouthDetails(
                    "Boy Astro Details", response.boyAstroDetails!),
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
      ],
    );
  }
}
