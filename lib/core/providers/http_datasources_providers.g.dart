// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_datasources_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$httpAuthDatasourceHash() =>
    r'497df7d963756132a048ce0f5192df7f429de5be';

/// Provider for HTTP Auth Datasource
///
/// Usage:
/// ```dart
/// final authDS = ref.watch(httpAuthDatasourceProvider);
/// final response = await authDS.login(email: '...', password: '...');
/// ```
///
/// Copied from [httpAuthDatasource].
@ProviderFor(httpAuthDatasource)
final httpAuthDatasourceProvider =
    AutoDisposeProvider<HttpAuthDatasource>.internal(
      httpAuthDatasource,
      name: r'httpAuthDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$httpAuthDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpAuthDatasourceRef = AutoDisposeProviderRef<HttpAuthDatasource>;
String _$httpHabitDatasourceHash() =>
    r'99de178af7c3a1bfc93e76c05a72544f4a699fa0';

/// Provider for HTTP Habit Datasource
///
/// Usage:
/// ```dart
/// final habitDS = ref.watch(httpHabitDatasourceProvider);
/// final habits = await habitDS.getHabits(userId);
/// ```
///
/// Copied from [httpHabitDatasource].
@ProviderFor(httpHabitDatasource)
final httpHabitDatasourceProvider =
    AutoDisposeProvider<HttpHabitDatasource>.internal(
      httpHabitDatasource,
      name: r'httpHabitDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$httpHabitDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpHabitDatasourceRef = AutoDisposeProviderRef<HttpHabitDatasource>;
String _$httpCommunityChatDatasourceHash() =>
    r'bb166b08f1824835839afcb1c7041a2d6da2b1d1';

/// Provider for HTTP Community Chat Datasource
///
/// Usage:
/// ```dart
/// final chatDS = ref.watch(httpCommunityChatDatasourceProvider);
/// await chatDS.sendDirectMessage(receiverId: '...', message: '...');
/// ```
///
/// Copied from [httpCommunityChatDatasource].
@ProviderFor(httpCommunityChatDatasource)
final httpCommunityChatDatasourceProvider =
    AutoDisposeProvider<HttpCommunityChatDatasource>.internal(
      httpCommunityChatDatasource,
      name: r'httpCommunityChatDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$httpCommunityChatDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpCommunityChatDatasourceRef =
    AutoDisposeProviderRef<HttpCommunityChatDatasource>;
String _$httpUploadDatasourceHash() =>
    r'067db27bd31356e2fa065bce5725e08c80ea7e0c';

/// Provider for HTTP Upload Datasource
///
/// Usage:
/// ```dart
/// final uploadDS = ref.watch(httpUploadDatasourceProvider);
/// final response = await uploadDS.uploadAvatar(filePath: '...');
/// ```
///
/// Copied from [httpUploadDatasource].
@ProviderFor(httpUploadDatasource)
final httpUploadDatasourceProvider =
    AutoDisposeProvider<HttpUploadDatasource>.internal(
      httpUploadDatasource,
      name: r'httpUploadDatasourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$httpUploadDatasourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HttpUploadDatasourceRef = AutoDisposeProviderRef<HttpUploadDatasource>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
