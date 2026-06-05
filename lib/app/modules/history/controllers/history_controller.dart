import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HistoryController extends GetxController {
  final box = GetStorage();

  Timer? timer;
  DateTime? startTime;

  final currentSession = 0.obs;
  final totalPlayTime = 0.obs;

  final historyList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    totalPlayTime.value = box.read('totalPlayTime') ?? 0;

    final data = box.read('historyList');

    if (data != null) {
      historyList.assignAll(List<Map<String, dynamic>>.from(data));
    }
  }

  void startTracking() {
    startTime = DateTime.now();

    currentSession.value = 0;

    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentSession.value++;
    });
  }

  void stopTracking(String kategori) {
    timer?.cancel();

    if (startTime == null) return;

    int duration = DateTime.now().difference(startTime!).inSeconds;

    totalPlayTime.value += duration;

    historyList.add({
      "kategori": kategori,
      "durasi": duration,
      "tanggal": DateTime.now().toIso8601String(),
    });

    saveData();
  }

  void saveData() {
    box.write('totalPlayTime', totalPlayTime.value);

    box.write('historyList', historyList.toList());
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '$hours j $minutes mnt';
    }

    if (minutes > 0) {
      return '$minutes mnt';
    }

    return '$secs dtk';
  }

  List<Map<String, dynamic>> getWeeklyChartData() {
  Map<int, double> dailyTime = {
    1: 0, // Sen
    2: 0, // Sel
    3: 0, // Rab
    4: 0, // Kam
    5: 0, // Jum
    6: 0, // Sab
    7: 0, // Min
  };

  for (var item in historyList) {
    DateTime date = DateTime.parse(item['tanggal']);

    dailyTime[date.weekday] =
        (dailyTime[date.weekday] ?? 0) +
        (item['durasi'] as int);
  }

  return [
    {"hari": "Sen", "durasi": dailyTime[1]! / 60},
    {"hari": "Sel", "durasi": dailyTime[2]! / 60},
    {"hari": "Rab", "durasi": dailyTime[3]! / 60},
    {"hari": "Kam", "durasi": dailyTime[4]! / 60},
    {"hari": "Jum", "durasi": dailyTime[5]! / 60},
    {"hari": "Sab", "durasi": dailyTime[6]! / 60},
    {"hari": "Min", "durasi": dailyTime[7]! / 60},
  ];
}

List<Map<String, dynamic>> getCategorySummary() {
  Map<String, int> categoryTime = {};

  for (var item in historyList) {
    String kategori = item['kategori'];

    categoryTime[kategori] =
        (categoryTime[kategori] ?? 0) +
        (item['durasi'] as int);
  }

  return categoryTime.entries.map((e) {
    return {
      "kategori": e.key,
      "durasi": e.value,
    };
  }).toList()
    ..sort(
      (a, b) =>
          (b['durasi'] as int)
              .compareTo(a['durasi'] as int),
    );
}

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
