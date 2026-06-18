import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../providers/auth_providers.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/health_setup_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/food/food_search_page.dart';
import '../pages/food/custom_food_page.dart';
import '../pages/history/history_page.dart';
import '../pages/history/monthly_summary_page.dart';
import '../pages/planner/meal_planner_page.dart';
import '../widgets/main_scaffold.dart';

// เปลี่ยน GoRouter ให้รับค่า ref เพื่อให้มันฟังเสียงจาก Auth State ได้
final routerProvider = Provider<GoRouter>((ref) {
  // ให้ Router รู้ตัวเมื่อมีการเปลี่ยนสถานะ Login/Logout (บอก Riverpod ให้ rebuild provider นี้)
  ref.watch(authStateProvider);
  ref.watch(sessionUnlockedProvider); // ให้ Router รีโหลดถ้ามีการปลดล็อก

  final supabase = ref.read(supabaseProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isAuth = session != null;
      final isGoingToLogin = state.uri.path == '/login';
      final isGoingToRegister = state.uri.path == '/register';

      if (!isAuth) {
        return isGoingToRegister ? null : '/login';
      }

      if (isAuth && (isGoingToLogin || isGoingToRegister)) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
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
        path: '/meal-planner',
        builder: (context, state) => const MealPlannerPage(),
      ),
      GoRoute(
        path: '/food-add',
        builder: (context, state) => const CustomFoodPage(),
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
          // Index 1: ไดอารี่ (ประวัติ)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),
          // Index 2: รายการอาหาร
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/food-search',
                builder: (context, state) => const FoodSearchPage(),
              ),
            ],
          ),
          // Index 3: บัญชี (โปรไฟล์สุขภาพชั่วคราว)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/health-setup',
                builder: (context, state) => const HealthSetupPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
