import 'package:flutter/material.dart';

@immutable
class ConfirmOpponentResultsModel {
//<editor-fold desc="Data Methods">

  const ConfirmOpponentResultsModel({
    required this.confirmation,
  });

  factory ConfirmOpponentResultsModel.fromJson(Map<String, dynamic> map) {
    return ConfirmOpponentResultsModel(
      confirmation: map['confirmation'] as bool,
    );
  }

  final bool confirmation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConfirmOpponentResultsModel &&
          runtimeType == other.runtimeType &&
          confirmation == other.confirmation);

  @override
  int get hashCode => confirmation.hashCode;

  @override
  String toString() {
    return 'ConfirmOpponentResultsModel{${' confirmation: $confirmation,'}}';
  }

  ConfirmOpponentResultsModel copyWith({
    bool? confirmation,
  }) {
    return ConfirmOpponentResultsModel(
      confirmation: confirmation ?? this.confirmation,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'confirmation': confirmation,
    };
  }

//</editor-fold>
}
