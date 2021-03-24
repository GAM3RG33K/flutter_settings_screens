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
        title: 'Application Settings',
        children: [
          SettingsGroup(
            title: 'Single Choice Settings',
            children: <Widget>[
              SwitchSettingsTile(
                settingKey: 'key-wifi',
                title: 'Wi-Fi',
                subtitle: 'Wi-Fi allows interacting with the local network '
                    'or internet via connecting to a W-Fi router',
                enabledLabel: 'Enabled',
                disabledLabel: 'Disabled',
                leading: Icon(Icons.wifi),
                onChange: (value) {
                  debugPrint('key-wifi: $value');
                },
              ),
              CheckboxSettingsTile(
                settingKey: 'key-blue-tooth',
                title: 'Bluetooth',
                subtitle: 'Bluetooth allows interacting with the '
                    'near by bluetooth enabled devices',
                enabledLabel: 'Enabled',
                disabledLabel: 'Disabled',
                leading: Icon(Icons.bluetooth),
                onChange: (value) {
                  debugPrint('key-blue-tooth: $value');
                },
              ),
              SwitchSettingsTile(
                leading: Icon(Icons.developer_mode),
                settingKey: 'key-switch-dev-mode',
                title: 'Developer Settings',
                onChange: (value) {
                  debugPrint('key-switch-dev-mod: $value');
                },
                childrenIfEnabled: <Widget>[
                  CheckboxSettingsTile(
                    leading: Icon(Icons.adb),
                    settingKey: 'key-is-developer',
                    title: 'Developer Mode',
                    onChange: (value) {
                      debugPrint('key-is-developer: $value');
                    },
                  ),
                  SwitchSettingsTile(
                    leading: Icon(Icons.usb),
                    settingKey: 'key-is-usb-debugging',
                    title: 'USB Debugging',
                    onChange: (value) {
                      debugPrint('key-is-usb-debugging: $value');
                    },
                  ),
                  SimpleSettingsTile(
                    title: 'Root Settings',
                    subtitle: 'These setting is not accessible',
                    enabled: false,
                  ),
                  SimpleSettingsTile(
                    title: 'Custom Settings',
                    subtitle: 'Tap to execute custom callback',
                    onTap: () => debugPrint('Custom action'),
                  ),
                ],
              ),
              SimpleSettingsTile(
                title: 'More Settings',
                subtitle: 'General App Settings',
                child: SettingsScreen(
                  title: 'App Settings',
                  children: <Widget>[
                    CheckboxSettingsTile(
                      leading: Icon(Icons.adb),
                      settingKey: 'key-is-developer',
                      title: 'Developer Mode',
                      onChange: (bool value) {
                        debugPrint('Developer Mode ${value ? 'on' : 'off'}');
                      },
                    ),
                    SwitchSettingsTile(
                      leading: Icon(Icons.usb),
                      settingKey: 'key-is-usb-debugging',
                      title: 'USB Debugging',
                      onChange: (value) {
                        debugPrint('USB Debugging: $value');
                      },
                    ),
                  ],
                ),
              ),
              TextInputSettingsTile(
                title: 'User Name',
                settingKey: 'key-user-name',
                initialValue: 'admin',
                validator: (String username) {
                  if (username != null && username.length > 3) {
                    return null;
                  }
                  return "User Name can't be smaller than 4 letters";
                },
                borderColor: Colors.blueAccent,
                errorColor: Colors.deepOrangeAccent,
              ),
              TextInputSettingsTile(
                title: 'password',
                settingKey: 'key-user-password',
                obscureText: true,
                validator: (String password) {
                  if (password != null && password.length > 6) {
                    return null;
                  }
                  return "Password can't be smaller than 7 letters";
                },
                borderColor: Colors.blueAccent,
                errorColor: Colors.deepOrangeAccent,
              ),
              ModalSettingsTile(
                title: 'Quick setting dialog',
                subtitle: 'Settings on a dialog',
                children: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-day-light-savings',
                    title: 'Daylight Time Saving',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.timelapse),
                    onChange: (value) {
                      debugPrint('key-day-light-saving: $value');
                    },
                  ),
                  SwitchSettingsTile(
                    settingKey: 'key-dark-mode',
                    title: 'Dark Mode',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.palette),
                    onChange: (value) {
                      debugPrint('jey-dark-mode: $value');
                    },
                  ),
                ],
              ),
              ExpandableSettingsTile(
                title: 'Quick setting 2',
                subtitle: 'Expandable Settings',
                children: <Widget>[
                  CheckboxSettingsTile(
                    settingKey: 'key-day-light-savings-2',
                    title: 'Daylight Time Saving',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.timelapse),
                    onChange: (value) {
                      debugPrint('key-day-light-savings-2: $value');
                    },
                  ),
                  SwitchSettingsTile(
                    settingKey: 'key-dark-mode-2',
                    title: 'Dark Mode',
                    enabledLabel: 'Enabled',
                    disabledLabel: 'Disabled',
                    leading: Icon(Icons.palette),
                    onChange: (value) {
                      debugPrint('key-dark-mode-2: $value');
                    },
                  ),
                ],
              ),
            ],
          ),
          SettingsGroup(
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
                onChange: (value) {
                  debugPrint('key-radio-sync-period: $value');
                },
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
                onChange: (value) {
                  debugPrint('key-dropdown-email-view: $value');
                },
              ),
            ],
          ),
          ModalSettingsTile(
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
                onChange: (value) {
                  debugPrint('key-radio-sync-settins: $value');
                },
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
                onChange: (value) {
                  debugPrint('key-dropdown-beauty-filter: $value');
                },
              )
            ],
          ),
          ExpandableSettingsTile(
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
                onChange: (value) {
                  debugPrint('key-radio-beauty-filter-expandable: $value');
                },
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
                onChange: (value) {
                  debugPrint('key-dropdown-sync-period-2: $value');
                },
              )
            ],
          ),
          SettingsGroup(
            title: 'Other settings',
            children: <Widget>[
              SliderSettingsTile(
                title: 'Volume',
                settingKey: 'key-slider-volume',
                defaultValue: 20,
                min: 0,
                max: 100,
                step: 5,
                leading: Icon(Icons.volume_up),
                onChangeEnd: (value) {
                  debugPrint('\n===== on change end =====\n'
                      'key-slider-volume: $value'
                      '\n==========\n');
                },
              ),
              ColorPickerSettingsTile(
                settingKey: 'key-color-picker',
                title: 'Accent Color',
                defaultValue: Colors.blue,
                onChange: (value) {
                  debugPrint('key-color-picker: $value');
                },
              )
            ],
          ),
          ModalSettingsTile(
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
                onChange: (value) {
                  debugPrint('\n===== on change =====\n'
                      'key-custom-ratio-slider-2: $value'
                      '\n==========\n');
                },
                onChangeStart: (value) {
                  debugPrint('\n===== on change start =====\n'
                      'key-custom-ratio-slider-2: $value'
                      '\n==========\n');
                },
                onChangeEnd: (value) {
                  debugPrint('\n===== on change end =====\n'
                      'key-custom-ratio-slider-2: $value'
                      '\n==========\n');
                },
              ),
              ColorPickerSettingsTile(
                settingKey: 'key-color-picker-2',
                title: 'Accent Picker',
                defaultValue: Colors.blue,
                onChange: (value) {
                  debugPrint('key-color-picker-2: $value');
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
