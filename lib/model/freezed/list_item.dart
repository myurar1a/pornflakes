import 'package:freezed_annotation/freezed_annotation.dart';
part 'list_item.freezed.dart';

@freezed
abstract class ListItem with _$ListItem {
  const factory ListItem({
    required final String title,
    required final String channel,
    required final String views,
    required final String duration,
    required final String goodRate,
    required final String imageSrc,
    required final String mediabookUrl,
    required final String videoUrl,
  }) = _ListItem;
}

@freezed
abstract class ListItems with _$ListItems {
  const factory ListItems({
    required final List<ListItem> items,
    @Default(false) bool isLoading,
    final String? error,
    @Default(true) bool init,
  }) = _ListItems;
}
