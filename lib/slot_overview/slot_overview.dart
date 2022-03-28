import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mono/data/slots/slot.dart';
import 'package:mono/slot_overview/booking/slot_booking_dialog.dart';
import 'package:mono/slot_overview/booking/slot_booking_viewmodel.dart';
import 'package:mono/slot_overview/filter/slot_filter_dialog.dart';
import 'package:mono/slot_overview/slot_overview_viewmodel.dart';

class SlotOverview extends StatefulWidget {
  const SlotOverview({Key? key}) : super(key: key);

  @override
  _SlotOverviewState createState() => _SlotOverviewState();
}

class _SlotOverviewState extends State<SlotOverview> {
  final SlotOverviewViewModel _viewModel = GetIt.I();

  @override
  void initState() {
    super.initState();
    _viewModel.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.slotOverviewTitle),
        actions: [
          Badge(
            showBadge: _viewModel.hasActiveFilter,
            badgeColor: Theme.of(context).colorScheme.primary,
            position: BadgePosition.topEnd(top: 14, end: 10),
            child: IconButton(
              onPressed: () {
                onFilter();
              },
              icon: const Icon(Icons.filter_list),
            ),
          ),
          IconButton(
            onPressed: () {
              onRefresh();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: StreamBuilder<SlotOverviewStateData>(
        stream: _viewModel.stateStream,
        builder: (context, stateSnapshot) {
          if (stateSnapshot.hasData) {
            final _state = stateSnapshot.data!;
            return Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Visibility(
                  visible: (_state.hasData && !_state.hasError),
                  child: ListView.builder(
                    itemCount: _state.overviewData?.months.length,
                    itemBuilder: (context, index) {
                      return MonthItem(
                          monthData: _state.overviewData!.months[index]);
                    },
                    shrinkWrap: true,
                  ),
                ),
                Visibility(
                  visible: _state.hasError,
                  child: _error(),
                ),
                Visibility(
                  visible: _state.isLoading,
                  child: _loading(),
                ),
              ],
            );
          } else if (stateSnapshot.hasError) {
            return _error();
          } else {
            return _loading();
          }
        },
      ),
    );
  }

  Widget _error() {
    return Center(
        child: Text(GetIt.I.get<AppLocalizations>().slotLoadingError));
  }

  Widget _loading() {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.black26,
      child: const Center(
        child: SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void onRefresh() {
    setState(() {
      _viewModel.fetchData();
    });
  }

  void onFilter() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) {
          return const SlotFilterDialog();
        }).then((value) => onRefresh());
  }
}

class MonthItem extends StatelessWidget {
  final SlotOverviewMonth monthData;

  const MonthItem({Key? key, required this.monthData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 16.0, bottom: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Divider(
                  color: Theme.of(context).disabledColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  monthData.title.toUpperCase(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).disabledColor,
                      ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: monthData.days.length,
            itemBuilder: (context, index) {
              return DayItem(
                dayData: monthData.days[index],
                isExpanded: index == 0 && monthData.isFirstMonth,
              );
            })
      ],
    );
  }
}

class DayItem extends StatefulWidget {
  final SlotOverviewDay dayData;
  final bool isExpanded;

  const DayItem({Key? key, required this.dayData, required this.isExpanded})
      : super(key: key);

  @override
  State<DayItem> createState() => _DayItemState();
}

class _DayItemState extends State<DayItem> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey(widget.dayData.title),
          initiallyExpanded: widget.isExpanded,
          title: Text(widget.dayData.title),
          children: [
            ListView.separated(
              key: PageStorageKey(widget.dayData.title),
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.dayData.items.length,
              itemBuilder: (context, index) {
                return SlotItem(slotItem: widget.dayData.items[index]);
              },
              separatorBuilder: (BuildContext context, int index) => Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Divider(
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlotItem extends StatelessWidget {
  final SlotOverviewItem slotItem;

  final AppLocalizations _local = GetIt.I();
  final SlotOverviewViewModel _viewModel = GetIt.I();

  SlotItem({Key? key, required this.slotItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CircleAvatar(
            child: const Icon(Icons.group),
            foregroundColor: Theme.of(context).canvasColor,
            backgroundColor:
                _getIconBackgroundColor(context, slotItem.bookableState),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(slotItem.duration,
                style: _getTextStyle(
                    context,
                    Theme.of(context).textTheme.subtitle1,
                    slotItem.bookableState)),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(slotItem.bookableSlots,
                  style: _getTextStyle(
                      context,
                      Theme.of(context).textTheme.caption,
                      slotItem.bookableState)),
            )
          ],
        ),
        Visibility(
          visible: slotItem.bookableState == BookableState.bookable,
          child: Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: OutlinedButton(
                  onPressed: () => _onBookingButtonClicked(context),
                  child: Text(_local.slotItemBookingButton),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: slotItem.bookableState == BookableState.booked,
          child: Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: OutlinedButton(
                  onPressed: null,
                  child: Text(
                    _local.slotItemBookedLabel,
                    style: Theme.of(context)
                        .textTheme
                        .button
                        ?.copyWith(color: Colors.green),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Color? _getIconBackgroundColor(
      BuildContext context, BookableState bookableState) {
    switch (bookableState) {
      case BookableState.booked:
        return Colors.green;
      case BookableState.bookable:
        return Theme.of(context).colorScheme.primary;
      default:
        return Theme.of(context).disabledColor;
    }
  }

  TextStyle? _getTextStyle(
      BuildContext context, TextStyle? baseStyle, BookableState bookableState) {
    final style = baseStyle ?? const TextStyle();

    switch (bookableState) {
      case BookableState.booked:
      case BookableState.bookable:
        return baseStyle;
      default:
        return style.copyWith(color: Theme.of(context).disabledColor);
    }
  }

  void _onBookingButtonClicked(BuildContext context) {
    if (_viewModel.hasCompleteAccountData) {
      _showBookingDialog(context);
    } else {
      _showMissingAccountDataDialog(context);
    }
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SlotBookingDialog(
          viewModel: SlotBookingViewModel(slotItem.slotId),
        );
      },
    );
  }

  void _showMissingAccountDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_local.slotBookingAccountErrorDialogTitle),
          content: Text(_local.slotBookingAccountErrorDialogDescription),
          actions: [
            TextButton(
              child: Text(_local.slotBookingAccountErrorDialogButtonOk),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }
}
