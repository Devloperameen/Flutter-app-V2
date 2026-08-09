// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communityPostsStreamHash() =>
    r'6c22056b181beb16206f57eddece180ed8cef3e9';

/// See also [communityPostsStream].
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
String _$communityNotifierHash() => r'9cf1f02cc98558763e549c87831e3c2a744d2d7a';

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
