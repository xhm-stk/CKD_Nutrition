import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
import '../../providers/meal_providers.dart';
import '../../widgets/mesh_gradient_background.dart';

import '../../services/quota_engine.dart';

import '../../widgets/meals_list.dart';
import '../../models/supabase/daily_log.dart';
import 'widgets/dashboard_nutrients.dart';
import 'widgets/dashboard_warnings.dart';
import 'widgets/dashboard_calendar.dart';
import 'widgets/fluid_balance.dart';
import 'widgets/dashboard_recommendations.dart';
import 'package:ckd_nutrition_app/l10n/app_localizations.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dismiss keyboard on dashboard entry to prevent keyboard sticking from auth/setup pages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.primaryFocus?.unfocus();
    });

    ref.listen<AsyncValue<DailyLog?>>(dashboardSummaryProvider, (
      previous,
      next,
    ) {
      if (next is AsyncData && next.value == null) {
        context.go('/health-setup');
      }
    });

    final dashboardAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: MeshGradientBackground(
        child: SafeArea(
          child: dashboardAsync.when(
            data: (log) {
              if (log == null) {
                return const Center(child: CircularProgressIndicator());
              }

              final quotas = QuotaEngine.calculate(log: log);

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(dashboardSummaryProvider);
                  ref.invalidate(todayMealsProvider);
                },
                child: ListView(
                  key: const Key('dashboard_scrollview'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  children: [
                    const DashboardCalendar()
                        .animate()
                        .fade(delay: 100.ms, duration: 500.ms)
                        .slideY(begin: -0.05),
                    const SizedBox(height: 16),

                    // Recommendations Widget — staggered
                    DashboardRecommendationsWidget(log: log)
                        .animate()
                        .fade(delay: 150.ms, duration: 500.ms)
                        .slideY(begin: 0.08),
                    const SizedBox(height: 24),

                    // Nutrients card — staggered
                    DashboardNutrientsWidget(quotas: quotas)
                        .animate()
                        .fade(delay: 200.ms, duration: 500.ms)
                        .slideY(begin: 0.08),
                    const SizedBox(height: 24),

                    // Warnings — staggered
                    DashboardWarningsWidget(quotas: quotas)
                        .animate()
                        .fade(delay: 600.ms, duration: 500.ms)
                        .slideY(begin: 0.08),
                    const SizedBox(height: 24),

                    // Fluid Balance card — staggered
                    FluidBalanceWidget(log: log)
                        .animate()
                        .fade(delay: 700.ms, duration: 500.ms)
                        .slideY(begin: 0.08),

                    const Divider(height: 32, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        AppLocalizations.of(context)!.todaysMeals,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ).animate().fade(delay: 700.ms, duration: 500.ms),

                    // รายการมื้ออาหาร
                    const MealsListWidget().animate().fade(
                      delay: 800.ms,
                      duration: 500.ms,
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error:
                (e, st) => Center(
                  child: Text('${AppLocalizations.of(context)!.error}: $e'),
                ),
          ),
        ),
      ),
    );
  }
}
