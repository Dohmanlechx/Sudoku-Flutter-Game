// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cell.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cell _$CellFromJson(Map<String, dynamic> json) {
  return Cell(
    number: json['number'] as int,
    solutionNumber: json['solutionNumber'] as int,
    isClickable: json['isClickable'] as bool,
    isSelected: json['isSelected'] as bool,
    isHighlighted: json['isHighlighted'] as bool,
    coordinates: (json['coordinates'] as List)?.map((e) => e as int)?.toList(),
    availableNumbers:
        (json['availableNumbers'] as List)?.map((e) => e as int)?.toList(),
    maybeNumbers:
        (json['maybeNumbers'] as List)?.map((e) => e as int)?.toList(),
  );
}

Map<String, dynamic> _$CellToJson(Cell instance) => <String, dynamic>{
      'number': instance.number,
      'solutionNumber': instance.solutionNumber,
      'isClickable': instance.isClickable,
      'isSelected': instance.isSelected,
      'isHighlighted': instance.isHighlighted,
      'coordinates': instance.coordinates,
      'availableNumbers': instance.availableNumbers,
      'maybeNumbers': instance.maybeNumbers,
    };
