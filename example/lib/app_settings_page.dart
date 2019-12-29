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
            title: 'Single Choice Settings',
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
                title: 'Disabled Settings',
                subtitle: 'This settings is not accessible',
                enabled: false,
              ),
              SimpleSettingsTile(
                title: 'Advanced',
                subtitle: 'Settings on a new Screen',
                screen: SettingsScreen(
                  title: "Full screen",
                  children: <Widget>[
                    CheckboxSettingsTile(
                      settingKey: 'key-check-box-1',
                      title: 'Sub menu option',
                    ),
                    SwitchSettingsTile(
                      settingKey: 'key-switch-1',
                      title: 'This is a Switch',
                    ),
                  ],
                ),
              ),
              SimpleModalSettingsTile(
                title: 'Advanced',
                subtitle: 'Settings on a dialog',
                children: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-check-box-2',
                    title: 'Sub menu option',
                  ),
                  SwitchSettingsTile(
                    settingKey: 'key-switch-2',
                    title: 'This is a Switch',
                  ),
                ],
              ),
              SimpleExpandableSettingsTile(
                title: 'More Advanced',
                subtitle: 'Expandable Settings',
                expanded: true,
                children: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-check-box-4',
                    title: 'Sub menu option',
                  ),
                  SwitchSettingsTile(
                    settingKey: 'key-switch-4',
                    title: 'This is a Switch',
                  ),
                ],
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Multiple choice settings',
            children: <Widget>[
              RadioSettingsTile<double>(
                title: 'Preferred Ratio (Radio)',
                settingKey: 'key-golden-ratio-radio',
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
                settingKey: 'key-golden-ratio-dropdown',
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
          SimpleModalSettingsTile(
            title: 'Group Settings',
            subtitle: 'Same group settings but in a dialog',
            children: <Widget>[
              RadioSettingsTile<double>(
                title: 'Preferred Ratio (Radio)',
                settingKey: 'key-golden-ratio-radio-2',
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
            ],
          ),
          SettingsTileGroup(
            title: 'Other settings',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Golden Ratio(Slider)',
                settingKey: 'key-golden-ratio-slider',
                defaultValue: 2.5,
                min: 1,
                max: 5,
                step: 0.1,
              ),
              ColorPickerSettingsTile(
                settingKey: 'key-color-picker',
                title: 'Color Picker',
                defaultValue: Colors.blue,
              )
            ],
          ),
          SimpleModalSettingsTile(
            title: 'Other settings',
            subtitle: 'Other Settings in a Dialog',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Golden Ratio(Slider)',
                settingKey: 'key-golden-ratio-slider-2',
                defaultValue: 2.5,
                min: 1,
                max: 5,
                step: 0.1,
              ),
              ColorPickerSettingsTile(
                settingKey: 'key-color-picker-2',
                title: 'Color Picker',
                defaultValue: Colors.blue,
              )
            ],
          )
        ],
      ),
    );
  }
}
