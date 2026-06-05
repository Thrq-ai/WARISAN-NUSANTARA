import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/daily_quiz_controller.dart';

class DailyQuizView extends GetView<DailyQuizController> {
  const DailyQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A5041),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.offNamed('/home'),
        ),
        title: const Text(
          'Daily Quiz',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6A5041)),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          itemCount: controller.questList.length,
          itemBuilder: (context, index) {
            final quest = controller.questList[index];
            return _buildQuestCard(quest);
          },
        );
      }),
    );
  }

  Widget _buildQuestCard(QuestItem quest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF6A5041),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFFAEEDA), // warna kotak
                  borderRadius: BorderRadius.circular(10), // sudut rounded
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  quest.icon,
                  width: 28,
                  height: 28,
                  color: const Color(0xFF6A5041), // warna icon
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      quest.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Reward
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAEEDA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      size: 12,
                      color: Color(0xFF854F0B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+${quest.reward}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF854F0B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: quest.progress,
              minHeight: 6,
              backgroundColor: const Color(0xFFF0F0F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                quest.isCompleted
                    ? const Color(0xFF1D9E75)
                    : const Color(0xFF6A5041),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                quest.progressLabel,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              // Tombol Claim
              if (quest.isCompleted)
                GestureDetector(
                  onTap: () => controller.claimReward(quest),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: quest.isClaimed
                          ? Colors.grey.shade300
                          : const Color(0xFF1D9E75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      quest.isClaimed ? 'Diklaim' : 'Klaim',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: quest.isClaimed ? Colors.grey : Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
