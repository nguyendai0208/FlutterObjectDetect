import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;
  final Color? background;
  final Color? textColor;
  final double? radius;
  final double? fontSize;
  final EdgeInsets? padding;
  final Size? minimumSize;
  DefaultButton({Key? key, required this.text, this.background = const Color.fromRGBO(63, 63, 63, 1.0), this.textColor = Colors.white, this.onPress, this.radius = 5.0, this.fontSize, this.minimumSize = Size.zero, this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 5)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(0),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 5.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(minimumSize!),
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return background!.withOpacity(0.9);
            } else if (states.contains(MaterialState.disabled)) {
              return background!.withOpacity(0.7);
            }
            return background!;
          },
        ),
      ),
      onPressed: onPress,
      child: Padding(
        padding: padding!,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor, fontSize: fontSize),
        ),
      ),
    );
  }
}
