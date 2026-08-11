// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminStatsHash() => r'0d1b9992ffbe2f911caa5c215f7803b871665db1';

/// Admin Statistics Provider
/// Fetches system-wide statistics for admin dashboard
///
/// Copied from [adminStats].
@ProviderFor(adminStats)
final adminStatsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
      adminStats,
      name: r'adminStatsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminStatsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminStatsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
String _$adminUsersHash() => r'443c46dc52d200154d9eb18d3290e38c77cbc645';

/// Admin Users Provider
/// Fetches all users for user management
///
/// Copied from [adminUsers].
@ProviderFor(adminUsers)
final adminUsersProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
      adminUsers,
      name: r'adminUsersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminUsersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminUsersRef =
    AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
String _$adminPostsHash() => r'2cfb8c95e4df801deace4cd7ab34eda8e0edb166';

/// Admin Posts Provider
/// Fetches all posts for content moderation
///
/// Copied from [adminPosts].
@ProviderFor(adminPosts)
final adminPostsProvider =
    AutoDisposeFutureProvider<List<Map<String, dynamic>>>.internal(
      adminPosts,
      name: r'adminPostsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminPostsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminPostsRef =
    AutoDisposeFutureProviderRef<List<Map<String, dynamic>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
