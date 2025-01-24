import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../api/fetch_mealbyid.dart';
import '../model/meal_block.dart';

class RecipeDetailPage extends StatelessWidget {
  final String mealId;

  const RecipeDetailPage({Key? key, required this.mealId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Meal>(
        future: fetchMealById(mealId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Recipe not found.'));
          }

          final meal = snapshot.data!;

          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  height: 320,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(meal.imageUrl),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: AppBar(
                      backgroundColor: Colors.transparent, 
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/back.svg",
                            width: 24,
                            height: 24,
                            colorFilter:
                                ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 0.99,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            meal.strCategory ?? 'Category not available',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Instructions:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(meal.strInstructions),
                          SizedBox(height: 16),
                          if (meal.strYoutube != null) ...[
                            Text(
                              'Watch the tutorial:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            YoutubePlayerWidget(youtubeUrl: meal.strYoutube!),
                          ],
                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class YoutubePlayerWidget extends StatefulWidget {
  final String youtubeUrl;

  const YoutubePlayerWidget({Key? key, required this.youtubeUrl})
      : super(key: key);

  @override
  _YoutubePlayerWidgetState createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }
}
