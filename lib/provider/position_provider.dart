import 'package:hooks_riverpod/hooks_riverpod.dart';

final currentPositionProvider = StateProvider<double>((ref) {
  return 0.0;
});