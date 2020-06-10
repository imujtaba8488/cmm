part of 'go_family.dart';

class GoMessage extends StatelessWidget {
  final String message;
  final TextStyle style;

  GoMessage({this.message = 'No contents / Missing child.', this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          message,
          style: style ?? TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}