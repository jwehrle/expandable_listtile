library expandable_listtile;

import 'package:flutter/material.dart';

class ExpandableListTile extends StatefulWidget {
  final Widget? leading;
  final Widget title;
  final IconData iconData;
  final Widget? subTitle;
  final Widget child;

  const ExpandableListTile({
    Key? key,
    this.leading,
    required this.title,
    this.iconData = Icons.keyboard_arrow_up,
    this.subTitle,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ExpandableListTileState();
}

class ExpandableListTileState extends State<ExpandableListTile>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;
  late final AnimationController _listController;
  late final Animation<double> _listAnimation;

  @override
  void initState() {
    _iconController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 0, // initially closed
      upperBound: 0.5, // 1/2 rotation
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.linear,
    );
    _listController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: 0, // initially not visible
    );
    _listAnimation = CurvedAnimation(
      parent: _listController,
      curve: Curves.linear,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: widget.leading,
          title: widget.title,
          trailing: RotationTransition(
            turns: _iconAnimation,
            child: IconButton(
              icon: Icon(widget.iconData),
              onPressed: _onPressed,
            ),
          ),
          subtitle: widget.subTitle,
        ),
        SizeTransition(sizeFactor: _listAnimation, child: widget.child),
      ],
    );
  }

  void _onPressed() {
    if (_listAnimation.isCompleted) {
      _listController.reverse();
      _iconController.reverse();
    } else {
      _listController.forward();
      _iconController.forward();
    }
  }

  @override
  void dispose() {
    _listController.dispose();
    _iconController.dispose();
    super.dispose();
  }
}
