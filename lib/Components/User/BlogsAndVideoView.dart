import 'package:flutter/material.dart';
import 'package:foreastro/Components/ViewImage.dart';
import 'package:google_fonts/google_fonts.dart';

class LatestBlogs extends StatelessWidget {
  const LatestBlogs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: LatestBlog(),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: LatestBlog(),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: LatestBlog(),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class LatestBlog extends StatelessWidget {
  const LatestBlog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          viewImage(
            url:
                "https://fandomwire.com/wp-content/uploads/2021/01/avengers_endgame.jpg",
            width: 280,
            radius: 20,
            height: 170,
            boxDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(height: 5),
           Text(
            "808 Angel Number Meaning and Significance",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "Khushagra Gupta",
            style: GoogleFonts.inter(
              color: Colors.black.withOpacity(0.5),
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}

class VideoViewSlide extends StatelessWidget {
  const VideoViewSlide({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: 10),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: VideoCard(),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: VideoCard(),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              viewImage(
                url:
                    "https://fandomwire.com/wp-content/uploads/2021/01/avengers_endgame.jpg",
                width: 280,
                radius: 20,
                height: 170,
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              Container(
                width: 280,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(87, 0, 0, 0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.play_circle_outline_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
           Text(
            "808 Angel Number Meaning and Significance",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "Khushagra Gupta",
            style: GoogleFonts.inter(
              color: Colors.black.withOpacity(0.5),
              fontSize: 13,
            ),
          )
        ],
      ),
    );
  }
}
