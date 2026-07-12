import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';
import '../../widgets/mesh_gradient_background.dart';
import '../../l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<_OnboardingSlide> _getSlides(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return [
      _OnboardingSlide(
        icon: Icons.water_drop_rounded,
        title: l10n.onboardingTitle1,
        titleEn: 'Nutrition Management',
        description: l10n.onboardingDesc1,
      ),
      _OnboardingSlide(
        icon: Icons.offline_bolt_rounded,
        title: l10n.onboardingTitle2,
        titleEn: 'Offline-First',
        description: l10n.onboardingDesc2,
      ),
      _OnboardingSlide(
        icon: Icons.shield_rounded,
        title: l10n.onboardingTitle3,
        titleEn: 'Military-Grade Security',
        description: l10n.onboardingDesc3,
      ),
      _OnboardingSlide(
        icon: Icons.local_fire_department_rounded,
        title: l10n.onboardingTitle4,
        titleEn: 'Let\'s Get Started!',
        description: l10n.onboardingDesc4,
      ),
    ];
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (!mounted) return;
    context.go('/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgBase,
      body: MeshGradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _completeOnboarding,
                    child: Text(
                      AppLocalizations.of(context)!.skip,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _getSlides(context).length,
                  onPageChanged:
                      (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) {
                    final slide = _getSlides(context)[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon
                          Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.brandPrimary.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                                child: Icon(
                                  slide.icon,
                                  size: 56,
                                  color: AppTheme.brandPrimary,
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.brandPrimary.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .scale(
                                duration: 500.ms,
                                curve: Curves.easeOutBack,
                              )
                              .fade(duration: 400.ms),

                          const SizedBox(height: 48),

                          // Title
                          Text(
                                slide.title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              )
                              .animate()
                              .fade(delay: 200.ms, duration: 400.ms)
                              .slideY(begin: 0.1),

                          const SizedBox(height: 8),

                          Text(
                            slide.titleEn,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppTheme.brandPrimary.withValues(
                                alpha: 0.7,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ).animate().fade(delay: 300.ms, duration: 400.ms),

                          const SizedBox(height: 24),

                          // Description
                          Text(
                                slide.description,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.white.withValues(alpha: 0.6),
                                ),
                                textAlign: TextAlign.center,
                              )
                              .animate()
                              .fade(delay: 400.ms, duration: 400.ms)
                              .slideY(begin: 0.05),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Dots + Button
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
                child: Column(
                  children: [
                    // Page dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_getSlides(context).length, (
                        index,
                      ) {
                        final isActive = index == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                isActive
                                    ? AppTheme.brandPrimary
                                    : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 32),

                    // Action button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.brandPrimary,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          if (_currentPage == _getSlides(context).length - 1) {
                            _completeOnboarding();
                          } else {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          _currentPage == _getSlides(context).length - 1
                              ? AppLocalizations.of(context)!.getStarted
                              : AppLocalizations.of(context)!.next,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String titleEn;
  final String description;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.titleEn,
    required this.description,
  });
}
