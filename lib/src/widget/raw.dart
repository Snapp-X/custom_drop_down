import 'dart:developer';

import 'package:flutter/material.dart';

typedef ButtonBuilder = Widget Function(
  BuildContext context,
  VoidCallback onTap,
);

typedef MenuBuilder = Widget Function(
  BuildContext context,
  double? width,
);

//* PRECISE LOCATION OF THE DROPDOWN
enum MenuPosition {
  topStart,
  topEnd,
  topCenter,
  bottomStart,
  bottomEnd,
  bottomCenter,
  rightStart,
  rightCenter,
  rightEnd,
  leftStart,
  leftCenter,
  leftEnd,
}

class RawFlexDropDown extends StatefulWidget {
  const RawFlexDropDown({
    super.key,
    required this.controller,
    required this.buttonBuilder,
    required this.menuBuilder,
    this.menuPosition = MenuPosition.bottomStart,
    this.dismissOnTapOutside = true,
  });

  final OverlayPortalController controller;

  final ButtonBuilder buttonBuilder;
  final MenuBuilder menuBuilder;
  final MenuPosition menuPosition;
  final bool dismissOnTapOutside;

  @override
  State<RawFlexDropDown> createState() => _RawFlexDropDownState();
}

class _RawFlexDropDownState extends State<RawFlexDropDown> {
  final _link = LayerLink();

  /// width of the button after the widget rendered
  double? _buttonWidth;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: widget.controller,
        overlayChildBuilder: (BuildContext context) {
          Widget menu = widget.menuBuilder(context, _buttonWidth);

          if (widget.dismissOnTapOutside) {
            log('dismissOnTapOutside');
            menu = TapRegion(
              onTapOutside: (event) {
                widget.controller.hide();
              },
              child: menu,
            );
          }

          return CompositedTransformFollower(
            link: _link,
            targetAnchor: _createTargetAnchor(direction),
            followerAnchor: _createFollowerAnchor(direction),
            showWhenUnlinked: false,
            child: Align(
              alignment: _createAlignment(),
              child: menu,
            ),
          );
        },
        child: widget.buttonBuilder(context, onTap),
      ),
    );
  }

  AlignmentDirectional _createAlignment() {
    return switch (widget.menuPosition) {
      MenuPosition.bottomEnd => AlignmentDirectional.topEnd,
      MenuPosition.bottomStart => AlignmentDirectional.topStart,
      MenuPosition.bottomCenter => AlignmentDirectional.topCenter,
      MenuPosition.topStart => AlignmentDirectional.bottomStart,
      MenuPosition.topEnd => AlignmentDirectional.bottomEnd,
      MenuPosition.topCenter => AlignmentDirectional.bottomCenter,
      MenuPosition.rightStart => AlignmentDirectional.topStart,
      MenuPosition.rightCenter => AlignmentDirectional.centerStart,
      MenuPosition.rightEnd => AlignmentDirectional.bottomStart,
      MenuPosition.leftStart => AlignmentDirectional.topEnd,
      MenuPosition.leftCenter => AlignmentDirectional.centerEnd,
      MenuPosition.leftEnd => AlignmentDirectional.bottomEnd,
    };
  }

  Alignment _createFollowerAnchor(TextDirection direction) {
    return switch (widget.menuPosition) {
      MenuPosition.bottomEnd => AlignmentDirectional.topEnd.resolve(direction),
      MenuPosition.bottomStart =>
        AlignmentDirectional.topStart.resolve(direction),
      MenuPosition.bottomCenter =>
        AlignmentDirectional.topCenter.resolve(direction),
      MenuPosition.topStart =>
        AlignmentDirectional.bottomStart.resolve(direction),
      MenuPosition.topEnd => AlignmentDirectional.bottomEnd.resolve(direction),
      MenuPosition.topCenter =>
        AlignmentDirectional.bottomCenter.resolve(direction),
      MenuPosition.rightStart =>
        AlignmentDirectional.topStart.resolve(direction),
      MenuPosition.rightCenter =>
        AlignmentDirectional.centerStart.resolve(direction),
      MenuPosition.rightEnd =>
        AlignmentDirectional.bottomStart.resolve(direction),
      MenuPosition.leftStart => AlignmentDirectional.topEnd.resolve(direction),
      MenuPosition.leftCenter =>
        AlignmentDirectional.centerEnd.resolve(direction),
      MenuPosition.leftEnd => AlignmentDirectional.bottomEnd.resolve(direction),
    };
  }

  Alignment _createTargetAnchor(TextDirection direction) {
    return switch (widget.menuPosition) {
      MenuPosition.bottomEnd =>
        AlignmentDirectional.bottomEnd.resolve(direction),
      MenuPosition.bottomStart =>
        AlignmentDirectional.bottomStart.resolve(direction),
      MenuPosition.bottomCenter =>
        AlignmentDirectional.bottomCenter.resolve(direction),
      MenuPosition.topStart => AlignmentDirectional.topStart.resolve(direction),
      MenuPosition.topEnd => AlignmentDirectional.topEnd.resolve(direction),
      MenuPosition.topCenter =>
        AlignmentDirectional.topCenter.resolve(direction),
      MenuPosition.rightStart => AlignmentDirectional.topEnd.resolve(direction),
      MenuPosition.rightCenter =>
        AlignmentDirectional.centerEnd.resolve(direction),
      MenuPosition.rightEnd =>
        AlignmentDirectional.bottomEnd.resolve(direction),
      MenuPosition.leftStart =>
        AlignmentDirectional.topStart.resolve(direction),
      MenuPosition.leftCenter =>
        AlignmentDirectional.centerStart.resolve(direction),
      MenuPosition.leftEnd =>
        AlignmentDirectional.bottomStart.resolve(direction),
    };
  }

  void onTap() {
    _buttonWidth = context.size?.width;

    widget.controller.toggle();
  }
}
