import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mono/slot_overview/filter/slot_filter_viewmodel.dart';
import 'package:mono/widgets/outlined_filter_chip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SlotFilterDialog extends StatefulWidget {
  const SlotFilterDialog({Key? key}) : super(key: key);

  @override
  _SlotFilterDialogState createState() => _SlotFilterDialogState();
}

class _SlotFilterDialogState extends State<SlotFilterDialog> {
  final SlotFilterViewModel viewModel = GetIt.I();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return SingleChildScrollView(
            controller: controller,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            GetIt.I.get<AppLocalizations>().slotFilterTitle,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              viewModel.onResetFilter();
                            });
                          },
                          icon: const Icon(Icons.delete_outlined),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.check),
                        ),
                      ],
                    ),
                  ),
                  WeekdayFilterWidget(viewModel: viewModel),
                  TimeFilterWidget(viewModel: viewModel),
                  HideFullSlotsFilterWidget(viewModel: viewModel),
                ],
              ),
            ),
          );
        });
  }
}

class WeekdayFilterWidget extends StatefulWidget {
  final SlotFilterViewModel viewModel;

  const WeekdayFilterWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  State<WeekdayFilterWidget> createState() => _WeekdayFilterWidgetState();
}

class _WeekdayFilterWidgetState extends State<WeekdayFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            GetIt.I.get<AppLocalizations>().slotFilterWeekdayTitle,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Wrap(
          spacing: 8,
          runSpacing: 0,
          children: widget.viewModel.weekdayFilterData.map(
            (filterItem) {
              return OutlinedFilterChip(
                label: filterItem.label,
                selected: filterItem.selected,
                onSelected: (selected) {
                  setState(() {
                    widget.viewModel
                        .onWeekdayFilterSelect(filterItem.weekday, selected);
                  });
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class TimeFilterWidget extends StatefulWidget {
  final SlotFilterViewModel viewModel;

  const TimeFilterWidget({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<TimeFilterWidget> createState() => _TimeFilterWidgetState();
}

class _TimeFilterWidgetState extends State<TimeFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            AppLocalizations.of(context)!.slotFilterTimeTitle,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime:
                        widget.viewModel.timeFilterData.initialMinStartTime,
                  ).then((selectedTime) {
                    if (selectedTime != null) {
                      setState(() {
                        widget.viewModel.onMinStartTimeSelect(selectedTime);
                      });
                    }
                  });
                },
                child: TextField(
                  controller: TextEditingController(
                      text: widget.viewModel.timeFilterData.minStartTimeString),
                  enabled: false,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            widget.viewModel.timeFilterData.minStartTimeActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor,
                      ),
                    ),
                    labelText: AppLocalizations.of(context)!
                        .slotFilterTimeMinStartTime,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                            color: widget
                                    .viewModel.timeFilterData.minStartTimeActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime:
                        widget.viewModel.timeFilterData.initialMaxStartTime,
                  ).then((selectedTime) {
                    if (selectedTime != null) {
                      setState(() {
                        widget.viewModel.onMaxStartTimeSelect(selectedTime);
                      });
                    }
                  });
                },
                child: TextField(
                  controller: TextEditingController(
                      text: widget.viewModel.timeFilterData.maxStartTimeString),
                  enabled: false,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color:
                            widget.viewModel.timeFilterData.maxStartTimeActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor,
                      ),
                    ),
                    labelText: AppLocalizations.of(context)!
                        .slotFilterTimeMaxStartTime,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(
                            color: widget
                                    .viewModel.timeFilterData.maxStartTimeActive
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).disabledColor),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class HideFullSlotsFilterWidget extends StatefulWidget {
  final SlotFilterViewModel viewModel;

  const HideFullSlotsFilterWidget({Key? key, required this.viewModel})
      : super(key: key);

  @override
  State<HideFullSlotsFilterWidget> createState() =>
      _HideFullSlotsFilterWidgetState();
}

class _HideFullSlotsFilterWidgetState extends State<HideFullSlotsFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.slotFilterHideFullSlots,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Checkbox(
            activeColor: Theme.of(context).colorScheme.primary,
            value: widget.viewModel.hideFullFilterData.selected,
            onChanged: (selected) {
              setState(() {
                widget.viewModel.onHideFullSlotsSelect(selected ?? false);
              });
            },
          ),
        ],
      ),
    );
  }
}
