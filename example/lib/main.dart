import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'app_settings_page.dart';
import 'cache_provider.dart';

ValueNotifier<Color> accentColor;

void main() {
  initSettings().then((_) {
    runApp(MyApp());
  });
}

Future<void> initSettings() async {
  await Settings.init(
    cacheProvider: _isUsingHive ? HiveCache() : SharePreferenceCache(),
  );
  accentColor = ValueNotifier(Colors.blueAccent);
}

bool _isDarkTheme = true;
bool _isUsingHive = true;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Flutter Demo Home Page');
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: accentColor,
      builder: (_, color, __) => MaterialApp(
        title: 'App Settings Demo',
        theme: _isDarkTheme
            ? ThemeData.dark().copyWith(accentColor: color)
            : ThemeData.light().copyWith(accentColor: color),
        home: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                _buildThemeSwitch(context),
                _buildPreferenceSwitch(context),
                SizedBox(
                  height: 50.0,
                ),
                AppBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Shared Pref'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: _isUsingHive,
            onChanged: (newVal) {
              if (kIsWeb) {
                return;
              }
              _isUsingHive = newVal;
              setState(() {
                initSettings();
              });
            }),
        Text('Hive Storage'),
      ],
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Light Theme'),
        Switch(
            activeColor: Theme.of(context).accentColor,
            value: _isDarkTheme,
            onChanged: (newVal) {
              _isDarkTheme = newVal;
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildClearCacheButton(context),
        SizedBox(
          height: 25.0,
        ),
        ElevatedButton(
          onPressed: () {
            openAppSettings(context);
          },
          child: Text('Start Demo'),
        ),
      ],
    );
  }

  void openAppSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AppSettings(),
    ));
  }

  Widget _buildClearCacheButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Settings.clearCache();
        showSnackBar(
          context,
          'Cache cleared for selected cache.',
        );
      },
      child: Text('Clear selected Cache'),
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ),
  );
}
