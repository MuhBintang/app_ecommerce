import 'package:flutter/material.dart';
import 'package:onboarding_slider_flutter/onboarding_slider_flutter.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: OnBoard(
              pageController: _pageController,
              onSkip: () {},
              onDone: () {},
              onBoardData: onBoardData,
              titleStyles: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              descriptionStyles: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.w400,
              ),
              pageIndicatorStyle: const PageIndicatorStyle(
                width: 50,
                inactiveColor: Color(0xff9CC2E1),
                activeColor: Color.fromARGB(255, 177, 68, 255),
                inactiveSize: Size(12, 5),
                activeSize: Size(12, 5),
              ),
              startButton: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    SizedBox(
                      width: 358,
                      height: 42,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 177, 68, 255),
                          ),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xfffdfdfd),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 358,
                      height: 42,
                      child: TextButton(
                        child: const Text(
                          "Already Have Account?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              imageWidth: 320,
              imageHeight: 320,
            ),
          ),
        ],
      ),
    );
  }
}

final List<OnBoardModel> onBoardData = [
  const OnBoardModel(
    title: "Various Collections Of The \nLatest Products",
    description:
        "Discover the latest fashion collections, exclusive jewelry,\n and trendy bags ready to complement your style",
    image: 'gambar/img.jpg',
  ),
  const OnBoardModel(
    title: "Complete Collections Of Colors And Sizes",
    description:
        "Enjoy an easy and enjoyable shopping experience with \nour advanced features",
    image: 'gambar/img2.jpg',
  ),
  const OnBoardModel(
    title: "Find The Most Suitable \nOutfit For You",
    description:
        "Don't miss the special offers and attractive promos \nthat we have prepared especially for you.",
    image: 'gambar/img1.jpg',
  ),
];
