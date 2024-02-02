part of 'dead_sheep_widgets_imports.dart';

class DiedInfo extends StatelessWidget {
  final String date;
  const DiedInfo({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return AppText('Died on: $date', fontSize: 12.sp, color: Colors.black);
  }
}
