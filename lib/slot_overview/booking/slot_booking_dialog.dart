import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:mono/data/slots/booking.dart';
import 'package:mono/slot_overview/booking/slot_booking_viewmodel.dart';

class SlotBookingDialog extends StatefulWidget {
  final SlotBookingViewModel viewModel;

  const SlotBookingDialog({Key? key, required this.viewModel})
      : super(key: key);

  @override
  State<SlotBookingDialog> createState() => _SlotBookingDialogState();
}

class _SlotBookingDialogState extends State<SlotBookingDialog> {
  Future<BookingResponse>? bookingResponse;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookingResponse>(
        future: bookingResponse,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none) {
            return _getBookingAlertDialog();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return _getLoadingAlertDialog();
          } else if (snapshot.hasData && snapshot.data!.isSuccessful()) {
            return _getSuccessAlertDialog();
          } else {
            return _getErrorAlertDialog();
          }
        });
  }

  AlertDialog _getBookingAlertDialog() {
    return AlertDialog(
      title: Text(widget.viewModel.getDateString()),
      content: Text(GetIt.I.get<AppLocalizations>().slotBookingDescription),
      actions: [
        TextButton(
          child: Text(GetIt.I.get<AppLocalizations>().slotBookingButtonCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              bookingResponse = widget.viewModel.onExecuteBookingClicked();
            });
          },
          child: Text(GetIt.I.get<AppLocalizations>().slotBookingButtonBook),
        ),
      ],
    );
  }

  AlertDialog _getLoadingAlertDialog() {
    return AlertDialog(
      title: Text(widget.viewModel.getDateString()),
      content: const Center(
        heightFactor: 1,
        child: CircularProgressIndicator(),
      ),
      actions: const [SizedBox.shrink()],
    );
  }

  AlertDialog _getSuccessAlertDialog() {
    return AlertDialog(
      title: Text(widget.viewModel.getDateString()),
      content: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.check_circle_outline,
              color: Colors.green,
            ),
          ),
          Expanded(
            child: Text(GetIt.I.get<AppLocalizations>().slotBookingSuccess),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(GetIt.I.get<AppLocalizations>().slotBookingButtonAddToCalendar),
          onPressed: ()
          {
            Navigator.of(context).pop();
            widget.viewModel.onAddToCalendarClicked();
          },
        ),
        TextButton(
          child: Text(GetIt.I.get<AppLocalizations>().slotBookingButtonOk),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  AlertDialog _getErrorAlertDialog() {
    return AlertDialog(
      title: Text(widget.viewModel.getDateString()),
      content: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.warning_amber_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          Expanded(
            child: Text(GetIt.I.get<AppLocalizations>().slotBookingError),
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(GetIt.I.get<AppLocalizations>().slotBookingButtonCancel),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              bookingResponse = widget.viewModel.onExecuteBookingClicked();
            });
          },
          child: Text(GetIt.I.get<AppLocalizations>().slotBookingButtonTryAgain),
        ),
      ],
    );
  }
}
