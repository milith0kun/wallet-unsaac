import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wallet_unsaac/features/wallet/presentation/cubits/privacy_state.dart';

class PrivacyCubit extends Cubit<PrivacyState> {
  PrivacyCubit({bool initialHidden = false})
      : super(PrivacyState(hidden: initialHidden));

  void toggle() => emit(state.copyWith(hidden: !state.hidden));
  void hide() => emit(state.copyWith(hidden: true));
  void show() => emit(state.copyWith(hidden: false));
}
