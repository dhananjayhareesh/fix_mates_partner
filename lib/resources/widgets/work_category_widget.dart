import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String imagePath;
  final String title;

  const GridItem({required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
