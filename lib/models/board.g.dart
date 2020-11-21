// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) {
  return Board()
    ..cells = (json['cells'] as List)
        ?.map((e) => (e as List)
            ?.map((e) =>
                e == null ? null : Cell.fromJson(e as Map<String, dynamic>))
            ?.toList())
        ?.toList()
    ..hasBeenStartedPlaying = json['hasBeenStartedPlaying'] as bool;
}

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'cells': instance.cells,
      'hasBeenStartedPlaying': instance.hasBeenStartedPlaying,
    };
