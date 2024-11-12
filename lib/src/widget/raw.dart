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

  final ListenableOverlayPortalController controller;

  final ButtonBuilder buttonBuilder;
  final MenuBuilder menuBuilder;
  final MenuPosition menuPosition;
  final bool dismissOnTapOutside;

  @override
  State<RawFlexDropDown> createState() => _RawFlexDropDownState();
}

class _RawFlexDropDownState extends State<RawFlexDropDown> with SingleTickerProviderStateMixin {
  final _link = LayerLink();

  /// width of the button after the widget rendered
  double? _buttonWidth;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    widget.controller.addListener((isVisible) {
      if (isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal.targetsRootOverlay(
        controller: widget.controller,
        overlayChildBuilder: (BuildContext context) {
          Widget menu = widget.menuBuilder(context, _buttonWidth);
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                if (widget.dismissOnTapOutside)
                  Positioned.fill(
                    child: ModalBarrier(
                      color: Colors.transparent,
                      dismissible: true,
                      barrierSemanticsDismissible: true,
                      onDismiss: widget.controller.hide,
                    ),
                  ),
                CompositedTransformFollower(
                  link: _link,
                  targetAnchor: _createTargetAnchor(direction),
                  followerAnchor: _createFollowerAnchor(direction),
                  showWhenUnlinked: false,
                  child: Align(
                    alignment: _createAlignment(),
                    child: menu,
                  ),
                ),
              ],
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
    };
  }

  void onTap() {
    _buttonWidth = context.size?.width;

    widget.controller.toggle();
  }
}

typedef OverlayVisibilityChangedCallback = void Function(bool isShowing);

class ListenableOverlayPortalController extends OverlayPortalController {
  ListenableOverlayPortalController();

  final _listeners = <OverlayVisibilityChangedCallback>[];

  void addListener(OverlayVisibilityChangedCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(OverlayVisibilityChangedCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(super.isShowing);
    }
  }

  @override
  void hide() {
    super.hide();
    _notifyListeners();
  }

  @override
  void show() {
    super.show();
    _notifyListeners();
  }

  @override
  void toggle() {
    super.toggle();
    _notifyListeners();
  }
}