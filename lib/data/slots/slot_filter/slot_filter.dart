import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mono/data/slots/slot.dart';
import 'package:mono/utils/date_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SlotFilter {
  bool _isActive = false;

  final SharedPreferences _preferences = GetIt.I.get<SharedPreferences>();

  SlotFilter() {
    _loadState();
  }

  bool applyFilter(Slot slot);

  bool isActive() => _isActive;

  setActive(bool active) {
    _isActive = active;
    _saveState();
  }

  reset();

  _loadState();

  _saveState();
}

abstract class SlotOrFilter extends SlotFilter {}

abstract class SlotAndFilter extends SlotFilter {}

class WeekdayFilter extends SlotOrFilter {
  final int weekday;
  late final String _preferencesKey = "slot_filter_weekday_$weekday";

  WeekdayFilter(this.weekday);

  @override
  bool applyFilter(Slot slot) {
    return _isActive && slot.getStartDate().weekday == weekday;
  }

  @override
  reset() {
    setActive(false);
  }

  @override
  _loadState() {
    _isActive = _preferences.getBool(_preferencesKey) ?? false;
  }

  @override
  _saveState() async {
    _preferences.setBool(_preferencesKey, _isActive);
  }

  factory WeekdayFilter.monday() => WeekdayFilter(DateTime.monday);

  factory WeekdayFilter.tuesday() => WeekdayFilter(DateTime.tuesday);

  factory WeekdayFilter.wednesday() => WeekdayFilter(DateTime.wednesday);

  factory WeekdayFilter.thursday() => WeekdayFilter(DateTime.thursday);

  factory WeekdayFilter.friday() => WeekdayFilter(DateTime.friday);

  factory WeekdayFilter.saturday() => WeekdayFilter(DateTime.saturday);

  factory WeekdayFilter.sunday() => WeekdayFilter(DateTime.sunday);
}

class TimeFilter extends SlotAndFilter {
  final String _preferencesKeyMinTime = "slot_filter_time_min";
  final String _preferencesKeyMaxTime = "slot_filter_time_max";

  TimeOfDay? _minTime;
  TimeOfDay? _maxTime;

  setMinTime(TimeOfDay minTime) {
    _minTime = minTime;
    setActive(true);
  }

  setMaxTime(TimeOfDay maxTime) {
    _maxTime = maxTime;
    setActive(true);
  }

  TimeOfDay? getMinTime() => _minTime;

  TimeOfDay? getMaxTime() => _maxTime;

  @override
  bool applyFilter(Slot slot) {
    return _isActive &&
        (_minTime == null ||
            TimeOfDay.fromDateTime(slot.getStartDate())
                .afterOrEqual(_minTime!)) &&
        (_maxTime == null ||
            TimeOfDay.fromDateTime(slot.getStartDate())
                .beforeOrEqual(_maxTime!));
  }

  @override
  reset() {
    _minTime = null;
    _maxTime = null;
    setActive(false);
  }

  @override
  _loadState() {
    final prefMinTimeString = _preferences.getString(_preferencesKeyMinTime);
    final prefMaxTimeString = _preferences.getString(_preferencesKeyMaxTime);

    if (prefMinTimeString != null) {
      setMinTime(TimeOfDay.fromDateTime(DateTime.parse(prefMinTimeString)));
    }

    if (prefMaxTimeString != null) {
      setMaxTime(TimeOfDay.fromDateTime(DateTime.parse(prefMaxTimeString)));
    }
  }

  @override
  _saveState() {
    if (_minTime != null) {
      _preferences.setString(_preferencesKeyMinTime,
          DateTime.now().applyTimeOfDay(_minTime!).toIso8601String());
    } else {
      _preferences.remove(_preferencesKeyMinTime);
    }

    if (_maxTime != null) {
      _preferences.setString(_preferencesKeyMaxTime,
          DateTime.now().applyTimeOfDay(_maxTime!).toIso8601String());
    } else {
      _preferences.remove(_preferencesKeyMaxTime);
    }
  }
}

class HideFullSlotsFilter extends SlotAndFilter {
  late final String _preferencesKey = "slot_filter_hide_full";

  @override
  bool applyFilter(Slot slot) {
    return _isActive && slot.state == BookableState.bookable;
  }

  @override
  reset() {
    setActive(false);
  }

  @override
  _loadState() {
    _isActive = _preferences.getBool(_preferencesKey) ?? false;
  }

  @override
  _saveState() async {
    _preferences.setBool(_preferencesKey, _isActive);
  }
}
