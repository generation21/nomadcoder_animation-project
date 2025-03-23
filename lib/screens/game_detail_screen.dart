import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final int id;
  final String title;
  final String subtitle;
  final String description;
  final String trailerUrl;
  final String image;
  final List<String> platform;
  final int officialRating;
  const DetailScreen({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.officialRating,
    required this.description,
    required this.trailerUrl,
    required this.image,
    required this.platform,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
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
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // 게임 제목
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "offcial Rating",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < widget.officialRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey.shade300, height: 20),
                    const SizedBox(height: 20),
                    // 플랫폼
                    GridView.count(
                      crossAxisCount: 2, // 가로 2개
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 30,
                      childAspectRatio: 1.5,
                      children:
                          widget.platform
                              .map(
                                (platform) => FractionallySizedBox(
                                  widthFactor: 0.8,
                                  heightFactor: 1,
                                  child: Image(
                                    image: AssetImage(
                                      "assets/images/${platform.toLowerCase()}.png",
                                    ),
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.gamepad,
                                        color: Colors.white,
                                        size: 30,
                                      );
                                    },
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    Divider(color: Colors.grey.shade300, height: 20),
                    const SizedBox(height: 30),
                    // 설명 타이틀
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // 게임 설명
                    Text(
                      widget.description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // 트레일러 버튼
                    Text(
                      "WATCH TRAILER",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Image.asset(widget.image, width: 300, height: 200),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
