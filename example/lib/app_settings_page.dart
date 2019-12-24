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
                  title: "Additional Settings",
                  children: <Widget>[
                    CheckboxSettingsTile(
                      settingKey: 'key-check-box-simple',
                      title: 'Sub menu option',
                    ),
                    CheckboxSettingsTile(
                      settingKey: 'key-check-box-simple-2',
                      title: 'Sub menu option 2',
                    )
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
          ExpansionSettingsTile(
            title: 'Same as Above, but You can expand & close',
            children: [
              CheckboxSettingsTile(
                settingKey: 'key-check-box-2',
                title: 'This is a simple Checkbox',
              ),
              CheckboxSettingsTile(
                settingKey: 'key-check-box-3',
                title: 'This is a simple Checkbox',
              ),
              SettingsContainer(
                child: Text('This is Simple Setting! :)'),
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Selection Settings',
            children: <Widget>[
              RadioSettingsTile(
                settingKey: 'key-radio',
                title: 'Select one option',
                values: {
                  'a': 'Option A',
                  'b': 'Option B',
                  'c': 'Option C',
                  'd': 'Option D',
                },
              ),
              RadioPickerSettingsTile(
                settingKey: 'key-radio-2',
                title: 'Choose one in the modal dialog',
                values: {
                  'a': 'Option A',
                  'b': 'Option B',
                  'c': 'Option C',
                  'd': 'Option D',
                },
                defaultKey: 'b',
              ),
              DropdownSettingsTile<int>(
                title: 'Select number',
                defaultValue: 2,
                values: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                settingKey: 'key-drop-down',
                enabled: true,
                widgetBuilder: (int val) {
                  return Text('$val');
                },
              ),
            ],
          ),
          SliderSettingsTile(
            settingKey: 'key-slider',
            title: 'Rate this app',
            subtitle: 'How would you rate this app from 1 to 5?',
            defaultValue: 1.0,
            minValue: 1.0,
            maxValue: 5.0,
            step: 0.5,
          ),
          SettingsContainer(
            child: Text('Category Separator 2'),
            children: <Widget>[
              TextFieldModalSettingsTile(
                settingKey: 'key-text-field',
                title: 'Type your email',
                defaultValue: 'This is by default.',
                cancelCaption: 'Cancel',
                okCaption: 'Save Email',
                keyboardType: TextInputType.emailAddress,
              ),
              TextFieldModalSettingsTile(
                settingKey: 'key-text-field-2',
                title: 'Set User Password',
                obscureText: true,
              ),
            ],
          ),
          SettingsTileGroup(
            title: 'Color settings',
            children: <Widget>[
              MaterialColorPickerSettingsTile(
                settingKey: 'key-color-picker-2',
                title: 'Color Picker',
                cancelCaption: 'Keep the old value',
                okCaption: 'Select new',
                confirmText:
                    'Are you sure want to modify the previously selected color?',
                confirmModalTitle: 'Are you sure?',
                confirmModalCancelCaption: 'Keep the old one',
                confirmModalConfirmCaption: 'Yes, I am sure',
              )
            ],
          )
        ],
      ),
    );
  }
}
