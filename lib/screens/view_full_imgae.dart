import 'package:flutter/material.dart';

class ViewFullImage extends StatefulWidget {
  final String image;
  const ViewFullImage({Key? key, required this.image}) : super(key: key);

  @override
  State<ViewFullImage> createState() => _ViewFullImageState();
}

class _ViewFullImageState extends State<ViewFullImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.down,
          onDismissed: (direction) {
            Navigator.pop(context);
          },
          child: Image.network(
            widget.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
