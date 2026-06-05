import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/halaman_quiz_controller.dart';

class HalamanQuizView extends GetView<HalamanQuizController> {
  const HalamanQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back(result: null);
          },
        ),
        title: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF6A5041),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text(
                  '${controller.score.value} Poin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),

      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 8),

            // Progress bar & level info
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level ${controller.currentIndex.value + 1} dari ${controller.totalSoal.value}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '${((controller.currentIndex.value + 1) / controller.totalSoal.value * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6A5041),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (controller.currentIndex.value + 1) /
                          controller.totalSoal.value,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF6A5041),
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Kotak soal
            Obx(
              () => Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: 100),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFF6A5041), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      controller.soalList.isNotEmpty
                          ? controller.soalList[controller.currentIndex.value]['soal']
                          : '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

                  // Timer menggantung
                  Positioned(
                    bottom: -18,
                    right: 16,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Color(0xFF6A5041), width: 1.5),
                      ),
                      child: Text(
                        '${controller.timeLeft.value}s',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: controller.timeLeft.value <= 10
                              ? Colors.red
                              : Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50),

            // Pilihan jawaban
            Expanded(
              child: Obx(() {
                if (controller.soalList.isEmpty) return SizedBox();
                final pilihan = List<String>.from(
                  controller.soalList[controller.currentIndex.value]['pilihan'],
                );
                final jawaban =
                    controller.soalList[controller.currentIndex.value]['jawaban'];

                return ListView.builder(
                  itemCount: pilihan.length,
                  itemBuilder: (context, i) {
                    final option = pilihan[i];
                    return Obx(() {
                      final isHidden = controller.hiddenOptions.contains(option);

                      Color borderColor = Color(0xFF6A5041);
                      Color bgColor = Colors.white;
                      Color textColor = Colors.black;
                      Color labelColor = Color(0xFF6A5041);

                      if (isHidden) {
                        borderColor = Colors.grey.shade300;
                        bgColor = Colors.grey.shade100;
                        textColor = Colors.grey;
                        labelColor = Colors.grey;
                      }

                      if (controller.isAnswered.value) {
                        if (option == jawaban) {
                          borderColor = Colors.green;
                          bgColor = Colors.green.shade50;
                          textColor = Colors.green;
                          labelColor = Colors.green;
                        } else if (option == controller.selectedAnswer.value) {
                          borderColor = Colors.red;
                          bgColor = Colors.red.shade50;
                          textColor = Colors.red;
                          labelColor = Colors.red;
                        }
                      }

                      return GestureDetector(
                        onTap: isHidden ? null : () => controller.answerSoal(option),
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: labelColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Text(
                                    ['A', 'B', 'C', 'D'][i],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }); // tutup Obx per item
                  },
                );
              }),
            ),

            // Power up buttons
            Obx(
              () => Padding(
                padding: EdgeInsets.only(bottom: 24, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 50:50
                    GestureDetector(
                      onTap: controller.is5050Used.value ? null : controller.use5050,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: controller.is5050Used.value
                              ? Colors.grey
                              : Color(0xFF7C5CBF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '50:50',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 24),

                    // 2x Point
                    GestureDetector(
                      onTap: controller.isDoublePointUsed.value
                          ? null
                          : controller.useDoublePoint,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: controller.isDoublePointUsed.value
                              ? Colors.grey
                              : Color(0xFFE8A020),
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF6A5041), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '2x',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}