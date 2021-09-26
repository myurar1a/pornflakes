import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pornflakes/model/freezed/list_item.dart';
part 'video_info.freezed.dart';

@freezed
abstract class VideoInfo with _$VideoInfo {
  const factory VideoInfo({
    required final String phUrl,
    required final String title,
    required final String channelName,
    required final String channelIcon,
    required final String channelUrl,
    required final String channelVideoNum,
    required final String channelSubscriberNum,
    required final String sub,
    required final String unsub,
    required final String views,
    required final String forPublished,
    required final String uploadDate,
    required final String imageSrc,
    required final String goodRate,
    required final int votesUp,
    required final int votesDown,
    required final String votesUpUrl,
    required final String votesDownUrl,
    required final Map<int, Map<String, String>> hlsInfo,
    required final List<double>? hotspots,
    required final List<StarInfo> stars,
    required final List<CategoryInfo> category,
    required final List<ProductionInfo> production,
    required final List<String> tags,
    required final List<ListItem> relatedVideo,
  }) = _VideoInfo;
}

@freezed
abstract class StarInfo with _$StarInfo {
  const factory StarInfo({
    required final String? starName,
    required final String? starHref,
    required final String? starSrc,
  }) = _StarInfo;
}

@freezed
abstract class CategoryInfo with _$CategoryInfo {
  const factory CategoryInfo({
    required final String? categoryName,
    required final String? categoryHref,
  }) = _CategoryInfo;
}

@freezed
abstract class ProductionInfo with _$ProductionInfo {
  const factory ProductionInfo({
    required final String? productionName,
    required final String? productionHref,
  }) = _ProductionInfo;
}
