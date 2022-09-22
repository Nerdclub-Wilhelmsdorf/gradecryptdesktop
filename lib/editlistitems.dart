import 'package:flutter/material.dart';
import 'package:gradecryptdesktop/main.dart';

//the "example" ListEntry for the ListView. Again, check the documentation, it's awesome.
class ListEntery extends StatefulWidget {
  final double child;
  final int indexpos;

  ListEntery({required this.child, required this.indexpos});

  @override
  State<ListEntery> createState() => _ListEnteryState();
}

class _ListEnteryState extends State<ListEntery> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          height: 40,
          child: Row(
            children: [
              Text(
                style: TextStyle(
                    color: DarkOn == true ? Colors.white : Colors.black),
                widget.child.toString(),
                textScaleFactor: 1.3,
              ),
              IconButton(
                icon: Icon(Icons.clear,
                    color: DarkOn == true ? Colors.white : Colors.black),
                onPressed: () {
                  removeItem(widget.indexpos);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ));
  }

  void removeItem(int indexposition) {
    try {
      Average.removeAt(indexposition);
      setState(() {});
    } catch (e) {}
    ;
  }
}
