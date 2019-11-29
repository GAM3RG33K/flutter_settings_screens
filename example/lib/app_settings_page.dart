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
            screen: CheckboxSettingsTile(
              settingKey: 'key-check-box-simple',
              title: 'Sub menu',
            ),
          ),
          SettingsTileGroup(
            title: 'Group title',
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
          SliderSettingsTile(
            settingKey: 'key-slider',
            title: 'Rate this app',
            subtitle: 'How would you rate this app from 1 to 5?',
            defaultValue: 1.0,
            minValue: 1.0,
            maxValue: 5.0,
            step: 0.5,
          ),
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
          SimpleColorPickerSettingsTile(
            settingKey: 'key-color-picker',
            title: 'Color Picker',
            cancelCaption: 'Keep the old value',
            okCaption: 'Select new',
            confirmText:
                'Are you sure want to modify the previously selected color?',
            confirmModalTitle: 'Are you sure?',
            confirmModalCancelCaption: 'Keep the old one',
            confirmModalConfirmCaption: 'Yes, I am sure',
          ),
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
      ),
    );
  }
}
