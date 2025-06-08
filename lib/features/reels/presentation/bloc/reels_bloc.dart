import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/reel.dart';
import '../../domain/usecases/get_reels.dart';
import 'reels_event.dart';
import 'reels_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final GetReels getReels;

  int _currentPage = 1;
  final List<Reel> _reels = [];

  ReelsBloc({required this.getReels}) : super(const ReelsInitial()) {
    on<LoadReelsEvent>(_onLoadReels);
    on<LoadMoreReelsEvent>(_onLoadMoreReels);
    on<RefreshReelsEvent>(_onRefreshReels);
    on<ReelViewedEvent>(_onReelViewed);
    on<ToggleLikeEvent>(_onToggleLike);
  }

  Future<void> _onLoadReels(
    LoadReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    if (event.refresh) {
      _currentPage = 1;
      _reels.clear();
    }

    emit(const ReelsLoading());

    final result = await getReels(
      PaginationParams(
        page: _currentPage,
        limit: AppConstants.defaultPageSize,
        refresh: event.refresh,
      ),
    );

    result.fold(
      (failure) {
        emit(ReelsError(message: failure.message, reels: _reels));
      },
      (reels) {
        if (_currentPage == 1) {
          _reels.clear();
        }
        _reels.addAll(reels);

        final hasReachedMax = reels.length < AppConstants.defaultPageSize;

        emit(
          ReelsLoaded(reels: List.from(_reels), hasReachedMax: hasReachedMax),
        );
      },
    );
  }

  Future<void> _onLoadMoreReels(
    LoadMoreReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;

      if (currentState.hasReachedMax || currentState.isLoadingMore) {
        return;
      }

      emit(currentState.copyWith(isLoadingMore: true));

      _currentPage++;

      final result = await getReels(
        PaginationParams(
          page: _currentPage,
          limit: AppConstants.defaultPageSize,
        ),
      );

      result.fold(
        (failure) {
          _currentPage--; // Revert page increment on failure
          emit(ReelsError(message: failure.message, reels: _reels));
        },
        (newReels) {
          _reels.addAll(newReels);

          final hasReachedMax = newReels.length < AppConstants.defaultPageSize;

          emit(
            ReelsLoaded(
              reels: List.from(_reels),
              hasReachedMax: hasReachedMax,
              isLoadingMore: false,
            ),
          );
        },
      );
    }
  }

  Future<void> _onRefreshReels(
    RefreshReelsEvent event,
    Emitter<ReelsState> emit,
  ) async {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;
      emit(ReelsRefreshing(reels: currentState.reels));
    }

    _currentPage = 1;
    _reels.clear();

    final result = await getReels(
      const PaginationParams(
        page: 1,
        limit: AppConstants.defaultPageSize,
        refresh: true,
      ),
    );

    result.fold(
      (failure) {
        emit(ReelsError(message: failure.message, reels: _reels));
      },
      (reels) {
        _reels.clear();
        _reels.addAll(reels);

        final hasReachedMax = reels.length < AppConstants.defaultPageSize;

        emit(
          ReelsLoaded(reels: List.from(_reels), hasReachedMax: hasReachedMax),
        );
      },
    );
  }

  void _onReelViewed(ReelViewedEvent event, Emitter<ReelsState> emit) {
    // Handle reel viewed analytics or state updates
    // This can be used for tracking user engagement
  }

  void _onToggleLike(ToggleLikeEvent event, Emitter<ReelsState> emit) {
    if (state is ReelsLoaded) {
      final currentState = state as ReelsLoaded;

      // Find and update the liked reel
      final updatedReels = currentState.reels.map((reel) {
        if (reel.id == event.reelId) {
          // This would typically involve an API call to update the like status
          // For now, we'll just toggle the local state
          return reel; // In a real app, return updated reel with toggled like status
        }
        return reel;
      }).toList();

      emit(currentState.copyWith(reels: updatedReels));
    }
  }
}
