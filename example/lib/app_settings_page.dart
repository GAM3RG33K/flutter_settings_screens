import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SettingsScreen(
        title: "Application Settings",
        children: [
          SettingsTileGroup(
            title: 'General Settings',
            children: <Widget>[
              CheckboxSettingsTile(
                settingKey: 'key-check-box',
                title: 'This is a simple Checkbox',
              ),
              SwitchSettingsTile(
                settingKey: 'key-switch',
                title: 'This is a Switch',
              ),
              SimpleSettingsTile(
                title: 'Advanced',
                subtitle: 'More, advanced settings.',
                screen: SettingsScreen(
                  title: "Same Settings as Above but in full screen",
                  children: <Widget>[
                    CheckboxSettingsTile(
                      settingKey: 'key-check-box',
                      title: 'Sub menu option',
                    ),
                    SwitchSettingsTile(
                      settingKey: 'key-switch',
                      title: 'This is a Switch',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Group title',
            children: [
              CheckboxSettingsTile(
                settingKey: 'key-check-box-2',
                title: 'This is a simple Checkbox 2',
              ),
              CheckboxSettingsTile(
                settingKey: 'key-check-box-3',
                title: 'This is a simple Checkbox 3',
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Multiple choice settings',
            children: <Widget>[
              RadioSettingsTile<double>(
                title: 'Preferred Ratio (Radio)',
                settingKey: 'key-golden-ratio',
                values: <double, String>{
                  1.0: 'Simple',
                  1.5: 'Normal',
                  2.0: 'Little Special',
                  2.5: 'Special',
                  3.0: 'Extra Special',
                  3.5: 'Bizzar',
                  4.0: 'Horrific',
                },
                selected: 2.0,
              ),
              DropDownSettingsTile<double>(
                title: 'Preferred Ratio (DropDown)',
                settingKey: 'key-golden-ratio',
                values: <double, String>{
                  1.0: 'Simple',
                  1.5: 'Normal',
                  2.0: 'Little Special',
                  2.5: 'Special',
                  3.0: 'Extra Special',
                  3.5: 'Bizzar',
                  4.0: 'Horrific',
                },
                selected: 2.5,
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Other settings',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Golden Ratio(Slider)',
                defaultValue: 3.5,
                min: 1,
                max: 4,
                step: 0.5,
                settingKey: 'key-golden-ratio',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
