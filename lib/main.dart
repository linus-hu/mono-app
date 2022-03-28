import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/account/account_form.dart';
import 'package:mono/account/account_form_viewmodel.dart';
import 'package:mono/data/account/account_data.dart';
import 'package:mono/data/account/account_dao.dart';
import 'package:mono/data/slots/booked_slots_dao.dart';
import 'package:mono/data/slots/slot.dart';
import 'package:mono/data/slots/slots_repository.dart';
import 'package:mono/slot_overview/slot_overview.dart';
import 'package:mono/slot_overview/slot_overview_viewmodel.dart';
import 'package:mono/slot_overview/filter/slot_filter_viewmodel.dart';
import 'package:mono/main_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDi().then((_) {
    runApp(MyApp());
  });
}

Future setupDi() async {
  await setupHive();

  GetIt.I
    ..registerSingleton(await Hive.openBox("mono"))
    ..registerSingleton(await SharedPreferences.getInstance())
    ..registerSingleton(AccountDao())
    ..registerSingleton(BookedSlotsDao())
    ..registerSingleton(SlotsRepository())
    ..registerLazySingleton(() => MainViewModel())
    ..registerLazySingleton(() => SlotFilterViewModel())
    ..registerLazySingleton(() => AccountFormViewModel())
    ..registerLazySingleton(() => SlotOverviewViewModel());
}

Future setupHive() async {
  await Hive.initFlutter();

  Hive
    ..registerAdapter(SlotAdapter())
    ..registerAdapter(DateItemAdapter())
    ..registerAdapter(BookableStateAdapter())
    ..registerAdapter(AccountDataAdapter());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  final MainViewModel viewModel = GetIt.I();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _screens = [
    const SlotOverview(),
    AccountForm(),
  ];

  late int _selectedBottomNavigationBarIndex;

  @override
  void initState() {
    _selectedBottomNavigationBarIndex = widget.viewModel.initialBottomTabIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepOrange,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      dark: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'Mono',
        theme: theme.copyWith(
          chipTheme: _getOutlinedChipTheme(theme),
          colorScheme:
              theme.colorScheme.copyWith(secondary: Colors.deepOrange),
        ),
        darkTheme: darkTheme.copyWith(
          chipTheme: _getOutlinedChipTheme(darkTheme),
          colorScheme:
              darkTheme.colorScheme.copyWith(secondary: Colors.deepOrange),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          if (!GetIt.I.isRegistered<AppLocalizations>()) {
            GetIt.I.registerSingleton<AppLocalizations>(
                AppLocalizations.of(context)!);
          }
          return child!;
        },
        home: Scaffold(
          body: _screens[_selectedBottomNavigationBarIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: "Slots",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Account",
              ),
            ],
            currentIndex: _selectedBottomNavigationBarIndex,
            onTap: (index) {
              setState(() {
                _selectedBottomNavigationBarIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  ChipThemeData _getOutlinedChipTheme(ThemeData themeData) {
    return themeData.chipTheme.copyWith(
      backgroundColor: Colors.transparent,
      selectedColor: Colors.transparent,
      labelStyle: TextStyle(
        color: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return themeData.colorScheme.primary;
            } else {
              return themeData.textTheme.bodyText1!.color!;
            }
          },
        ),
      ),
      side: MaterialStateBorderSide.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return BorderSide(color: themeData.colorScheme.primary);
          } else {
            return BorderSide(color: themeData.textTheme.bodyText1!.color!);
          }
        },
      ),
    );
  }
}
