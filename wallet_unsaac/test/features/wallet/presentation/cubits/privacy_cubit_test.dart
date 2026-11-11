import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_cubit.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_state.dart';

void main() {
  group('PrivacyCubit', () {
    test('estado inicial tiene hidden en false', () {
      final cubit = PrivacyCubit();
      expect(cubit.state.hidden, isFalse);
    });

    blocTest<PrivacyCubit, PrivacyState>(
      'toggle alterna la visibilidad entre oculto y visible',
      build: () => PrivacyCubit(),
      act: (cubit) {
        cubit.toggle();
        cubit.toggle();
      },
      expect: () => [
        const PrivacyState(hidden: true),
        const PrivacyState(hidden: false),
      ],
    );
  });
}
