import 'package:flutter_test/flutter_test.dart';
import 'package:busted/main.dart'; // <— usa il tuo package name reale

void main() {
  testWidgets('app loads', (tester) async {
    await tester.pumpWidget(const BustedApp());
    expect(find.text('Busted'), findsOneWidget);
  });
}
