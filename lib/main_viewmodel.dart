import 'package:get_it/get_it.dart';
import 'package:mono/data/account/account_dao.dart';

class MainViewModel {
  final _accountRepository = GetIt.I.get<AccountDao>();

  late int initialBottomTabIndex;

  MainViewModel() {
    if (_accountRepository.fetchAccountData().hasAllData()) {
      initialBottomTabIndex = 0;
    } else {
      initialBottomTabIndex = 1;
    }
  }
}