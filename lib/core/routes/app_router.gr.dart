// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [CapturePage]
class CaptureRoute extends PageRouteInfo<void> {
  const CaptureRoute({List<PageRouteInfo>? children})
    : super(CaptureRoute.name, initialChildren: children);

  static const String name = 'CaptureRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CapturePage();
    },
  );
}

/// generated route for
/// [HistoryPage]
class HistoryRoute extends PageRouteInfo<void> {
  const HistoryRoute({List<PageRouteInfo>? children})
    : super(HistoryRoute.name, initialChildren: children);

  static const String name = 'HistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HistoryPage();
    },
  );
}

/// generated route for
/// [TranslationDetailPage]
class TranslationDetailRoute extends PageRouteInfo<TranslationDetailRouteArgs> {
  TranslationDetailRoute({
    Key? key,
    required TranslationEntity translation,
    List<PageRouteInfo>? children,
  }) : super(
         TranslationDetailRoute.name,
         args: TranslationDetailRouteArgs(key: key, translation: translation),
         initialChildren: children,
       );

  static const String name = 'TranslationDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TranslationDetailRouteArgs>();
      return TranslationDetailPage(
        key: args.key,
        translation: args.translation,
      );
    },
  );
}

class TranslationDetailRouteArgs {
  const TranslationDetailRouteArgs({this.key, required this.translation});

  final Key? key;

  final TranslationEntity translation;

  @override
  String toString() {
    return 'TranslationDetailRouteArgs{key: $key, translation: $translation}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TranslationDetailRouteArgs) return false;
    return key == other.key && translation == other.translation;
  }

  @override
  int get hashCode => key.hashCode ^ translation.hashCode;
}
