import 'package:fix_mates_servicer/resources/widgets/work_category_widget.dart';
import 'package:fix_mates_servicer/view/opening_screens/upload_document_screen.dart';
import 'package:fix_mates_servicer/view_model/upload_document_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_mates_servicer/view_model/signUp_controller.dart';

class WorkCategory extends StatelessWidget {
  const WorkCategory({Key? key}) : super(key: key);

  final List<Map<String, String>> gridItems = const [
    {'image': 'assets/electric.png', 'title': 'Electrical'},
    {'image': 'assets/fridge.png', 'title': 'Fridge'},
    {'image': 'assets/ac.png', 'title': 'Air condition'},
    {'image': 'assets/handyman.png', 'title': 'Handyman'},
    {'image': 'assets/mop.png', 'title': 'Cleaning'},
    {'image': 'assets/plumbing.png', 'title': 'Plumbing'},
    {'image': 'assets/wm.png', 'title': 'Washing Machine'},
    {'image': 'assets/painting.png', 'title': 'Painting'},
  ];

  @override
  Widget build(BuildContext context) {
    final signUpController = Get.find<SignUpController>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Work Category'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
            ),
            itemCount: gridItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  signUpController.addWorkCategory(gridItems[index]['title']!);

                  Get.to(
                    () => UploadDocumentsScreen(
                        category: gridItems[index]['title']!),
                    binding: BindingsBuilder(() {
                      Get.put(UploadDocumentsController(
                          gridItems[index]['title']!));
                    }),
                  );
                },
                child: GridItem(
                  imagePath: gridItems[index]['image']!,
                  title: gridItems[index]['title']!,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
