// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AppSettingsCWProxy {
  AppSettings theme(AppTheme? theme);

  AppSettings isLiveDetectionEnabled(bool? isLiveDetectionEnabled);

  AppSettings activeLeafType(LeafType? activeLeafType);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  AppSettings call({
    AppTheme? theme,
    bool? isLiveDetectionEnabled,
    LeafType? activeLeafType,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAppSettings.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAppSettings.copyWith.fieldName(...)`
class _$AppSettingsCWProxyImpl implements _$AppSettingsCWProxy {
  const _$AppSettingsCWProxyImpl(this._value);

  final AppSettings _value;

  @override
  AppSettings theme(AppTheme? theme) => this(theme: theme);

  @override
  AppSettings isLiveDetectionEnabled(bool? isLiveDetectionEnabled) =>
      this(isLiveDetectionEnabled: isLiveDetectionEnabled);

  @override
  AppSettings activeLeafType(LeafType? activeLeafType) =>
      this(activeLeafType: activeLeafType);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AppSettings(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AppSettings(...).copyWith(id: 12, name: "My name")
  /// ````
  AppSettings call({
    Object? theme = const $CopyWithPlaceholder(),
    Object? isLiveDetectionEnabled = const $CopyWithPlaceholder(),
    Object? activeLeafType = const $CopyWithPlaceholder(),
  }) {
    return AppSettings(
      theme: theme == const $CopyWithPlaceholder()
          ? _value.theme
          // ignore: cast_nullable_to_non_nullable
          : theme as AppTheme?,
      isLiveDetectionEnabled:
          isLiveDetectionEnabled == const $CopyWithPlaceholder()
              ? _value.isLiveDetectionEnabled
              // ignore: cast_nullable_to_non_nullable
              : isLiveDetectionEnabled as bool?,
      activeLeafType: activeLeafType == const $CopyWithPlaceholder()
          ? _value.activeLeafType
          // ignore: cast_nullable_to_non_nullable
          : activeLeafType as LeafType?,
    );
  }
}

extension $AppSettingsCopyWith on AppSettings {
  /// Returns a callable class that can be used as follows: `instanceOfAppSettings.copyWith(...)` or like so:`instanceOfAppSettings.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AppSettingsCWProxy get copyWith => _$AppSettingsCWProxyImpl(this);
}
