import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:biscate_facil/main.dart';

void main() {
  testWidgets('A aplicação arranca sem erros', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BiscateFacilApp()),
    );

    expect(find.byType(BiscateFacilApp), findsOneWidget);
  });
}
