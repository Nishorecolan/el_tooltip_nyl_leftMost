import 'package:el_tooltip_example/nyl_tooltip.dart';
import 'package:el_tooltip_example/src/arrow.dart';
import 'package:el_tooltip_example/src/bubble.dart';
import 'package:el_tooltip_example/src/element_box.dart';
import 'package:el_tooltip_example/src/modal.dart';
import 'package:el_tooltip_example/src/tooltip_elements_display.dart';
import 'package:flutter/material.dart';

import '../nyl_tooltip.dart';

class NYLTooltipOverlay extends StatefulWidget {
  const NYLTooltipOverlay({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14.0),
    this.showModal = true,
    this.showArrow = true,
    this.showChildAboveOverlay = true,
    this.modalConfiguration = const ModalConfiguration(),
    required this.toolTipElementsDisplay,
    required this.color,
    required this.content,
    required this.hideOverlay,
    required this.triggerBox,
    required this.arrowBox,
    required this.appearAnimationDuration,
    required this.disappearAnimationDuration,
    this.longTailPosition = 'Center',
  });

  final Widget child;

  final Color color;

  final Widget content;

  final EdgeInsetsGeometry padding;

  final bool showModal;

  final bool showArrow;

  final bool showChildAboveOverlay;

  final ModalConfiguration modalConfiguration;

  final ToolTipElementsDisplay toolTipElementsDisplay;

  final VoidCallback hideOverlay;

  final ElementBox triggerBox;

  final ElementBox arrowBox;

  final Duration appearAnimationDuration;

  final Duration disappearAnimationDuration;

  final String longTailPosition;

  @override
  State<NYLTooltipOverlay> createState() => NYLTooltipOverlayState();
}

class NYLTooltipOverlayState extends State<NYLTooltipOverlay> {
  bool closing = false;
  double opacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => show());
  }

  Future<void> show() async {
    setState(() {
      closing = false;
      opacity = 1;
    });
    await Future.delayed(widget.appearAnimationDuration);
  }

  Future<void> hide() async {
    setState(() {
      closing = true;
      opacity = 0;
    });
    await Future.delayed(widget.disappearAnimationDuration);
  }

  @override
  Widget build(BuildContext context) {
    print('value is ${widget.toolTipElementsDisplay.arrow.y}');
    print('Postion ${ widget.toolTipElementsDisplay.position}');
    return AnimatedOpacity(
      opacity: opacity,
      duration: closing
          ? widget.disappearAnimationDuration
          : widget.appearAnimationDuration,
      child: Stack(
        children: [
          Modal(
            color: widget.modalConfiguration.color,
            opacity: widget.modalConfiguration.opacity,
            visible: widget.showModal,
            onTap: widget.hideOverlay,
          ),
          Positioned(
            top: widget.toolTipElementsDisplay.bubble.y,
            left: widget.toolTipElementsDisplay.bubble.x,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 3,
                   spreadRadius: 5,
                   offset: Offset(0, 5), // Shadow position
                  ),
                ],
              ),
              child: Bubble(
                triggerBox: widget.triggerBox,
                padding: widget.padding,
                radius: widget.toolTipElementsDisplay.position == NYLTooltipPosition.leftMost ||
                        widget.toolTipElementsDisplay.position == NYLTooltipPosition.topMost ||
                        widget.toolTipElementsDisplay.position == NYLTooltipPosition.endMost ||
                        widget.toolTipElementsDisplay.position == NYLTooltipPosition.rightMost
                    ?  BorderRadius.only(
                        bottomRight: Radius.circular(widget.toolTipElementsDisplay.position == NYLTooltipPosition.endMost ? 0 :8),
                        bottomLeft: Radius.circular(
                            widget.toolTipElementsDisplay.position == NYLTooltipPosition.leftMost
                                || widget.toolTipElementsDisplay.position == NYLTooltipPosition.rightMost ? 8 : 0),
                        topRight: Radius.circular(widget.toolTipElementsDisplay.position == NYLTooltipPosition.rightMost ? 0 : 8),
                        topLeft: Radius.circular(widget.toolTipElementsDisplay.position == NYLTooltipPosition.leftMost ? 0 : 8),
                      )
                    : widget.toolTipElementsDisplay.radius,
                color: widget.color,
                child: widget.content,
              ),
            ),
          ),
          if (widget.showArrow == widget.showArrow)
            Positioned(
              top: widget.toolTipElementsDisplay.position == NYLTooltipPosition.topStart ||
                      widget.toolTipElementsDisplay.position == NYLTooltipPosition.topEnd ||
                      widget.toolTipElementsDisplay.position == NYLTooltipPosition.topCenter
                  ? widget.toolTipElementsDisplay.arrow.y - 0.5
                  : widget.toolTipElementsDisplay.position == NYLTooltipPosition.topMost
                  ? widget.toolTipElementsDisplay.arrow.y + 0.2
                  : widget.toolTipElementsDisplay.position == NYLTooltipPosition.endMost
                  ? widget.toolTipElementsDisplay.arrow.y
                  : widget.toolTipElementsDisplay.arrow.y - 20,
              // left: widget.longTailPosition == 'Right'
              //     ? widget.toolTipElementsDisplay.arrow.x - 19.3
              //     : widget.longTailPosition == 'Center' ? widget.toolTipElementsDisplay.arrow.x - 10
              //     : widget.toolTipElementsDisplay.arrow.x + 2,
              left: widget.longTailPosition == 'Right'
                  ? widget.toolTipElementsDisplay.arrow.x - 19.3
                  : widget.toolTipElementsDisplay.position == NYLTooltipPosition.leftMost
                  ? widget.toolTipElementsDisplay.arrow.x - 113
                  : widget.toolTipElementsDisplay.position == NYLTooltipPosition.rightMost
                  ? widget.toolTipElementsDisplay.arrow.x + 92
                  : widget.toolTipElementsDisplay.position == NYLTooltipPosition.endMost
                  ? widget.toolTipElementsDisplay.arrow.x + 93
                  : widget.toolTipElementsDisplay.position == NYLTooltipPosition.topMost
                  ? widget.toolTipElementsDisplay.arrow.x - 122
                  : widget.longTailPosition == 'Center'
                  ? widget.toolTipElementsDisplay.arrow.x - 10
                  : widget.toolTipElementsDisplay.arrow.x + 2,
              child: Container(
                child: Arrow(
                  color: widget.color,
                  position: widget.toolTipElementsDisplay.position,
                  width:  35,
                  height: 30,
                ),
              ),
            ),
          // if (widget.showChildAboveOverlay)
          //   Positioned(
          //     top: widget.triggerBox.y,
          //     left: widget.triggerBox.x,
          //     child: GestureDetector(
          //       onTap: widget.hideOverlay,
          //       child: widget.child,
          //     ),
          //   ),
        ],
      ),
    );
  }
}
