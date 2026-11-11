import 'package:equatable/equatable.dart';

class PrivacyState extends Equatable {
  const PrivacyState({this.hidden = false});
  final bool hidden;
  PrivacyState copyWith({bool? hidden}) =>
      PrivacyState(hidden: hidden ?? this.hidden);
  @override
  List<Object?> get props => [hidden];
}
