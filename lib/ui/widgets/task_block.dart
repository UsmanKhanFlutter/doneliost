import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Core/Constants/colors.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final int done;
  final VoidCallback onDone;
  final String description;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.done,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(15), // Set the border radius
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: Get.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration:
                            done == 1 ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        decoration:
                            done == 1 ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                color: kPrimaryColor,
                onPressed: done == 1 ? null : onDone,
                icon: Icon(
                  done == 1 ? Icons.check_box : Icons.check_box_outline_blank,
                  color: kSecondaryColor,
                ),
              ),
            ],
          ),
        ));
  }
}
