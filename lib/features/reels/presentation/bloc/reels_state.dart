import 'package:equatable/equatable.dart';

import '../../domain/entities/reel.dart';

abstract class ReelsState extends Equatable {
  const ReelsState();

  @override
  List<Object> get props => [];
}

class ReelsInitial extends ReelsState {
  const ReelsInitial();
}

class ReelsLoading extends ReelsState {
  const ReelsLoading();
}

class ReelsLoaded extends ReelsState {
  final List<Reel> reels;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const ReelsLoaded({
    required this.reels,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  ReelsLoaded copyWith({
    List<Reel>? reels,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return ReelsLoaded(
      reels: reels ?? this.reels,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [reels, hasReachedMax, isLoadingMore];
}

class ReelsError extends ReelsState {
  final String message;
  final List<Reel> reels;

  const ReelsError({required this.message, this.reels = const []});

  @override
  List<Object> get props => [message, reels];
}

class ReelsRefreshing extends ReelsState {
  final List<Reel> reels;

  const ReelsRefreshing({required this.reels});

  @override
  List<Object> get props => [reels];
}
