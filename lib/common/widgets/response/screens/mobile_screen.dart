import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Mobile extends StatelessWidget {
  const Mobile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// FIRST COLUMN
        TRoundedContainer(
          height: 200,
          width: double.infinity,
          backgroundColor: Colors.blue.withOpacity(0.2),
          child: const Center(child: Text('BOX 1')),
        ),
        const SizedBox(height: 20),
        TRoundedContainer(
          height: 200,
          width: double.infinity,
          backgroundColor: Colors.orange.withOpacity(0.2),
          child: const Center(child: Text('BOX 2')),
        ),
        const SizedBox(height: 20),
        TRoundedContainer(
          height: 200,
          width: double.infinity,
          backgroundColor: Colors.red.withOpacity(0.2),
          child: const Center(child: Text('BOX 3')),
        ),
        const SizedBox(height: 20),
        TRoundedContainer(
          height: 200,
          width: double.infinity,
          backgroundColor: Colors.green.withOpacity(0.2),
          child: const Center(child: Text('BOX 4')),
        ),
        const SizedBox(height: 20),
        TRoundedContainer(
          height: 200,
          width: double.infinity,
          backgroundColor: TColors.warning.withOpacity(0.2),
          child: const Center(child: Text('BOX 5')),
        ),
        const SizedBox(height: 20),
        TRoundedContainer(
          height: 200,
          width: double.infinity,
          backgroundColor: TColors.info.withOpacity(0.2),
          child: const Center(child: Text('BOX 6')),
        ),
      ],
    );
  }
}