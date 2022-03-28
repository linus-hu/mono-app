import 'package:mono/data/slots/slot.dart';

class SlotLoadingState {
  List<Slot>? slots;
  bool hasError = false;
  bool isLoading = false;

  SlotLoadingState({
    this.slots,
    this.hasError = false,
    this.isLoading = false,
  });

  SlotLoadingState.loading(this.isLoading);

  SlotLoadingState.withData(this.slots);

  SlotLoadingState.withError(this.hasError);

  SlotLoadingState copyWith({
    List<Slot>? slots,
    bool? hasError,
    bool? isLoading,
  }) {
    return SlotLoadingState(
      slots: slots ?? this.slots,
      hasError: hasError ?? this.hasError,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
