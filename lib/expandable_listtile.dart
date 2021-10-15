library expandable_listtile;

import 'package:flutter/material.dart';

class ExpandableListTile extends StatefulWidget {
  final Widget title;
  final Widget child;
  final IconData iconData;
  final bool isExpanded;
  final Widget? leading;
  final Widget? subTitle;
  final VoidCallback? onExpanded;
  final VoidCallback? onCollapsed;

  const ExpandableListTile({
    Key? key,
    required this.title,
    required this.child,
    this.iconData = Icons.keyboard_arrow_up,
    this.isExpanded = false,
    this.leading,
    this.subTitle,
    this.onExpanded,
    this.onCollapsed,
  })  : assert((onExpanded == null && onCollapsed == null) ||
            (onExpanded != null && onCollapsed != null)),
        super(key: key);

  @override
  State<StatefulWidget> createState() => ExpandableListTileState();
}

class ExpandableListTileState extends State<ExpandableListTile>
    with TickerProviderStateMixin {
  late final AnimationController _iconController;
  late final Animation<double> _iconAnimation;
  late final AnimationController _listController;
  late final Animation<double> _listAnimation;
  late final bool _hasCallbacks;

  @override
  void initState() {
    _iconController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: widget.isExpanded ? 1.0 : 0.0,
      upperBound: 0.5, // 1/2 rotation
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.linear,
    );
    _listController = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration,
      value: widget.isExpanded ? 1.0 : 0.0,
    );
    _listAnimation = CurvedAnimation(
      parent: _listController,
      curve: Curves.linear,
    );
    _hasCallbacks = widget.onCollapsed != null && widget.onExpanded != null;
    if (_hasCallbacks) {
      _listController.addStatusListener(_statusListener);
    }
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

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onExpanded!();
    }
    if (status == AnimationStatus.dismissed) {
      widget.onCollapsed!();
    }
  }

  @override
  void dispose() {
    if (_hasCallbacks) {
      _listController.removeStatusListener(_statusListener);
    }
    _listController.dispose();
    _iconController.dispose();
    super.dispose();
  }
}
