import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/core_providers.dart';
import '../pages/auth/login_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/health_setup_page.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/food/food_search_page.dart';
import '../pages/food/custom_food_page.dart';
import '../pages/history/history_page.dart';
import '../pages/history/monthly_summary_page.dart';
import '../pages/planner/meal_planner_page.dart';

// เปลี่ยน GoRouter ให้รับค่า ref เพื่อให้มันฟังเสียงจาก Auth State ได้
final routerProvider = Provider<GoRouter>((ref) {
  
  // ให้ Router รู้ตัวเมื่อมีการเปลี่ยนสถานะ Login/Logout (บอก Riverpod ให้ rebuild provider นี้)
  ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/dashboard', 
    redirect: (context, state) {
      // ดึงสถานะปัจจุบันว่ากำลังล็อกอินอยู่หรือไม่
      final session = ref.read(supabaseProvider).auth.currentSession;
      final isGoingToAuth = state.matchedLocation == '/login' || state.matchedLocation == '/register';
      
      if (session == null && !isGoingToAuth) return '/login'; // ไม่มี Session เตะกลับ Login
      if (session != null && isGoingToAuth) return '/dashboard'; // มี Session ข้ามไป Dashboard
      
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/health-setup', builder: (context, state) => const HealthSetupPage()),
      GoRoute(path: '/dashboard', builder: (context, state) => const DashboardPage()),
      GoRoute(
        path: '/food-search', 
        builder: (context, state) => FoodSearchPage(isar: ref.read(isarProvider)),
      ),
      GoRoute(path: '/food-add', builder: (context, state) => const CustomFoodPage()),
      GoRoute(path: '/history', builder: (context, state) => const HistoryPage()),
      GoRoute(path: '/monthly-summary', builder: (context, state) => const MonthlySummaryPage()),
      GoRoute(path: '/meal-planner', builder: (context, state) => const MealPlannerPage()),
    ],
  );
});
