// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityPostsStreamHash() =>
    r'2a5169c881a868577c00c36c9b79026413344aed';

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
String _$communityNotifierHash() => r'0645d72682c5cc25d14e717cf4571949318e159d';

/// See also [CommunityNotifier].
@ProviderFor(CommunityNotifier)
final communityNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CommunityNotifier, List<Post>>.internal(
      CommunityNotifier.new,
      name: r'communityNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$communityNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CommunityNotifier = AutoDisposeAsyncNotifier<List<Post>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
