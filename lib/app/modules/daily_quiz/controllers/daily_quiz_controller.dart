import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyQuizController extends GetxController {
  final isLoading = false.obs;
  final quizList = <DailyQuizItem>[].obs;
  final questList = <QuestItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadQuiz();
    _loadQuest();
  }

  void _loadQuiz() {
    isLoading.value = true;
    quizList.value = [
      DailyQuizItem(id: 'quiz_1', title: 'Rumah Adat', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 1),
      DailyQuizItem(id: 'quiz_2', title: 'Pakaian Adat', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 2),
      DailyQuizItem(id: 'quiz_3', title: 'Tarian Tradisional', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 3),
      DailyQuizItem(id: 'quiz_4', title: 'Alat Musik', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 4),
      DailyQuizItem(id: 'quiz_5', title: 'Senjata Tradisional', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 5),
      DailyQuizItem(id: 'quiz_6', title: 'Makanan Tradisional', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 6),
      DailyQuizItem(id: 'quiz_7', title: 'Upacara Adat', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 7),
      DailyQuizItem(id: 'quiz_8', title: 'Bahasa Daerah', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 8),
      DailyQuizItem(id: 'quiz_9', title: 'Kerajaan Nusantara', subtitle: 'Lihat progres kamu', totalSoal: 3, level: 9),
    ];
    isLoading.value = false;
  }

  Future<void> _loadQuest() async {
    final prefs = await SharedPreferences.getInstance();

    questList.value = [
      QuestItem(
        id: 'quest_streak_3',
        title: 'Petualang Pemula',
        description: 'Main 3 hari berturut-turut',
        icon: 'assets/images/flame.png',
        target: 3,
        current: prefs.getInt('current_streak') ?? 0,
        reward: 100,
        type: QuestType.streak,
      ),
      QuestItem(
        id: 'quest_streak_7',
        title: 'Pejuang Budaya',
        description: 'Main 7 hari berturut-turut',
        icon: 'assets/images/calendar.png',
        target: 7,
        current: prefs.getInt('current_streak') ?? 0,
        reward: 300,
        type: QuestType.streak,
      ),
      QuestItem(
        id: 'quest_quiz_5',
        title: 'Rajin Belajar',
        description: 'Selesaikan 5 quiz',
        icon: 'assets/images/open-book.png',
        target: 5,
        current: prefs.getInt('stat_total_quiz') ?? 0,
        reward: 150,
        type: QuestType.totalQuiz,
      ),
      QuestItem(
        id: 'quest_quiz_10',
        title: 'Master Quiz',
        description: 'Selesaikan 10 quiz',
        icon: 'assets/images/trophy.png',
        target: 10,
        current: prefs.getInt('stat_total_quiz') ?? 0,
        reward: 300,
        type: QuestType.totalQuiz,
      ),
      QuestItem(
        id: 'quest_poin_500',
        title: 'Kolektor Poin',
        description: 'Kumpulkan 500 poin',
        icon: 'assets/images/star.png',
        target: 500,
        current: prefs.getInt('stat_total_poin') ?? 0,
        reward: 200,
        type: QuestType.totalPoin,
      ),
      QuestItem(
        id: 'quest_benar_50',
        title: 'Jawaban Tepat',
        description: 'Jawab benar 50 soal',
        icon: 'assets/images/check.png',
        target: 50,
        current: prefs.getInt('stat_total_benar') ?? 0,
        reward: 250,
        type: QuestType.totalBenar,
      ),
      QuestItem(
        id: 'quest_streak_jawaban',
        title: 'Kombo Hebat',
        description: 'Jawab 5 soal benar berturutan',
        icon: 'assets/images/lightning.png',
        target: 5,
        current: prefs.getInt('stat_max_streak') ?? 0,
        reward: 200,
        type: QuestType.streakJawaban,
      ),
    ];
  }

  Future<void> refreshQuestProgress() async {
  final prefs = await SharedPreferences.getInstance();
  final claimedList = prefs.getStringList('claimed_quests') ?? [];

  final statMap = {
    QuestType.streak: prefs.getInt('current_streak') ?? 0,
    QuestType.totalQuiz: prefs.getInt('stat_total_quiz') ?? 0,
    QuestType.totalPoin: prefs.getInt('stat_total_poin') ?? 0,
    QuestType.totalBenar: prefs.getInt('stat_total_benar') ?? 0,
    QuestType.streakJawaban: prefs.getInt('stat_max_streak') ?? 0,
  };

  for (final quest in questList) {
    quest.current = statMap[quest.type] ?? quest.current;
    quest.isClaimed = claimedList.contains(quest.id);

    await refreshQuestProgress();
  }
  
  questList.refresh();
}

  Future<void> claimReward(QuestItem quest) async {
    if (!quest.isCompleted || quest.isClaimed) return;

    final prefs = await SharedPreferences.getInstance();
    final claimedList = prefs.getStringList('claimed_quests') ?? [];

    if (claimedList.contains(quest.id)) return;

    claimedList.add(quest.id);
    await prefs.setStringList('claimed_quests', claimedList);

    final poinLama = prefs.getInt('stat_total_poin') ?? 0;
    await prefs.setInt('stat_total_poin', poinLama + quest.reward);

    quest.isClaimed = true;
    questList.refresh();
  }

  void mulaiQuiz(DailyQuizItem quiz) {
    Get.toNamed(
      '/halaman-quiz',
      arguments: {
        'level': quiz.level,
        'kategoriNama': quiz.title,
        'kategoriDeskripsi': quiz.subtitle,
        'kategoriImage': '',
        'kategoriWarna': 0xFF6A5041,
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class DailyQuizItem {
  final String id;
  final String title;
  final String subtitle;
  final int totalSoal;
  final int level;
  int soalSelesai;

  DailyQuizItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.totalSoal,
    required this.level,
    this.soalSelesai = 0,
  });

  double get progress => totalSoal == 0 ? 0 : soalSelesai / totalSoal;
  String get progressLabel => '${(progress * 100).toStringAsFixed(0)}%';
}

enum QuestType { streak, totalQuiz, totalPoin, totalBenar, streakJawaban }

class QuestItem {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int target;
  int current;
  final int reward;
  final QuestType type;
  bool isClaimed;

  QuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.current,
    required this.reward,
    required this.type,
    this.isClaimed = false,
  });

  bool get isCompleted => current >= target;
  double get progress => (current / target).clamp(0.0, 1.0);
  String get progressLabel => '$current / $target';
}