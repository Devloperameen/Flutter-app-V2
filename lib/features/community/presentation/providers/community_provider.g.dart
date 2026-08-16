// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityPostsStreamHash() =>
    r'906b0d61b33647b1852c7db3a8cd1aeb0760e0dd';

/// Stream provider for backward compatibility — UI screens that use
/// `communityPostsStreamProvider` will get real‑time updates from
/// the repository's broadcast stream.
///
/// Copied from [communityPostsStream].
@ProviderFor(communityPostsStream)
final communityPostsStreamProvider =
    AutoDisposeStreamProvider<List<Post>>.internal(
      communityPostsStream,
      name: r'communityPostsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$communityPostsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CommunityPostsStreamRef = AutoDisposeStreamProviderRef<List<Post>>;
String _$communityNotifierHash() => r'3aab84e22baf12e6c8b12e137f36a58f9cd6ffec';

/// See also [CommunityNotifier].
@ProviderFor(CommunityNotifier)
final communityNotifierProvider =
    AsyncNotifierProvider<CommunityNotifier, List<Post>>.internal(
      CommunityNotifier.new,
      name: r'communityNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$communityNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CommunityNotifier = AsyncNotifier<List<Post>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
