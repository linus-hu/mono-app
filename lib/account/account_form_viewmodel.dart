import 'package:get_it/get_it.dart';
import 'package:mono/data/account/account_data.dart';
import 'package:mono/data/account/account_dao.dart';

class AccountFormViewModel {
  final _repository = GetIt.I.get<AccountDao>();

  AccountData getAccountData() {
    return _repository.fetchAccountData();
  }

  Future setAccountData(AccountData accountData) {
    return _repository.saveAccountData(accountData);
  }

  Future deleteAccountData() {
    return _repository.deleteAccountData();
  }

  AccountFormState getFormState() {
    if (getAccountData().hasAnyData()) {
      return AccountFormState.locked;
    } else {
      return AccountFormState.edit;
    }
  }

  bool hasAnyData() {
    return getAccountData().hasAnyData();
  }
}

enum AccountFormState {
  edit, locked
}