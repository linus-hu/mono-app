import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mono/data/slots/slots_repository.dart';
import 'package:mono/data/slots/slot_filter/slot_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mono/utils/date_utils.dart';

class SlotFilterViewModel {
  final _repository = GetIt.I.get<SlotsRepository>();

  late SlotFilterTimeData timeFilterData;
  late SlotFilterHideFullData hideFullFilterData;
  late List<SlotFilterWeekdayData> weekdayFilterData;

  SlotFilterViewModel() {
    _loadFilter();
  }

  onWeekdayFilterSelect(int weekday, bool selected) {
    _repository.setWeekdayFilterActive(weekday, selected);
    _loadFilter();
  }

  onMinStartTimeSelect(TimeOfDay minStartTime) {
    _repository.setMinStartTimeFilter(minStartTime);
    _loadFilter();
  }

  onMaxStartTimeSelect(TimeOfDay maxStartTime) {
    _repository.setMaxStartTimeFilter(maxStartTime);
    _loadFilter();
  }

  onHideFullSlotsSelect(bool selected) {
    _repository.setHideFullSlotsFilter(selected);
    _loadFilter();
  }

  onResetFilter() {
    _repository.resetFilter();
    _loadFilter();
  }

  _loadFilter() {
    final filter = _repository.getSlotFilter();
    timeFilterData = SlotFilterTimeData.fromFilter(filter.whereType<TimeFilter>().first);
    hideFullFilterData = SlotFilterHideFullData.fromFilter(filter.whereType<HideFullSlotsFilter>().first);
    weekdayFilterData = filter
        .whereType<WeekdayFilter>()
        .map((filter) => SlotFilterWeekdayData.fromFilter(filter))
        .toList();
  }
}

class SlotFilterWeekdayData {
  final int weekday;
  final bool selected;
  final String label;

  SlotFilterWeekdayData(
      {required this.weekday, required this.selected, required this.label});

  factory SlotFilterWeekdayData.fromFilter(WeekdayFilter filter) {
    final locale = GetIt.I.get<AppLocalizations>().localeName;
    return SlotFilterWeekdayData(
        weekday: filter.weekday,
        selected: filter.isActive(),
        label:
            DateFormat(null, locale).dateSymbols.WEEKDAYS[filter.weekday % 7]);
  }
}

class SlotFilterTimeData {
  late final String minStartTimeString;
  late final String maxStartTimeString;

  late final TimeOfDay initialMinStartTime;
  late final TimeOfDay initialMaxStartTime;

  final String _none = "-";

  SlotFilterTimeData(TimeOfDay? minTime, TimeOfDay? maxTime) {
    if (minTime != null) {
      minStartTimeString = minTime.formatTime();
    } else {
      minStartTimeString = _none;
    }

    if (maxTime != null) {
      maxStartTimeString = maxTime.formatTime();
    } else {
      maxStartTimeString = _none;
    }

    initialMinStartTime = minTime ?? const TimeOfDay(hour: 10, minute: 0);
    initialMaxStartTime = maxTime ?? const TimeOfDay(hour: 21, minute: 0);
  }

  bool get minStartTimeActive => minStartTimeString != _none;
  bool get maxStartTimeActive => maxStartTimeString != _none;

  factory SlotFilterTimeData.fromFilter(TimeFilter filter) {
    return SlotFilterTimeData(
      filter.getMinTime(),
      filter.getMaxTime()
    );
  }
}

class SlotFilterHideFullData {
  final bool selected;

  SlotFilterHideFullData(this.selected);

  factory SlotFilterHideFullData.fromFilter(HideFullSlotsFilter filter) {
    return SlotFilterHideFullData(filter.isActive());
  }
}