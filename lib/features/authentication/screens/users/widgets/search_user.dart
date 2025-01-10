import 'package:admin_panel/features/authentication/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchUserWidgets extends StatelessWidget {
  const SearchUserWidgets({
    super.key,
    required this.textEditingController,
    required this.controller, required this.hintText,
  });

  final TextEditingController textEditingController;
  final UserController controller;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.search),
        // Add suffix icon that only appears when there is text
        suffixIcon: Obx(
          () => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    textEditingController.clear(); // Clear text field
                    controller.searchQuery.value =
                        ''; // Clear search state
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
      onChanged: (value) {
        controller.searchQuery.value = value;
      },
    );
  }
}