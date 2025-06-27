import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/app_theme.dart';
import 'package:my_tec_listing_module_app/data/dto/centre_dto.dart';
import 'package:my_tec_listing_module_app/domain/entities/grouped_meeting_room_entity.dart';
import 'package:my_tec_listing_module_app/presentation/providers/search_coworking_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/search_meeting_room_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/city_selection_dialog.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/coworking_list_view.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/filter_bottom_sheet.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/meeting_room_list_view.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/room_card.dart';
import 'package:my_tec_listing_module_app/presentation/widgets/wrapped_filters.dart';

enum ViewMode { list, map }

enum SearchMode { meetingRoom, coworking, dayOffice, eventSpace }

class BookingListScreen extends StatefulHookConsumerWidget {
  static const double minSheetChildSize = 0.17;
  static const double midSheetChildSize = 0.6;
  static const double maxSheetChildSize = 1.0;
  const BookingListScreen({super.key});

  @override
  ConsumerState<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends ConsumerState<BookingListScreen> {
  late DraggableScrollableController draggableController;
  late ScrollController listController;

  @override
  void initState() {
    super.initState();
    draggableController = DraggableScrollableController();
    listController = ScrollController();
  }

  @override
  void dispose() {
    draggableController.dispose();
    listController.dispose();
    super.dispose();
  }

  void handleOnTabTabBar(
    CityState currentCity,
    MeetingRoomFilter filterState,
    ValueNotifier<SearchMode> searchMode,
    SearchMode newSearchMode,
  ) async {
    final centres = await ref.read(centresUnderCurrentCityProvider.future);
    if (!context.mounted) return;
    displayFilterBottomSheet(context, currentCity, centres, filterState, searchMode, ref, null);

    final newFilterState = MeetingRoomFilter.defaultSettings().copyWith(
      centres: centres.map((centre) => centre.localizedName?['en'] ?? '').toList(),
    );

    ref.read(meetingRoomFilterStateProvider.notifier).update(newFilterState);

    searchMode.value = newSearchMode;
  }

  @override
  Widget build(BuildContext context) {
    final topTapController = useTabController(initialLength: 4);
    final viewMode = useState(ViewMode.map);
    final isFullScreen = useState(false);
    final searchMode = useState<SearchMode>(SearchMode.meetingRoom);

    final currentCity = ref.watch(currentCityStateProvider);
    final filterState = ref.watch(meetingRoomFilterStateProvider);

    final centresListUnderCurrentCity = ref.watch(centresUnderCurrentCityProvider.future);

    // NOTE: Added to prevent the state from being reset when the list view is minimized.
    if (topTapController.index == 0) {
      ref.watch(searchMeetingRoomStateProvider);
    } else if (topTapController.index == 1) {
      ref.watch(searchCoworkingStateProvider);
    }

    useEffect(() {
      void updateFullScreen() {
        final currentSize = draggableController.size;
        if (currentSize == BookingListScreen.maxSheetChildSize) {
          isFullScreen.value = true;
        } else {
          isFullScreen.value = false;
        }
      }

      void updateViewMode() {
        final currentSize = draggableController.size;
        if (currentSize >= BookingListScreen.midSheetChildSize) {
          viewMode.value = ViewMode.list;
        } else if (currentSize <= BookingListScreen.minSheetChildSize) {
          viewMode.value = ViewMode.map;
        }
      }

      Future.microtask(() => handleOnTabTabBar(currentCity, filterState, searchMode, SearchMode.meetingRoom));

      draggableController.addListener(updateViewMode);
      draggableController.addListener(updateFullScreen);
      return () {
        draggableController.removeListener(updateViewMode);
        draggableController.removeListener(updateFullScreen);
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: kMinInteractiveDimension,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded), onPressed: () => {}),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kMinInteractiveDimension),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xSmall),
            child: TabBar(
              splashFactory: NoSplash.splashFactory,
              onTap: (index) => handleOnTabTabBar(currentCity, filterState, searchMode, SearchMode.values[index]),
              controller: topTapController,
              indicatorWeight: 1,
              isScrollable: true,
              tabs: [
                Tab(text: 'Meeting Room'),
                Tab(text: 'Coworking'),
                Tab(text: 'Day Office'),
                Tab(text: 'Event Space'),
              ],
            ),
          ),
        ),
        title: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final currentCity = ref.watch(currentCityStateProvider);
              return TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CitySelectionDialog(
                      onCitySaved: (String cityName, String cityCode) async {
                        ref.read(currentCityStateProvider.notifier).state = CityState(
                          cityName: cityName,
                          cityCode: cityCode,
                        );

                        final centres = await ref.read(centresUnderCurrentCityProvider.future);

                        ref
                            .read(meetingRoomFilterStateProvider.notifier)
                            .update(
                              MeetingRoomFilter.defaultSettings().copyWith(
                                centres: centres.map((centre) => centre.localizedName?['en'] ?? '').toList(),
                              ),
                            );
                      },
                      currentCity: currentCity,
                    ),
                    barrierDismissible: true,
                    useSafeArea: true,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentCity.cityName),
                    SizedBox(width: AppSpacing.xSmall),
                    Transform.translate(
                      offset: Offset(0, -2),
                      child: Transform.rotate(angle: 90 * 3.14 / 360, child: Icon(Icons.navigation_outlined)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // isFullScreen.value = false;
              if (viewMode.value == ViewMode.list) {
                draggableController.animateTo(
                  BookingListScreen.minSheetChildSize,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                // viewMode.value = ViewMode.map;
              } else {
                draggableController.animateTo(
                  BookingListScreen.maxSheetChildSize,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                // viewMode.value = ViewMode.list;
              }
            },
            icon: viewMode.value == ViewMode.list
                ? const Icon(Icons.map_outlined)
                : const Icon(Icons.format_list_bulleted_rounded),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            minScale: 2.0,
            maxScale: 3.0,
            alignment: Alignment.center,
            child: Image.asset('assets/images/tec_map_sample.png', fit: BoxFit.fitHeight),
          ),
          DraggableScrollableSheet(
            initialChildSize: BookingListScreen.minSheetChildSize,
            controller: draggableController,
            snap: true,
            minChildSize: BookingListScreen.minSheetChildSize,
            maxChildSize: BookingListScreen.maxSheetChildSize,
            snapSizes: [
              BookingListScreen.minSheetChildSize,
              BookingListScreen.midSheetChildSize,
              BookingListScreen.maxSheetChildSize,
            ],
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: isFullScreen.value == false
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(AppBorderRadius.normal),
                          topRight: Radius.circular(AppBorderRadius.normal),
                        )
                      : BorderRadius.zero,
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // Draggable Handle
                    SliverToBoxAdapter(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: isFullScreen.value == false ? 12 : 0,
                        alignment: Alignment.bottomCenter,
                        width: double.infinity,
                        // height: 12,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppBorderRadius.normal),
                            topRight: Radius.circular(AppBorderRadius.normal),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 64.0,
                            height: 4.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.outlineVariant,

                              // color: Theme.of(context).colorScheme.error,
                              borderRadius: BorderRadius.circular(AppBorderRadius.small),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // : SliverToBoxAdapter(child: SizedBox.shrink()),
                    // Filter Section
                    if (searchMode.value != SearchMode.eventSpace)
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          behavior: isFullScreen.value == true ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
                          onTapDown: (details) {
                            debugPrint('tap down');
                          },
                          onPanDown: (details) {
                            debugPrint('pan down');
                          },
                          onVerticalDragUpdate: (details) {
                            debugPrint('vertical drag update');
                          },
                          child: Column(
                            children: [
                              SizedBox(height: AppSpacing.medium),
                              Consumer(
                                builder: (context, ref, child) {
                                  return FutureBuilder(
                                    future: centresListUnderCurrentCity,
                                    builder: (context, asyncSnapshot) {
                                      return WrappedFilters(
                                        onFilterTapped: (String? tappedFormFieldKey) {
                                          displayFilterBottomSheet(
                                            context,
                                            currentCity,
                                            asyncSnapshot.data ?? [],
                                            filterState,
                                            searchMode,
                                            ref,
                                            tappedFormFieldKey,
                                          );
                                        },
                                        centresInCurrentCity: asyncSnapshot.data ?? [],
                                        // NOTE: searchmode와 filterstate 연동이 애매하다.
                                        filterState: filterState,
                                        searchMode: searchMode.value,
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: AppSpacing.xSmall),
                            ],
                          ),
                        ),
                      ),
                    // List Content with SliverLayoutBuilder
                    SliverLayoutBuilder(
                      builder: (context, constraints) {
                        // Use remaining paint extent for available height
                        double availableHeight = constraints.remainingPaintExtent;

                        Widget content;
                        // print(searchMode.value);
                        switch (searchMode.value) {
                          case SearchMode.meetingRoom:
                            content = Consumer(
                              builder: (context, ref, child) {
                                final searchMeetingRoomState = ref.watch(searchMeetingRoomStateProvider);

                                ref.listen(searchMeetingRoomStateProvider, (previous, next) {
                                  if (next.hasValue && next.value != previous?.value) {
                                    // Calculate total count of meeting rooms
                                    final totalCount =
                                        next.valueOrNull?.fold<int>(
                                          0,
                                          (count, GroupedMeetingRoomEntity group) => count + group.meetingRooms.length,
                                        ) ??
                                        0;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Found $totalCount meeting room${totalCount == 1 ? '' : 's'}'),
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                      ),
                                    );
                                  }
                                });

                                return searchMeetingRoomState.when(
                                  skipLoadingOnRefresh: false,
                                  skipLoadingOnReload: false,
                                  data: (List<GroupedMeetingRoomEntity> data) {
                                    if (data.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No meeting rooms found',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      );
                                    }
                                    return MeetingRoomListView(
                                      onRefresh: () async {
                                        ref.invalidate(searchMeetingRoomStateProvider);
                                      },
                                      groupedMeetingRoomEntityList: data,
                                    );
                                  },
                                  error: (error, stackTrace) => Center(
                                    child: Text(
                                      'Error loading meeting rooms: $error',
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                );
                              },
                            );
                            break;
                          case SearchMode.coworking:
                            content = Consumer(
                              builder: (context, ref, child) {
                                final searchCoworkingState = ref.watch(searchCoworkingStateProvider);

                                return searchCoworkingState.when(
                                  data: (data) =>
                                      CoworkingListView(bookingCoworkingState: data, searchFilter: filterState),
                                  error: (error, stackTrace) =>
                                      Text('Error: $error, $stackTrace', style: Theme.of(context).textTheme.bodyMedium),
                                  loading: () => CircularProgressIndicator(),
                                ); // 새로운 위젯
                              },
                            );
                            break;
                          case SearchMode.dayOffice:
                            content = Consumer(
                              builder: (context, ref, child) {
                                final bookingCoworkingState = ref.watch(searchCoworkingStateProvider);
                                return Placeholder();
                                // return DayOfficeListView(bookingCoworkingState: bookingCoworkingState); // 새로운 위젯
                              },
                            );
                            break;
                          case SearchMode.eventSpace:
                            content = EventSpaceListView(); // 새로운 위젯
                            break;
                        }

                        return SliverToBoxAdapter(
                          child: SizedBox(
                            height: availableHeight > 100 ? availableHeight : 300, // Fallback height
                            child: draggableController.size > BookingListScreen.minSheetChildSize
                                ? content
                                : SizedBox.shrink(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> displayFilterBottomSheet(
    BuildContext context,
    CityState currentCity,
    List<CentreDto> centresInCurrentCity,
    MeetingRoomFilter filterState,
    ValueNotifier<SearchMode> searchMode,
    WidgetRef ref,
    String? tappedFormField,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      context: context,
      builder: (context) => SafeArea(
        child: FilterBottomSheet(
          currentCity: currentCity,
          centres: centresInCurrentCity,
          filterState: filterState,
          searchMode: searchMode.value,
          onApply: (filterState) => ref.read(meetingRoomFilterStateProvider.notifier).update(filterState),
          onReset: (filterState) => ref.read(meetingRoomFilterStateProvider.notifier).reset(),
          tappedFormField: tappedFormField,
        ),
      ),
    );
  }
}

class EventSpaceListView extends StatelessWidget {
  const EventSpaceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
