import 'package:admin_panel/common/widgets/containers/rounded_container.dart';
import 'package:admin_panel/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class Desktop extends StatelessWidget {
  const Desktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400, // Chiều cao cho hàng đầu tiên
          child: Row(
            children: [
              // BOX 1 - Chiếm 40% chiều ngang
              Expanded(
                flex: 4,
                child: TRoundedContainer(
                  backgroundColor: TColors.primary.withOpacity(.8),
                  child: const Center(
                      child:
                          Text('BOX 1', style: TextStyle(color: Colors.white))),
                ),
              ),
              const SizedBox(width: 30),
              // Column chứa BOX 2, 3, 4 - Chiếm 60% chiều ngang
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // BOX 2
                    Expanded(
                      child: TRoundedContainer(
                        backgroundColor: TColors.secondary.withOpacity(.8),
                        child: const Center(
                            child: Text('BOX 2',
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Row chứa BOX 3, 4
                    Expanded(
                      child: Row(
                        children: [
                          // BOX 3
                          Expanded(
                            child: TRoundedContainer(
                              backgroundColor: TColors.error.withOpacity(.8),
                              child: const Center(
                                  child: Text('BOX 3',
                                      style: TextStyle(color: Colors.white))),
                            ),
                          ),
                          const SizedBox(width: 30),
                          // BOX 4
                          Expanded(
                            child: TRoundedContainer(
                              backgroundColor: TColors.success.withOpacity(.8),
                              child: const Center(
                                  child: Text('BOX 4',
                                      style: TextStyle(color: Colors.white))),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        // Row cuối cùng chứa BOX 5, 6
        SizedBox(
          height: 200, // Chiều cao cho hàng cuối
          child: Row(
            children: [
              // BOX 5 - Chiếm 65% chiều ngang
              Expanded(
                flex: 65,
                child: TRoundedContainer(
                  backgroundColor: TColors.warning.withOpacity(.8),
                  child: const Center(
                      child:
                          Text('BOX 5', style: TextStyle(color: Colors.white))),
                ),
              ),
              const SizedBox(width: 30),
              // BOX 6 - Chiếm 35% chiều ngang
              Expanded(
                flex: 35,
                child: TRoundedContainer(
                  backgroundColor: TColors.info.withOpacity(.8),
                  child: const Center(
                      child:
                          Text('BOX 6', style: TextStyle(color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}