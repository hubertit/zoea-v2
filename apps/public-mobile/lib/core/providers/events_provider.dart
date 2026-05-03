import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/lacreola_hardcoded_events.dart';
import '../models/event.dart';
import '../services/events_service.dart';

class _CopyWithSentinel {
  const _CopyWithSentinel();
}

const _keepError = _CopyWithSentinel();

final eventsServiceProvider = Provider<EventsService>((ref) {
  return EventsService();
});

final eventsProvider = StateNotifierProvider<EventsNotifier, EventsState>((ref) {
  final eventsService = ref.watch(eventsServiceProvider);
  return EventsNotifier(eventsService);
});

class EventsState {
  final List<Event> events;
  final bool isLoading;
  final String? error;
  final EventsTab currentTab;
  final Map<String, dynamic> filters;

  const EventsState({
    this.events = const [],
    this.isLoading = false,
    this.error,
    this.currentTab = EventsTab.trending,
    this.filters = const {},
  });

  EventsState copyWith({
    List<Event>? events,
    bool? isLoading,
    Object? error = _keepError,
    EventsTab? currentTab,
    Map<String, dynamic>? filters,
  }) {
    return EventsState(
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
      error: identical(error, _keepError) ? this.error : error as String?,
      currentTab: currentTab ?? this.currentTab,
      filters: filters ?? this.filters,
    );
  }
}

enum EventsTab {
  trending,
  nearMe,
  thisWeek,
}

class EventsNotifier extends StateNotifier<EventsState> {
  final EventsService _eventsService;

  EventsNotifier(this._eventsService) : super(const EventsState()) {
    loadTrendingEvents();
  }

  List<Event> _withLaCreola(List<Event> api) {
    if (!kIncludeLaCreolaHardcodedEvents) return api;
    return [...laCreolaHardcodedEvents(), ...api];
  }

  Future<void> loadTrendingEvents() async {
    state = state.copyWith(isLoading: true, error: null, currentTab: EventsTab.trending);
    
    try {
      final response = await _eventsService.getTrendingEvents();
      state = state.copyWith(
        events: _withLaCreola(response.data.events),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadNearbyEvents({
    required double latitude,
    required double longitude,
  }) async {
    state = state.copyWith(isLoading: true, error: null, currentTab: EventsTab.nearMe);
    
    try {
      final response = await _eventsService.getNearbyEvents(
        latitude: latitude,
        longitude: longitude,
      );
      state = state.copyWith(
        events: _withLaCreola(response.data.events),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadThisWeekEvents() async {
    state = state.copyWith(isLoading: true, error: null, currentTab: EventsTab.thisWeek);
    
    try {
      final response = await _eventsService.getThisWeekEvents();
      state = state.copyWith(
        events: _withLaCreola(response.data.events),
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> searchEvents(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _eventsService.searchEvents(query: query);
      final laCreolaMatches =
          filterLaCreolaEventsForSearch(laCreolaHardcodedEvents(), query);
      state = state.copyWith(
        events: [...laCreolaMatches, ...response.data.events],
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setFilters(Map<String, dynamic> filters) {
    state = state.copyWith(filters: filters);
  }

  void clearFilters() {
    state = state.copyWith(filters: {});
  }
}
