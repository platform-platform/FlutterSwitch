// Copyright 2020 Nichole John Romero. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library flutter_switch;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FlutterSwitch extends StatefulWidget {
  /// Creates a material design switch.
  ///
  /// The following arguments are required:
  ///
  /// * [value] determines whether this switch is on or off.
  /// * [onToggle] is called when the user toggles the switch on or off.
  ///

  const FlutterSwitch({
    Key key,
    @required this.value,
    @required this.onToggle,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.activeTextColor = Colors.white70,
    this.inactiveTextColor = Colors.white70,
    this.toggleColor = Colors.white,
    this.width = 70.0,
    this.height = 35.0,
    this.toggleSize = 25.0,
    this.valueFontSize = 16.0,
    this.borderRadius = 20.0,
    this.padding = 4.0,
    this.showOnOff = false,
    this.activeText,
    this.inactiveText,
    this.dragStartBehavior = DragStartBehavior.start,
  })  : assert(dragStartBehavior != null),
        super(key: key);

  /// Determines if the switch is on or off.
  ///
  /// This property is required.
  final bool value;

  /// Called when the user toggles the switch.
  ///
  /// This property is required.
  ///
  /// [onToggle] should update the state of the parent [StatefulWidget]
  /// using the [setState] method, so that the parent gets rebuilt; for example:
  ///
  /// ```dart
  /// FlutterSwitch(
  ///   value: _status,
  ///   width: 110,
  ///   borderRadius: 30.0,
  ///   onToggle: (val) {
  ///     setState(() {
  ///        _status = val;
  ///     });
  ///   },
  /// ),
  /// ```
  final ValueChanged<bool> onToggle;

  /// Displays an on or off text.
  ///
  /// Text value can be override by the [activeText] and
  /// [inactiveText] properties.
  final bool showOnOff;

  /// The text to display when the switch is on.
  ///
  /// Defaults to 'On' if no value was given.
  final String activeText;

  /// The text to display when the switch is off.
  ///
  /// Defaults to 'Off' if no value was given.
  final String inactiveText;

  /// The color to use on the switch when the switch is on.
  ///
  /// Defaults to [Colors.blue].
  final Color activeColor;

  /// The color to use on the switch when the switch is off.
  ///
  /// Defaults to [Colors.grey].
  final Color inactiveColor;

  /// The color to use on the text value when the switch is on.
  ///
  /// Defaults to [Colors.white70].
  final Color activeTextColor;

  /// The color to use on the text value when the switch is off.
  ///
  /// Defaults to [Colors.white70].
  final Color inactiveTextColor;

  /// The color to use on the toggle of the switch.
  ///
  /// Defaults to [Colors.white].
  final Color toggleColor;

  /// The given width of the switch.
  ///
  /// Defaults to a width of 70.0.
  final double width;

  /// The given height of the switch.
  ///
  /// Defaults to a height of 35.0.
  final double height;

  /// The size of the toggle of the switch.
  ///
  /// Defaults to a size of 25.0.
  final double toggleSize;

  /// The font size of the values of the switch.
  ///
  /// Defaults to a size of 16.0.
  final double valueFontSize;

  /// The border radius of the switch.
  ///
  /// Defaults to the value of 20.0.
  final double borderRadius;

  /// The padding of the switch.
  ///
  /// Defaults to the value of 4.0.
  final double padding;

  final DragStartBehavior dragStartBehavior;

  @override
  _FlutterSwitchState createState() => _FlutterSwitchState();
}

class _FlutterSwitchState extends State<FlutterSwitch>
    with TickerProviderStateMixin {
  Map<Type, Action<Intent>> _actions;

  @override
  void initState() {
    super.initState();
    _actions = <Type, Action<Intent>>{
      ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _toggleHandler),
    };
  }

  void _toggleHandler(ActivateIntent intent) {
    widget.onToggle(!widget.value);

    final RenderObject renderObject = context.findRenderObject();
    renderObject.sendSemanticsEvent(const TapSemanticEvent());
  }

  void _didFinishDragging() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      actions: _actions,
      enabled: true,
      child: Builder(
        builder: (BuildContext context) {
          return Stack(
            children: [
              _FlutterSwitchRenderObjectWidget(
                dragStartBehavior: widget.dragStartBehavior,
                value: widget.value,
                onToggle: widget.onToggle,
                activeColor: widget.activeColor,
                inactiveColor: widget.inactiveColor,
                toggleColor: widget.toggleColor,
                width: widget.width,
                height: widget.height,
                toggleSize: widget.toggleSize,
                borderRadius: widget.borderRadius,
                padding: widget.padding,
                configuration: createLocalImageConfiguration(context),
                additionalConstraints: BoxConstraints.tight(
                  Size(
                    widget.width,
                    widget.height,
                  ),
                ),
                state: this,
              ),
              Positioned(
                left: 0,
                top: (widget.height / 2.0) / 2.0,
                child: Container(
                    alignment: Alignment.centerLeft,
                    width:
                        widget.width - (widget.padding * 2) - widget.toggleSize,
                    child: (widget.value) ? _activeText : SizedBox.shrink()),
              ),
              Positioned(
                right: 10.0,
                top: (widget.height / 2.0) / 2.0,
                child: Container(
                    alignment: Alignment.centerRight,
                    width:
                        widget.width - (widget.padding * 2) - widget.toggleSize,
                    child: (!widget.value) ? _inactiveText : SizedBox.shrink()),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget get _activeText {
    if (widget.showOnOff) {
      return Text(
        (widget?.activeText != null) ? widget.activeText : "On",
        style: TextStyle(
          color: widget.activeTextColor,
          fontWeight: FontWeight.w900,
          fontSize: widget.valueFontSize,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text("");
  }

  Widget get _inactiveText {
    if (widget.showOnOff) {
      return Text(
        (widget?.inactiveText != null) ? widget.inactiveText : "Off",
        style: TextStyle(
          color: widget.inactiveTextColor,
          fontWeight: FontWeight.w900,
          fontSize: widget.valueFontSize,
        ),
        textAlign: TextAlign.right,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text("");
  }
}

class _FlutterSwitchRenderObjectWidget extends LeafRenderObjectWidget {
  const _FlutterSwitchRenderObjectWidget({
    Key key,
    this.value,
    this.onToggle,
    this.activeColor,
    this.inactiveColor,
    this.toggleColor,
    this.width,
    this.height,
    this.toggleSize,
    this.borderRadius,
    this.padding,
    this.additionalConstraints,
    this.configuration,
    this.dragStartBehavior,
    this.state,
  }) : super(key: key);
  final bool value;
  final ValueChanged<bool> onToggle;
  final Color activeColor;
  final Color inactiveColor;
  final Color toggleColor;
  final double width;
  final double height;
  final double toggleSize;
  final double borderRadius;
  final double padding;
  final BoxConstraints additionalConstraints;
  final ImageConfiguration configuration;
  final DragStartBehavior dragStartBehavior;
  final _FlutterSwitchState state;

  @override
  _RenderSwitch createRenderObject(BuildContext context) {
    return _RenderSwitch(
      value: value,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      toggleColor: toggleColor,
      width: width,
      height: height,
      toggleSize: toggleSize,
      borderRadius: borderRadius,
      padding: padding,
      additionalConstraints: additionalConstraints,
      configuration: configuration,
      dragStartBehavior: dragStartBehavior,
      onToggle: onToggle,
      state: state,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderSwitch renderObject) {
    renderObject
      ..value = value
      ..activeColor = activeColor
      ..inactiveColor = inactiveColor
      ..toggleColor = toggleColor
      ..width = width
      ..height = height
      ..toggleSize = toggleSize
      ..borderRadius = borderRadius
      ..padding = padding
      ..additionalConstraints = additionalConstraints
      ..configuration = configuration
      ..dragStartBehavior = dragStartBehavior
      ..onChanged = onToggle
      ..vsync = state;
  }
}

class _RenderSwitch extends RenderToggleable {
  _RenderSwitch({
    bool value,
    ValueChanged<bool> onToggle,
    Color activeColor,
    Color inactiveColor,
    Color toggleColor,
    double width,
    double height,
    double toggleSize,
    double borderRadius,
    double padding,
    BoxConstraints additionalConstraints,
    ImageConfiguration configuration,
    DragStartBehavior dragStartBehavior,
    @required this.state,
  })  : assert(state != null),
        _toggleColor = toggleColor,
        _width = width,
        _height = height,
        _toggleSize = toggleSize,
        _borderRadius = borderRadius,
        _padding = padding,
        _configuration = configuration,
        super(
          value: value,
          tristate: false,
          activeColor: activeColor,
          inactiveColor: inactiveColor,
          onChanged: onToggle,
          additionalConstraints: additionalConstraints,
          vsync: state,
        ) {
    _drag = HorizontalDragGestureRecognizer()
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..dragStartBehavior = dragStartBehavior;
  }

  Color get toggleColor => _toggleColor;
  Color _toggleColor;
  set toggleColor(Color value) {
    assert(value != null);
    if (value == _toggleColor) return;
    _toggleColor = value;
    markNeedsPaint();
  }

  double get width => _width;
  double _width;
  set width(double value) {
    assert(value != null);
    if (value == _width) return;
    _width = value;
    markNeedsPaint();
  }

  double get height => _height;
  double _height;
  set height(double value) {
    assert(value != null);
    if (value == _height) return;
    _height = value;
    markNeedsPaint();
  }

  double get toggleSize => _toggleSize;
  double _toggleSize;
  set toggleSize(double value) {
    assert(value != null);
    if (value == _toggleSize) return;
    _toggleSize = value;
    markNeedsPaint();
  }

  double get borderRadius => _borderRadius;
  double _borderRadius;
  set borderRadius(double value) {
    if (value == _borderRadius) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  double get padding => _padding;
  double _padding;
  set padding(double value) {
    assert(value != null);
    if (value == _padding) return;
    _padding = value;
    markNeedsPaint();
  }

  Animation get toggleAnimation => _toggleAnimation;
  Animation _toggleAnimation;
  set toggleAnimation(Animation value) {
    assert(value != null);
    if (value == _toggleAnimation) return;
    _toggleAnimation = value;
    markNeedsPaint();
  }

  ImageConfiguration get configuration => _configuration;
  ImageConfiguration _configuration;
  set configuration(ImageConfiguration value) {
    assert(value != null);
    if (value == _configuration) return;
    _configuration = value;
    markNeedsPaint();
  }

  DragStartBehavior get dragStartBehavior => _drag.dragStartBehavior;
  set dragStartBehavior(DragStartBehavior value) {
    assert(value != null);
    if (_drag.dragStartBehavior == value) return;
    _drag.dragStartBehavior = value;
  }

  double get _switchLength => size.width - 2 * kRadialReactionRadius;

  HorizontalDragGestureRecognizer _drag;

  _FlutterSwitchState state;

  BoxPainter _cachedTogglePainter;
  Color _cachedToggleColor;
  bool _needsPositionAnimation = false;
  bool _isPainting = false;

  @override
  set value(bool newValue) {
    assert(value != null);
    super.value = newValue;
    if (_needsPositionAnimation) {
      _needsPositionAnimation = false;
      position
        ..curve = null
        ..reverseCurve = null;
      if (newValue)
        positionController.forward();
      else
        positionController.reverse();
    }
  }

  @override
  void detach() {
    _cachedTogglePainter?.dispose();
    _cachedTogglePainter = null;
    super.detach();
  }

  void _handleDragStart(DragStartDetails details) {
    if (isInteractive) reactionController.forward();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (isInteractive) {
      position
        ..curve = null
        ..reverseCurve = null;
      final double delta = details.primaryDelta / _switchLength;
      positionController.value += delta;
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    _needsPositionAnimation = true;

    if (position.value >= 0.5 != value) onChanged(!value);
    reactionController.reverse();
    state._didFinishDragging();
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && onChanged != null) _drag.addPointer(event);
    super.handleEvent(event, entry);
  }

  void _handleDecorationChanged() {
    if (!_isPainting) markNeedsPaint();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isToggled = value == true;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Canvas canvas = context.canvas;
    final double currentValue = position.value;

    double visualPosition;

    visualPosition = (value)
        ? visualPosition = currentValue * _switchLength - padding
        : visualPosition = currentValue * _switchLength;

    final Color switchColor = Color.lerp(
      inactiveColor,
      activeColor,
      currentValue,
    );

    final Paint paint = Paint()..color = switchColor;
    final Rect switchRect = Rect.fromLTWH(
      offset.dx - padding,
      offset.dy,
      width + padding,
      height,
    );

    final RRect switchRRect = RRect.fromRectAndRadius(
      switchRect,
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(switchRRect, paint);

    // toggle properties
    final Offset togglePosition = Offset(
      kRadialReactionRadius + visualPosition,
      size.height / 2.0,
    );

    try {
      _isPainting = true;
      BoxPainter togglePainer;

      if (_cachedTogglePainter == null || toggleColor != _cachedToggleColor) {
        _cachedToggleColor = toggleColor;
        _cachedTogglePainter = BoxDecoration(
          color: toggleColor,
          shape: BoxShape.circle,
        ).createBoxPainter(_handleDecorationChanged);
      }

      togglePainer = _cachedTogglePainter;

      final double radius = (toggleSize / 2);

      togglePainer.paint(
        canvas,
        togglePosition + offset - Offset(radius, radius),
        configuration.copyWith(size: Size.fromRadius(radius)),
      );
    } finally {
      _isPainting = false;
    }
  }
}
