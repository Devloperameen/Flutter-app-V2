// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatMessagesStreamHash() =>
    r'751ae8f666f5c2105e4099b9d85f18d442015812';

/// Stream provider for real-time chat messages
///
/// Copied from [chatMessagesStream].
@ProviderFor(chatMessagesStream)
final chatMessagesStreamProvider =
    AutoDisposeStreamProvider<List<ChatMessage>>.internal(
      chatMessagesStream,
      name: r'chatMessagesStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatMessagesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatMessagesStreamRef = AutoDisposeStreamProviderRef<List<ChatMessage>>;
String _$chatNotifierHash() => r'8d2b622ba5a7def1df054179de73c2bdfe6f7513';

/// Notifier for chat operations (send, delete, etc.)
///
/// Copied from [ChatNotifier].
@ProviderFor(ChatNotifier)
final chatNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ChatNotifier, void>.internal(
      ChatNotifier.new,
      name: r'chatNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChatNotifier = AutoDisposeAsyncNotifier<void>;
String _$chatUserInfoNotifierHash() =>
    r'0df86e2425b4068634fd128fe9468ba38c6b8a47';

/// Notifier for managing current user info for chat
///
/// Copied from [ChatUserInfoNotifier].
@ProviderFor(ChatUserInfoNotifier)
final chatUserInfoNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      ChatUserInfoNotifier,
      ({String userId, String userName, String? profilePhoto})?
    >.internal(
      ChatUserInfoNotifier.new,
      name: r'chatUserInfoNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chatUserInfoNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChatUserInfoNotifier =
    AutoDisposeAsyncNotifier<
      ({String userId, String userName, String? profilePhoto})?
    >;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
