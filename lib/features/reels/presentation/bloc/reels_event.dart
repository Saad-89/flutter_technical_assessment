import 'package:equatable/equatable.dart';

abstract class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class LoadReelsEvent extends ReelsEvent {
  final bool refresh;

  const LoadReelsEvent({this.refresh = false});

  @override
  List<Object> get props => [refresh];
}

class LoadMoreReelsEvent extends ReelsEvent {
  const LoadMoreReelsEvent();
}

class RefreshReelsEvent extends ReelsEvent {
  const RefreshReelsEvent();
}

class ReelViewedEvent extends ReelsEvent {
  final int reelId;

  const ReelViewedEvent({required this.reelId});

  @override
  List<Object> get props => [reelId];
}

class ToggleLikeEvent extends ReelsEvent {
  final int reelId;

  const ToggleLikeEvent({required this.reelId});

  @override
  List<Object> get props => [reelId];
}
