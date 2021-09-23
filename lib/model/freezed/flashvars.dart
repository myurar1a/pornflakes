// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'flashvars.freezed.dart';
part 'flashvars.g.dart';

@freezed
abstract class Flashvars implements _$Flashvars {
  const Flashvars._();

  const factory Flashvars({
    @JsonKey(name: 'video_unavailable')
        required String videoUnavailable, // like bool
    @JsonKey(name: 'actionTags') required String actionTags,
    @JsonKey(name: 'related_url') required String relatedUrl,
    @JsonKey(name: 'image_url') required String imageUrl,
    @JsonKey(name: 'mediaPriority') required String mediaPriority,
    @JsonKey(name: 'mediaDefinitions')
        required List<Map<String, dynamic>> mediaDefinitions,
    @JsonKey(name: 'video_unavailable_country')
        required String unavaliableCountry, // like bool
    @JsonKey(name: 'hotspots') required List<dynamic> hotspots,
    @JsonKey(name: 'nextVideo') required Map<String, dynamic> nextVideo,
  }) = _Flashvars;

  factory Flashvars.fromJson(Map<String, dynamic> json) =>
      _$FlashvarsFromJson(json);
}
