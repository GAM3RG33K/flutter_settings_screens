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
              SwitchSettingsTile(
                settingKey: 'key-wifi',
                title: 'Wi-Fi',
                enabledLabel: 'Enabled',
                disabledLabel: 'Disabled',
                leading: Icon(Icons.wifi),
              ),
              CheckboxSettingsTile(
                settingKey: 'key-blue-tooth',
                title: 'Bluetooth',
                enabledLabel: 'Enabled',
                disabledLabel: 'Disabled',
                leading: Icon(Icons.bluetooth),
              ),
              SimpleSettingsTile(
                title: 'Root Settings',
                subtitle: 'These settings is not accessible',
                enabled: false,
              ),
              SimpleSettingsTile(
                title: 'More Settings',
                subtitle: 'General App Settings',
                screen: SettingsScreen(
                  title: "App Settings",
                  children: <Widget>[
                    CheckboxSettingsTile(
                      leading: Icon(Icons.adb),
                      settingKey: 'key-is-developer',
                      title: 'Developer Mode',
                    ),
                    SwitchSettingsTile(
                      leading: Icon(Icons.usb),
                      settingKey: 'key-is-usb-debugging',
                      title: 'USB Debugging',
                    ),
                  ],
                ),
              ),
              SimpleModalSettingsTile(
                title: 'Quick setting dialog',
                subtitle: 'Settings on a dialog',
                children: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-day-light-savings',
                    title: 'Daylight Time Saving',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.timelapse),
                  ),
                  SwitchSettingsTile(
                    settingKey: 'key-dark-mode',
                    title: 'Dark Mode',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.palette),
                  ),
                ],
              ),
              SimpleExpandableSettingsTile(
                title: 'Quick setting 2',
                subtitle: 'Expandable Settings',
                children: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-day-light-savings-2',
                    title: 'Daylight Time Saving',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.timelapse),
                  ),
                  SwitchSettingsTile(
                    settingKey: 'key-dark-mode-2',
                    title: 'Dark Mode',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.palette),
                  ),
                ],
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Multiple choice settings',
            children: <Widget>[
              RadioSettingsTile<int>(
                title: 'Preferred Sync Period',
                settingKey: 'key-radio-sync-period',
                values: <int, String>{
                  0: 'Never',
                  1: 'Daily',
                  7: 'Weekly',
                  15: 'Fortnight',
                  30: 'Monthly',
                },
                selected: 0,
              ),
              DropDownSettingsTile<int>(
                title: 'E-Mail View',
                settingKey: 'key-dropdown-email-view',
                values: <int, String>{
                  2: 'Simple',
                  3: 'Adjusted',
                  4: 'Normal',
                  5: 'Compact',
                  6: 'Squizzed',
                },
                selected: 2,
              ),
            ],
          ),
          SimpleModalSettingsTile(
            title: 'Group Settings',
            subtitle: 'Same group settings but in a dialog',
            children: <Widget>[
              SimpleRadioSettingsTile(
                title: 'Sync Settings',
                settingKey: 'key-radio-sync-settings',
                values: <String>[
                  'Never',
                  'Daily',
                  'Weekly',
                  'Fortnight',
                  'Monthly',
                ],
                selected: 'Daily',
              ),
              SimpleDropDownSettingsTile(
                title: 'Beauty Filter',
                settingKey: 'key-dropdown-beauty-filter',
                values: <String>[
                  'Simple',
                  'Normal',
                  'Little Special',
                  'Special',
                  'Extra Special',
                  'Bizzar',
                  'Horrific',
                ],
                selected: 'Special',
              )
            ],
          ),
          SimpleExpandableSettingsTile(
            title: 'Expandable Group Settings',
            subtitle: 'Group of settings (expandable)',
            children: <Widget>[
              RadioSettingsTile<double>(
                title: 'Beauty Filter',
                settingKey: 'key-radio-beauty-filter-exapndable',
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
              DropDownSettingsTile<int>(
                title: 'Preferred Sync Period',
                settingKey: 'key-dropdown-sync-period-2',
                values: <int, String>{
                  0: 'Never',
                  1: 'Daily',
                  7: 'Weekly',
                  15: 'Fortnight',
                  30: 'Monthly',
                },
                selected: 0,
              )
            ],
          ),
          SettingsTileGroup(
            title: 'Other settings',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Volume',
                settingKey: 'key-slider-volume',
                defaultValue: 20,
                min: 0,
                max: 100,
                step: 1,
                leading: Icon(Icons.volume_up),
              ),
              ColorPickerSettingsTile(
                settingKey: 'key-color-picker',
                title: 'Accent Color',
                defaultValue: Colors.blue,
              )
            ],
          ),
          SimpleModalSettingsTile(
            title: 'Other settings',
            subtitle: 'Other Settings in a Dialog',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Custom Ratio',
                settingKey: 'key-custom-ratio-slider-2',
                defaultValue: 2.5,
                min: 1,
                max: 5,
                step: 0.1,
                leading: Icon(Icons.aspect_ratio),
              ),
              ColorPickerSettingsTile(
                settingKey: 'key-color-picker-2',
                title: 'Accent Picker',
                defaultValue: Colors.blue,
              )
            ],
          )
        ],
      ),
    );
  }
}
