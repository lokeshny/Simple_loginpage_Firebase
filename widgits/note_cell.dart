import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteCell extends StatelessWidget {

  final Color color;
  final String title;
  final Function() onTap;
  const NoteCell({Key? key, required this.color, required this.title, required this.onTap}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ,
      child: Card(
          margin: const EdgeInsets.all(22),
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
          color: color,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                    color: Colors.black45,
                  ),
                ),

              ],
            ),
          )),
    );
  }
}
