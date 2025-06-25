import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_tec_listing_module_app/presentation/providers/search_coworking_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/search_meeting_room_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/current_city_state.dart';
import 'package:my_tec_listing_module_app/presentation/providers/meeting_room_filter_state.dart';
import 'package:my_tec_listing_module_app/widgets/city_selection_dialog.dart';
import 'package:my_tec_listing_module_app/widgets/coworking_list_view.dart';
import 'package:my_tec_listing_module_app/widgets/room_card.dart';
import 'package:my_tec_listing_module_app/widgets/wrapped_filters.dart';

enum ViewMode { list, map }

enum SearchMode { meetingRoom, coworking, dayOffice, eventSpace }

class BookingListScreen extends StatefulHookConsumerWidget {
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
    // TODO: In future, we may need to have more
    // await ref.read(centreListStateProvider.future);
    // final centres = await ref.read(centreListStateProvider.notifier).getCentresByCity(currentCity.cityCode);
    final centres = await ref.read(centresUnderCurrentCityProvider.future);

    // ref.read(meetingRoomFilterStateProvider.notifier).reset();

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

    useEffect(() {
      void updateFullScreen() {
        final currentSize = draggableController.size;
        if (currentSize == 1.0) {
          isFullScreen.value = true;
        } else {
          isFullScreen.value = false;
        }
      }

      void updateViewMode() {
        final currentSize = draggableController.size;
        if (currentSize >= 0.5) {
          viewMode.value = ViewMode.list;
        } else if (currentSize <= 0.2) {
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
          // padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TabBar(
              dragStartBehavior: DragStartBehavior.down,
              // dividerHeight: 0,
              dividerHeight: 0,
              textScaler: TextScaler.linear(1.0),
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface, width: 1.0)),
                shape: BoxShape.rectangle,
                // color: Theme.of(context).colorScheme.primary,
                // borderRadius: BorderRadius.circular(16.0),
              ),
              onTap: (index) => handleOnTabTabBar(currentCity, filterState, searchMode, SearchMode.values[index]),
              controller: topTapController,
              // padding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal: 12.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              // labelPadding: EdgeInsets.zer,

              // indicatorPadding: EdgeInsets.zero,
              indicatorWeight: 1,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.0,
              ),
              dividerColor: Colors.transparent,
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
                style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onSurface),
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
                        // print('currentCity: ${ref.read(currentCityStateProvider).cityCode}');

                        // await ref.read(centreListStateProvider.future);
                        // final centres = await ref
                        //     .read(centreListStateProvider.notifier)
                        //     .getCentresByCity(currentCity.cityCode);

                        // // ref.read(meetingRoomFilterStateProvider.notifier).reset();

                        // final newFilterState = MeetingRoomFilter.defaultSettings().copyWith(
                        //   centres: centres.map((centre) => centre.localizedName?['en'] ?? '').toList(),
                        // );

                        // ref.read(meetingRoomFilterStateProvider.notifier).update(newFilterState);
                      },
                      currentCity: currentCity,
                    ),
                    barrierDismissible: false,
                    useSafeArea: true,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(currentCity.cityName),
                    SizedBox(width: 8),
                    Transform.rotate(angle: 90 * 3.14 / 360, child: Icon(Icons.navigation_outlined)),
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
                  0.2,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );

                // viewMode.value = ViewMode.map;
              } else {
                draggableController.animateTo(
                  1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
                // viewMode.value = ViewMode.list;
              }
            },
            icon: viewMode.value == ViewMode.list ? const Icon(Icons.map) : const Icon(Icons.list),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(20.0),
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset('assets/images/tec_map_sample.png', fit: BoxFit.cover),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            controller: draggableController,
            snap: true,
            // expand: false,
            minChildSize: 0.2,
            maxChildSize: 1.0,
            snapSizes: [0.2, 0.5, 1.0],
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: isFullScreen.value == false
                      ? const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
                      : BorderRadius.zero,
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    // Draggable Handle
                    isFullScreen.value == false
                        ? SliverToBoxAdapter(
                            child: Container(
                              width: double.infinity,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0),
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 48.0,
                                  height: 4.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SliverToBoxAdapter(child: SizedBox.shrink()),
                    // Filter Section
                    if (searchMode.value != SearchMode.eventSpace)
                      SliverToBoxAdapter(
                        child: GestureDetector(
                          behavior: isFullScreen.value == true ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
                          onTapDown: (details) {
                            print('tap down');
                          },
                          onTapUp: (details) {
                            print('tap up');
                          },
                          onPanDown: (details) {
                            print('pan down');
                          },
                          onPanUpdate: (details) {
                            print('pan update');
                          },
                          onVerticalDragUpdate: (details) {
                            print('vertical drag update');
                          },
                          onVerticalDragDown: (details) {
                            print('vertical drag down');
                          },
                          onVerticalDragEnd: (details) {
                            print('vertical drag end');
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 16),
                              Consumer(
                                builder: (context, ref, child) {
                                  return FutureBuilder(
                                    future: centresListUnderCurrentCity,
                                    builder: (context, asyncSnapshot) {
                                      return WrappedFilters(
                                        centresInCurrentCity: asyncSnapshot.data ?? [],
                                        // NOTE: searchmode와 filterstate 연동이 애매하다.
                                        filterState: filterState,
                                        searchMode: searchMode.value,
                                        onResetFilter: (filterState) {
                                          ref.read(meetingRoomFilterStateProvider.notifier).reset();
                                        },
                                        onApplyFilter: (filterState) {
                                          ref.read(meetingRoomFilterStateProvider.notifier).update(filterState);
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 8),
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

                                return searchMeetingRoomState.when(
                                  data: (data) {
                                    if (data.meetingRooms.isEmpty) {
                                      return Center(
                                        child: Text(
                                          'No meeting rooms found',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      // controller: scrollController,
                                      itemCount: data.meetingRooms.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return MeetingRoomCard(meetingRoom: data.meetingRooms[index]);
                                      },
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
                            child: draggableController.size > 0.2 ? content : SizedBox.shrink(),
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
}

class EventSpaceListView extends StatelessWidget {
  const EventSpaceListView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
