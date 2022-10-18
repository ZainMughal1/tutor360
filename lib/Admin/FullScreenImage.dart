import 'package:flutter/material.dart';
class FullScreenImage extends StatefulWidget {
  String imageUrl;
  FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child:Image.network(widget.imageUrl),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}