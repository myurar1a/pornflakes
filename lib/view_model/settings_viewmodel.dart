/*

import 'package:hooks_riverpod/hooks_riverpod.dart';


final fasterLoadingProvider = StateNotifierProvider<FasterLoading, bool>(
  (ref) => FasterLoading(ref.read),
);

class FasterLoading extends StateNotifier<bool> {
  FasterLoading(this._reader) : super(true) {
    initialize();
  }

  static const loadingPrefsKey = 'selectedLoading';

  final Reader _reader;

  Future initialize() async {
    final loadingIndex = await _loadingIndex;
    state = 
  }

  Future change(bool selected) async {
    await _save(selected);
    state = selected;
  }

  Future<bool> get _selectedBool async {
    final prefs = await SharedPrefe
  }
}

*/