import 'package:flutter/material.dart';
import 'aligh.dart';
import 'morningmanifesto.dart';
import 'organize.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller to manage which page is visible
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of the onboarding pages
  final List<Widget> _pages = [
    const MorningManifestoPage(),
    const AlignPage(),
    const OrganizePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Listen for page changes to update the UI
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // The PageView where the magic happens
            Expanded(
              child: PageView(
                controller: _pageController,
                children: _pages,
              ),
            ),

            // The navigation controls
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Arrow
                  Visibility(
                    visible: _currentPage > 0, // Show only if not on the first page
                    maintainSize: true, 
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 30),
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),

                  // Page Indicator
                  Text(
                    '${_currentPage + 1}/${_pages.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  // Right Arrow
                  Visibility(
                    visible: _currentPage < _pages.length - 1, // Show only if not on the last page
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 30),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}