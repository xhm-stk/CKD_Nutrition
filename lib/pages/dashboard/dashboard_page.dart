import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../providers/core_providers.dart';
import '../../providers/meal_providers.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';

import '../../services/quota_engine.dart';

import '../../widgets/meals_list.dart';
import '../../widgets/offline_banner.dart';
import '../../models/supabase/daily_log.dart';
import 'package:intl/intl.dart';

import 'widgets/dashboard_nutrients.dart';
import 'widgets/ai_planner_card.dart';
import 'widgets/dashboard_warnings.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      backgroundColor: AppTheme.bgBase,
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
                    // Header with staggered animation
                    Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat(
                                      'dd / MM / yyyy',
                                    ).format(DateTime.now()),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'แดชบอร์ด',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.bgSurface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  ref
                                      .read(themeProvider.notifier)
                                      .toggleTheme();
                                },
                                icon: Icon(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                ),
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        )
                        .animate()
                        .fade(duration: 500.ms)
                        .slideY(begin: 0.1, curve: Curves.easeOutCubic),
                    const SizedBox(height: 24),

                    const OfflineBanner(),

                    // Nutrients card — staggered
                    DashboardNutrientsWidget(quotas: quotas)
                        .animate()
                        .fade(delay: 200.ms, duration: 500.ms)
                        .slideY(begin: 0.08),
                    const SizedBox(height: 24),

                    // AI Planner — staggered
                    const AiPlannerCardWidget()
                        .animate()
                        .fade(delay: 400.ms, duration: 500.ms)
                        .slideY(begin: 0.08),
                    const SizedBox(height: 24),

                    // Warnings — staggered
                    DashboardWarningsWidget(quotas: quotas)
                        .animate()
                        .fade(delay: 600.ms, duration: 500.ms)
                        .slideY(begin: 0.08),

                    const Divider(height: 32, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'รายการมื้ออาหารวันนี้',
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
            error: (e, st) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
          ),
        ),
      ),
    );
  }
}
