// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashvars.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Flashvars _$$_FlashvarsFromJson(Map<String, dynamic> json) => _$_Flashvars(
      videoUnavailable: json['video_unavailable'] as String,
      actionTags: json['actionTags'] as String,
      relatedUrl: json['related_url'] as String,
      imageUrl: json['image_url'] as String,
      mediaPriority: json['mediaPriority'] as String,
      mediaDefinitions: (json['mediaDefinitions'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      unavaliableCountry: json['video_unavailable_country'] as String,
      hotspots: json['hotspots'] as List<dynamic>,
      nextVideo: json['nextVideo'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$_FlashvarsToJson(_$_Flashvars instance) =>
    <String, dynamic>{
      'video_unavailable': instance.videoUnavailable,
      'actionTags': instance.actionTags,
      'related_url': instance.relatedUrl,
      'image_url': instance.imageUrl,
      'mediaPriority': instance.mediaPriority,
      'mediaDefinitions': instance.mediaDefinitions,
      'video_unavailable_country': instance.unavaliableCountry,
      'hotspots': instance.hotspots,
      'nextVideo': instance.nextVideo,
    };
