import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:animation_project/data/model.dart';
import 'package:animation_project/screens/game_detail_screen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  List<Resource> games = [];
  bool isLoading = true;
  int currentIndex = 0;

  bool _isDetailVisible = false;
  double _detailScreenOffset = -1000;
  final PageController _pageController = PageController();

  final Duration _switchDuration = const Duration(milliseconds: 500);
  final Duration _detailScreenDuration = const Duration(milliseconds: 300);
  final Duration _imageSlideDuration = const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/resources.json',
    );
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      games =
          (jsonData['resources'] as List)
              .map((gameJson) => Resource.fromJson(gameJson))
              .toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,

      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  AnimatedSwitcher(
                    duration: _switchDuration,
                    transitionBuilder: (
                      Widget child,
                      Animation<double> animation,
                    ) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: Container(
                      key: ValueKey<int>(currentIndex),
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(games[currentIndex].image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                  PageView.builder(
                    controller: _pageController,
                    itemCount: games.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        _isDetailVisible = false;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isCurrentPage = index == currentIndex;
                      return GestureDetector(
                        onVerticalDragUpdate: (details) {
                          setState(() {
                            _detailScreenOffset += details.delta.dy;
                          });
                        },
                        onVerticalDragEnd: (details) {
                          // final velocity = details.velocity.pixelsPerSecond.dy;
                          setState(() {
                            if (_detailScreenOffset > -700) {
                              _detailScreenOffset = 0;
                              _isDetailVisible = true;
                            } else {
                              _detailScreenOffset = -size.height;
                              _isDetailVisible = false;
                            }
                          });
                        },
                        child: Stack(
                          children: [
                            AnimatedPositioned(
                              duration: _detailScreenDuration,
                              curve: Curves.easeInOut,
                              top: _isDetailVisible ? size.height * 0.75 : 0,
                              left: 0,
                              height: size.height,
                              width: size.width,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 40),
                                width: size.width,
                                child: GameCard(
                                  key: ValueKey<int>(index),
                                  game: games[index],
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: _detailScreenDuration,
                              curve: Curves.easeInOut,
                              top: _isDetailVisible ? size.height : 150,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 200, // 원하는 너비로 설정 (예: 150)
                                  height: 350,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.asset(
                                          games[index].image,
                                          fit:
                                              BoxFit
                                                  .cover, // cover로 변경하여 컨테이너를 채우도록 함
                                        ),
                                      )
                                      .animate(target: isCurrentPage ? 1 : 0)
                                      .slideX(
                                        begin: 0.2,
                                        end: 0,
                                        duration: _imageSlideDuration,
                                      )
                                      .fadeIn(begin: 0.8),
                                ),
                              ),
                            ),
                            AnimatedPositioned(
                              duration: _detailScreenDuration,
                              curve: Curves.easeInOut,
                              top: _isDetailVisible ? 0 : _detailScreenOffset,
                              left: 0,
                              right: 0,
                              height: size.height * 0.98,
                              child: SafeArea(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: DetailScreen(
                                        id: games[index].id,
                                        title: games[index].title,
                                        subtitle: games[index].subtitle,
                                        officialRating:
                                            games[index].officialRating,
                                        description: games[index].description,
                                        trailerUrl: games[index].trailerUrl,
                                        image: games[index].image,
                                        platform: games[index].platform,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isDetailVisible = false;
                                          _detailScreenOffset =
                                              -MediaQuery.of(
                                                context,
                                              ).size.height;
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_up_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }
}

class GameCard extends StatelessWidget {
  final Resource game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 200,
          bottom: 20,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 300),
                Text(
                  '"${game.title}"',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Official Rating',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (i) => Icon(
                      Icons.star,
                      color:
                          i < game.officialRating ? Colors.orange : Colors.grey,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  game.description,
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
            ),
            child: const Text('Add to cart +'),
          ),
        ),
      ],
    );
  }
}
