import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_settings_screens_example/app_settings_page.dart';
import 'package:flutter_settings_screens_example/cache_provider.dart';

void main() {
  initSettings();
  runApp(MyApp());
}

void initSettings() {
  // use this cache for settings based shared preferences
  SharePreferenceCache spCache = SharePreferenceCache();

  // use this cache for settings based Hive
  HiveCache hCache = HiveCache();

  Settings.init(_isUsingHive ? hCache : spCache);
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
    return MaterialApp(
      title: 'App Settings Demo',
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
            child: Column(
              children: <Widget>[
                _buildThemeSwitch(context),
                _buildPreferenceSwitch(context),
                AppBody(),
              ],
            )),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Light Theme'),
        Switch(
            value: _isDarkTheme,
            onChanged: (newVal) {
              _isDarkTheme = newVal;
              setState(() {});
            }),
        Text('Dark Theme'),
      ],
    );
  }

  Widget _buildPreferenceSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Shared Pref'),
        Switch(
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
}

class AppBody extends StatefulWidget {
  @override
  _AppBodyState createState() => _AppBodyState();
}

class _AppBodyState extends State<AppBody> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text('open settings'),
      onPressed: () {
        openAppSettings(context);
      },
    );
  }

  void openAppSettings(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AppSettings(),
    ));
  }
}
