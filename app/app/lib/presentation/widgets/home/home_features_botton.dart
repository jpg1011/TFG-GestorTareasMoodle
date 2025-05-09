import 'package:flutter/material.dart';

class HomeFeaturesBotton extends StatefulWidget {
  final String label;
  final Widget icon;
  final String imgPath;
  final VoidCallback onTap;

  const HomeFeaturesBotton(
      {super.key,
      required this.label,
      required this.icon,
      required this.imgPath,
      required this.onTap});

  @override
  State<HomeFeaturesBotton> createState() => _HomeFeaturesBottonState();
}

class _HomeFeaturesBottonState extends State<HomeFeaturesBotton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: widget.onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(0.0, 1.0),
                  blurRadius: 5)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              widget.icon,
              const SizedBox(width: 20),
              Text(widget.label, style: const TextStyle(fontSize: 32))
            ],
          ),
        ),
      ),
    );
  }
}
