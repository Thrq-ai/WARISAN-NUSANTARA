import 'package:get/get.dart';

import '../modules/continue/bindings/continue_binding.dart';
import '../modules/continue/views/continue_view.dart';
import '../modules/daily_quiz/bindings/daily_quiz_binding.dart';
import '../modules/daily_quiz/views/daily_quiz_view.dart';
import '../modules/game_kategori/bindings/game_kategory_binding.dart';
import '../modules/game_kategori/views/game_kategory_view.dart';
import '../modules/game_level/bindings/game_level_binding.dart';
import '../modules/game_level/views/game_level_view.dart';
import '../modules/halaman_quiz/bindings/halaman_quiz_binding.dart';
import '../modules/halaman_quiz/views/halaman_quiz_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/koleksi/bindings/koleksi_binding.dart';
import '../modules/koleksi/views/koleksi_view.dart';
import '../modules/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/leaderboard/views/leaderboard_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_settings/bindings/profile_settings_binding.dart';
import '../modules/profile_settings/views/profile_settings_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/start/bindings/start_binding.dart';
import '../modules/start/views/start_view.dart';
import '../modules/statistik/bindings/statistik_binding.dart';
import '../modules/statistik/views/statistik_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.START;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
    ),
    GetPage(
      name: _Paths.START,
      page: () => const StartView(),
      binding: StartBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_SETTINGS,
      page: () => const ProfileSettingsView(),
      binding: ProfileSettingsBinding(),
    ),
    GetPage(
      name: _Paths.GAME_KATEGORY,
      page: () => const GameKategoryView(),
      binding: GameKategoryBinding(),
    ),
    GetPage(
      name: _Paths.GAME_LEVEL,
      page: () => const GameLevelView(),
      binding: GameLevelBinding(),
    ),
    GetPage(
      name: _Paths.HALAMAN_QUIZ,
      page: () => const HalamanQuizView(),
      binding: HalamanQuizBinding(),
    ),
    GetPage(
      name: _Paths.CONTINUE,
      page: () => const ContinueView(),
      binding: ContinueBinding(),
    ),
    GetPage(
      name: _Paths.STATISTIK,
      page: () => const StatistikView(),
      binding: StatistikBinding(),
    ),
    GetPage(
      name: _Paths.DAILY_QUIZ,
      page: () => const DailyQuizView(),
      binding: DailyQuizBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.KOLEKSI,
      page: () => const KoleksiView(),
      binding: KoleksiBinding(),
    ),
  ];
}
