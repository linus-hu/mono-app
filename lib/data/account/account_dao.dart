import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/data/account/account_data.dart';

class AccountDao {
  final Box _box = GetIt.I();
  final String _boxKeyAccount = "account";

  AccountData fetchAccountData() {
    return _box.get(_boxKeyAccount, defaultValue: AccountData());
  }

  Future saveAccountData(AccountData accountData) {
    if (accountData.hasAllData()) {
      return _box.put(_boxKeyAccount, accountData);
    } else {
      return Future.error("Account data not complete");
    }
  }

  Future deleteAccountData() {
    return _box.delete(_boxKeyAccount);
  }
}
