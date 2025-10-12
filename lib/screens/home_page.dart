import 'package:WeGoAgain/services/in_app_purchase_service.dart';
import 'package:WeGoAgain/services/recommendation_service.dart';
import 'package:WeGoAgain/screens/leaderboard_page.dart';
import 'package:WeGoAgain/screens/achievements_page.dart';
import 'package:WeGoAgain/providers/theme_provider.dart';
import 'package:WeGoAgain/widgets/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:WeGoAgain/widgets/avatar_card.dart';
import 'package:WeGoAgain/widgets/footer.dart';
import 'package:provider/provider.dart';
import 'package:forui/forui.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _quoteSlideAnimation;
  late List<Animation<Offset>> _slideAnimations;
  String _currentQuote = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _quoteSlideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _slideAnimations = List.generate(4, (index) {
      return Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.5 + index * 0.1,
            0.8 + index * 0.1,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _controller.forward();
    _updateQuote();
  }

  void _updateQuote() {
    setState(() {
      _currentQuote = Provider.of<RecommendationService>(context, listen: false).getRandomQuote();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FScaffold(
      header: FAppBar(
        title: const FText('WeGoAgain'),
        actions: [
          if (themeProvider.isPro)
            Chip(
              label: const FText('Pro'),
              backgroundColor: Colors.amber[500],
            ),
          FButton(
            onPress: _updateQuote,
            child: const Icon(Icons.refresh),
          ),
          // FButton(
          //   onPress: () {
          //     Provider.of<InAppPurchaseService>(context, listen: false).buyQuotePack();
          //   },
          //   child: const Icon(Icons.shopping_cart),
          // ),
          // FButton(
          //   onPress: () {
          //     Provider.of<InAppPurchaseService>(context, listen: false).restorePurchases();
          //   },
          //   child: const Icon(Icons.restore),
          // ),
          FButton(
            onPress: () => themeProvider.togglePro(),
            child: Icon(themeProvider.isPro ? Icons.star : Icons.star_border),
          ),
          FButton(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LeaderboardPage(),
                ),
              );
            },
            child: const Icon(Icons.leaderboard),
          ),
          FButton(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AchievementsPage(),
                ),
              );
            },
            child: const Icon(Icons.emoji_events),
          ),
          FButton(
            onPress: () => themeProvider.toggleTheme(),
            child: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
          ),
          FButton(
            onPress: () => themeProvider.setSystemTheme(),
            child: const Icon(Icons.auto_mode),
          ),
        ],
      ),
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: FText(
                      'I',
                      style: GoogleFonts.lora(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[500],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFFF97C2D), Color(0xFFF95B5B)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds),
                      child: FText(
                        'WeGoAgain',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _quoteSlideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FText(
                              '“',
                              style: GoogleFonts.lora(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[500],
                              ),
                              textAlign: TextAlign.start,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: FText(
                                _currentQuote,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: FText(
                                '”',
                              style: GoogleFonts.lora(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[500],
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 60,
                    width: 220,
                    child: Stack(
                      children: List.generate(4, (index) {
                        return Positioned(
                          left: index * 40.0,
                          child: SlideTransition(
                            position: _slideAnimations[index],
                            child: AvatarCard(index: index),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Spacer(flex: 3),
                  const Footer(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
