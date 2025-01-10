import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Tablet extends StatelessWidget {
  const Tablet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// FIRST ROW
        Row(
          children: [
            Expanded(
              flex: 4,
              child: TRoundedContainer(
                height: 400,
                backgroundColor: TColors.primary.withOpacity(0.2),
                child: const Center(child: Text('BOX 1')),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  TRoundedContainer(
                    height: 190,
                    backgroundColor: TColors.secondary.withOpacity(0.2),
                    child: const Center(child: Text('BOX 2')),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TRoundedContainer(
                          height: 190,
                          backgroundColor: TColors.error.withOpacity(0.2),
                          child: const Center(child: Text('BOX 3')),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TRoundedContainer(
                          height: 190,
                          backgroundColor: TColors.success.withOpacity(0.2),
                          child: const Center(child: Text('BOX 4')),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        /// SECOND ROW
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TRoundedContainer(
              height: 190,
              width: double.infinity,
              backgroundColor: TColors.warning.withOpacity(0.2),
              child: const Center(child: Text('BOX 5')),
            ),
            const SizedBox(height: 20),
            TRoundedContainer(
              height: 190,
              width: double.infinity,
              backgroundColor: TColors.info.withOpacity(0.2),
              child: const Center(child: Text('BOX 6')),
            ),
          ],
        ),
      ],
    );
  }
}