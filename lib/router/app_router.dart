import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/core_providers.dart';
import '../providers/auth_providers.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/health_setup_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/food/custom_food_page.dart';
import '../pages/food/food_search_page.dart';
import '../pages/history/monthly_summary_page.dart';
import '../pages/history/history_page.dart';
import '../pages/onboarding/onboarding_page.dart';
import '../widgets/main_scaffold.dart';
import '../pages/auth/biometrics_lock_screen.dart';
import '../pages/profile/reminders_page.dart';

import '../pages/auth/reset_password_page.dart';

// Provider สำหรับจำลองสถานะการกู้คืนรหัสผ่าน
final isRecoveringPasswordProvider = StateProvider<bool>((ref) => false);

// เปลี่ยน GoRouter ให้รับค่า ref เพื่อให้มันฟังเสียงจาก Auth State ได้
final routerProvider = Provider<GoRouter>((ref) {
  // ให้ Router รู้ตัวเมื่อมีการเปลี่ยนสถานะ Login/Logout (บอก Riverpod ให้ rebuild provider นี้)
  final authState = ref.watch(authStateProvider);
  ref.watch(sessionUnlockedProvider); // ให้ Router รีโหลดถ้ามีการปลดล็อก
  ref.watch(isRecoveringPasswordProvider);

  // ดักฟังเหตุการณ์การกู้คืนรหัสผ่านจาก authState
  authState.whenData((data) {
    if (data.event == AuthChangeEvent.passwordRecovery) {
      Future.microtask(() {
        ref.read(isRecoveringPasswordProvider.notifier).state = true;
      });
    }
  });

  final supabase = ref.read(supabaseProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isAuth = session != null;
      final isGoingToLogin = state.uri.path == '/login';
      final isGoingToRegister = state.uri.path == '/register';

      final isRecoveringVal = ref.read(isRecoveringPasswordProvider);
      final isGoingToReset = state.uri.path == '/reset-password';

      if (isRecoveringVal) {
        return isGoingToReset ? null : '/reset-password';
      }

      if (!isAuth) {
        return isGoingToRegister ? null : '/login';
      }

      if (isAuth && (isGoingToLogin || isGoingToRegister)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/monthly-summary',
        builder: (context, state) => const MonthlySummaryPage(),
      ),
      GoRoute(
        path: '/food-add',
        builder: (context, state) => const CustomFoodPage(),
      ),
      GoRoute(
        path: '/food-search',
        builder: (context, state) => const FoodSearchPage(),
      ),
      GoRoute(
        path: '/health-setup',
        builder: (context, state) => const HealthSetupPage(),
      ),
      GoRoute(
        path: '/lock',
        builder: (context, state) => const BiometricsLockScreen(),
      ),
      GoRoute(
        path: '/reminders',
        builder: (context, state) => const RemindersPage(),
      ),
      // --- ระบบ Bottom Navigation Bar ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          // ต้อง import '../widgets/main_scaffold.dart' ด้านบน
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Index 0: แดชบอร์ด
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          // Index 1: ประวัติ
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          // Index 2: บัญชี (โปรไฟล์สุขภาพ)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
