import 'package:flutter/material.dart';
import 'package:foreastro/controler/bloc_controler.dart';
import 'package:get/get.dart';

class BlocWigit extends StatefulWidget {
  const BlocWigit({super.key});

  @override
  State<BlocWigit> createState() => _BlocWigitState();
}

class _BlocWigitState extends State<BlocWigit> {
  final BlocList blocListController = Get.put(BlocList());

  @override
  Widget build(BuildContext context) {
    final BlocList blocListController = Get.put(BlocList());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bloc Data List'),
      ),
      body: GetBuilder<BlocList>(
        builder: (controller) {
          if (blocListController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  blocListController.blocDataList.length,
                  (index) => Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 200,
                    child: Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(blocListController.blocDataList.first.id
                            .toString()),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
