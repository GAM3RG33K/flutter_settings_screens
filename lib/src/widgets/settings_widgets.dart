import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_settings_screens/src/utils/widget_utils.dart';

import 'color_picker/material_color_picker.dart';

part 'base_widgets.dart';

/// --------- Types of Settings widgets ---------- ///

/// [SimpleSettingsTile] is a simple settings tile that can open a new screen
/// by tapping the tile.
///
/// Example:
/// ```dart
/// SimpleSettingsTile(
///   title: 'Advanced',
///   subtitle: 'More, advanced settings.'
///   child: SettingsScreen(
///     title: 'Sub menu',
///     children: <Widget>[
///       CheckboxSettingsTile(
///         settingsKey: 'key-of-your-setting',
///         title: 'This is a simple Checkbox',
///       ),
///     ],
///   ),
/// );
/// ```
class SimpleSettingsTile extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String? subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// widget to be placed at first in the tile
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// widget that will be displayed on tap of the tile
  final Widget? child;

  final VoidCallback? onTap;

  final bool showDivider;

  SimpleSettingsTile({
    required this.title,
    this.subtitle,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.child,
    this.enabled = true,
    this.leading,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return _SettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      enabled: enabled,
      onTap: () => _handleTap(context),
      showDivider: showDivider,
      child: child != null ? getIcon(context) : Text(''),
    );
  }

  Widget getIcon(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.navigate_next),
      onPressed: enabled ? () => _handleTap(context) : null,
    );
  }

  void _handleTap(BuildContext context) {
    onTap?.call();

    if (child != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => child!,
      ));
    }
  }
}

/// [ModalSettingsTile] is a widget which allows creating
/// a setting which shows the [children] in a [_ModalSettingsTile]
///
/// Example:
/// ```dart
///  ModalSettingsTile(
///    title: 'Quick setting dialog',
///    subtitle: 'Settings on a dialog',
///    children: <Widget>[
///      CheckboxSettingsTile(
///        settingKey: 'key-day-light-savings',
///        title: 'Daylight Time Saving',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.timelapse),
///      ),
///      SwitchSettingsTile(
///        settingKey: 'key-dark-mode',
///        title: 'Dark Mode',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.palette),
///      ),
///    ],
///  );
///
/// ```
///
class ModalSettingsTile<T> extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// widget to be placed at first in the tile
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// List of widgets which are to be shown in the modal dialog
  final List<Widget> children;

  final bool showConfirmation;
  final VoidCallback? onCancel;
  final OnConfirmedCallback? onConfirm;

  ModalSettingsTile({
    required this.title,
    required this.children,
    this.subtitle = '',
    this.enabled = true,
    this.leading,
    this.showConfirmation = false,
    this.onCancel,
    this.onConfirm,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return _ModalSettingsTile<T>(
      leading: leading,
      title: title,
      subtitle: subtitle,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      enabled: enabled,
      onCancel: onCancel,
      onConfirm: onConfirm,
      showConfirmation: showConfirmation,
      children: children,
    );
  }
}

/// [ExpandableSettingsTile] is wrapper widget which shows the
/// given [children] in an [_ExpansionSettingsTile]
///
/// Example:
/// ```dart
///  ExpandableSettingsTile(
///    title: 'Quick setting dialog2',
///    subtitle: 'Expandable Settings',
///    onExpansionChanged: (state) {
///      _bolusExpanded = state;
///    },
///    children: <Widget>[
///      CheckboxSettingsTile(
///        settingKey: 'key-day-light-savings',
///        title: 'Daylight Time Saving',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.timelapse),
///      ),
///      SwitchSettingsTile(
///        settingKey: 'key-dark-mode',
///        title: 'Dark Mode',
///        enabledLabel: 'Enabled',
///        disabledLabel: 'Disabled',
///        leading: Icon(Icons.palette),
///      ),
///    ],
///  );
///
/// ```
class ExpandableSettingsTile extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// widget to be placed at first in the tile
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// List of the widgets which are to be shown when tile is expanded
  final List<Widget> children;

  /// flag which represents the initial state of the tile, if true the tile state is
  /// set to expanded initially, default = false
  final bool expanded;

  /// A Callback for the change of the Expansion state
  final Function(bool)? onExpansionChanged;

  final bool showDivider;

  ExpandableSettingsTile({
    required this.title,
    required this.children,
    this.subtitle = '',
    this.enabled = true,
    this.expanded = false,
    this.onExpansionChanged,
    this.leading,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return _ExpansionSettingsTile(
      leading: leading,
      title: title,
      subtitle: subtitle,
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
      enabled: enabled,
      expanded: expanded,
      onExpansionChanged: onExpansionChanged,
      showDivider: showDivider,
      child: SettingsContainer(
        children: children,
      ),
    );
  }
}

/// [SettingsContainer] is a widget that helps its child or children to fit in
/// the settings screen. It is helpful if you want to place other widgets than
/// settings tiles in the settings screen body.
/// Example:
/// ```dart
/// SettingsContainer(
/// 	children: <Widget>[
/// 		Text('First line'),
/// 		Text('Second line'),
///     Icon(Icons.palette),
/// 	],
/// );
/// ```
class SettingsContainer extends StatelessWidget {
  /// List of widgets which will be shown as Custom list of setting tile
  final List<Widget> children;

  /// flag to represent if this Container allows internal scrolling of the widgets
  /// along with the outer settings screen/container,
  /// if true, the list of widget inside are made scrollable, default = true
  final bool allowScrollInternally;

  final double leftPadding;

  SettingsContainer({
    required this.children,
    this.allowScrollInternally = false,
    this.leftPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChild();
  }

  Widget _buildChild() {
    var child = allowScrollInternally ? getList(children) : getColumn(children);
    return Padding(
      padding: EdgeInsets.only(
        top: 0.0,
      ),
      child: Material(
        child: Container(
          padding: EdgeInsets.only(left: leftPadding),
          child: child,
        ),
      ),
    );
  }

  Widget getList(List<Widget> children) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return children[index];
      },
      shrinkWrap: true,
      itemCount: children.length,
    );
  }

  Widget getColumn(List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

/// [SettingsGroup] is a widget that contains multiple settings tiles and other
/// widgets together as a group and shows a title/name of that group.
///
/// All the children widget will have a small padding from the left and top
/// to provide a sense that they in a separate group from others
///
///  Example:
///
/// ```dart
/// SettingsGroup(
///    title: 'Group title',
///    children: <Widget>[
///       CheckboxSettingsTile(
///         settingKey: 'key-day-light-savings',
///         title: 'Daylight Time Saving',
///         enabledLabel: 'Enabled',
///         disabledLabel: 'Disabled',
///         leading: Icon(Icons.timelapse),
///       ),
///       SwitchSettingsTile(
///         settingKey: 'key-dark-mode',
///         title: 'Dark Mode',
///         enabledLabel: 'Enabled',
///         disabledLabel: 'Disabled',
///         leading: Icon(Icons.palette),
///       ),
///  	],
///  );
/// ```
class SettingsGroup extends StatelessWidget {
  /// title string for the tile
  final String title;

  /// subtitle string for the tile
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// List of the widgets which are to be shown under the title as a group
  final List<Widget> children;

  SettingsGroup({
    required this.title,
    required this.children,
    this.subtitle = '',
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    var elements = <Widget>[
      Container(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 22.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title.toUpperCase(),
            style: titleTextStyle ?? groupStyle(context),
          ),
        ),
      ),
    ];

    if (subtitle.isNotEmpty) {
      elements.addAll([
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: subtitleTextStyle,
            ),
          ),
        ),
        _SettingsTileDivider(),
      ]);
    }
    elements.addAll(children);
    return Wrap(
      children: <Widget>[
        Column(
          children: elements,
        )
      ],
    );
  }

  TextStyle groupStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.secondary,
      fontSize: 12.0,
      fontWeight: FontWeight.bold,
    );
  }
}

/// --------- Common Settings widgets ---------- ///

/// A Setting widget which allows user a text input in a [TextFormField]
///
/// This widget by default is a [_ModalSettingsTile]. Meaning, this input field
/// will be shown in a dialog view.
///
/// Example:
///
/// ```dart
/// TextInputSettingsTile(
///   title: 'User Name',
///   settingKey: 'key-user-name',
///   initialValue: 'admin',
///   validator: (String username) {
///     if (username != null && username.length > 3) {
///       return null;
///     }
///     return "User Name can't be smaller than 4 letters";
///   },
///   borderColor: Colors.blueAccent,
///   errorColor: Colors.deepOrangeAccent,
/// );
///
/// ```
///
///  OR
///
/// ``` dart
/// TextInputSettingsTile(
///   title: 'password',
///   settingKey: 'key-user-password',
///   obscureText: true,
///   validator: (String password) {
///     if (password != null && password.length > 6) {
///       return null;
///     }
///     return "Password can't be smaller than 7 letters";
///   },
///   borderColor: Colors.blueAccent,
///   errorColor: Colors.deepOrangeAccent,
/// );
/// ```
class TextInputSettingsTile extends StatefulWidget {
  /// Settings Key string for storing the text in cache (assumed to be unique)
  final String settingKey;

  /// initial value to be filled in the text field, default = ''
  final String initialValue;

  /// title for the settings tile
  final String title;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// Validation mode helps use customize the way the input text field is
  /// validated for proper input values.
  ///
  /// [AutovalidateMode.disabled] - Never auto validate, equivalent of `autoValidate = false`
  /// [AutovalidateMode.always] - Always auto validate, equivalent of `autoValidate = true`
  /// [AutovalidateMode.onUserInteraction] - Only auto validate if user interacts with it
  final AutovalidateMode autovalidateMode;

  /// flag which represents if the text field will be focused by default
  /// or not
  /// if true, then the text field will be in focus other wise it will not be
  /// in focus by default, default = true
  final bool autoFocus;

  /// flag which represents if the text will be automatically selected on focus
  final bool selectAllOnFocus;

  /// on change callback for handling the value change
  final OnChanged<String>? onChange;

  /// validator for input validation
  final FormFieldValidator<String?>? validator;

  /// flag which represents the state of obscureText in the [TextFormField]
  ///  default = false
  final bool obscureText;

  /// Color of the border of the [TextFormField]
  final Color? borderColor;

  /// Color of the border of the [TextFormField], when there's an error
  /// or input is not passed through the validation
  final Color? errorColor;

  /// [TextInputType] of the [TextFormField] to set the keyboard type to name, phone, etc.
  final TextInputType? keyboardType;

  /// form helper text
  final String? helperText;

  /// list of inputFormatters
  final List<TextInputFormatter>? inputFormatters;

  TextInputSettingsTile({
    required this.title,
    required this.settingKey,
    this.initialValue = '',
    this.enabled = true,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.autoFocus = true,
    this.selectAllOnFocus = false,
    this.onChange,
    this.validator,
    this.obscureText = false,
    this.borderColor,
    this.errorColor,
    this.keyboardType,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.helperText,
    this.inputFormatters,
  });

  @override
  _TextInputSettingsTileState createState() => _TextInputSettingsTileState();
}

class _TextInputSettingsTileState extends State<TextInputSettingsTile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (widget.selectAllOnFocus) {
        _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<String>(
      cacheKey: widget.settingKey,
      defaultValue: widget.initialValue,
      builder: (BuildContext context, String value, OnChanged<String> onChanged) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _controller.text = value;
        });
        return SettingsContainer(
          children: [
            _ModalSettingsTile<String>(
              title: widget.title,
              subtitle: widget.obscureText ? '' : value,
              titleTextStyle: widget.titleTextStyle,
              subtitleTextStyle: widget.subtitleTextStyle,
              enabled: widget.enabled,
              showConfirmation: true,
              onConfirm: () => _submitText(_controller.text),
              onCancel: () {
                _controller.text = Settings.getValue(widget.settingKey) ?? '';
              },
              children: <Widget>[
                _buildTextField(context, value, onChanged),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(BuildContext context, String value, OnChanged<String> onChanged) {
    final borderColor = widget.borderColor ?? Colors.blue;
    final errorColor = widget.errorColor ?? Colors.red;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: TextFormField(
          autofocus: widget.autoFocus,
          controller: _controller,
          focusNode: _focusNode,
          autovalidateMode: widget.autovalidateMode,
          enabled: widget.enabled,
          validator: widget.enabled ? widget.validator : null,
          onSaved: widget.enabled ? (value) => _onSave(value, onChanged) : null,
          obscureText: widget.obscureText,
          keyboardType: widget.keyboardType,
          cursorColor: borderColor,
          inputFormatters: widget.inputFormatters ?? [],
          decoration: InputDecoration(
            helperText: widget.helperText,
            errorMaxLines: 3,
            helperMaxLines: 3,
            errorStyle: TextStyle(
              color: errorColor,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              borderSide: BorderSide(color: errorColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              borderSide: BorderSide(
                color: borderColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _submitText(String newValue) {
    var isValid = true;
    final state = _formKey.currentState;
    if (state != null) {
      isValid = state.validate();
    }

    if (isValid) {
      state?.save();
      return true;
    }

    return false;
  }

  void _onSave(String? newValue, OnChanged<String> onChanged) {
    if (newValue == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChanged(newValue);
      widget.onChange?.call(newValue);
    });
  }
}

/// [SwitchSettingsTile] is a widget that has a [Switch] with given title,
/// subtitle and default value/status of the switch
///
/// This widget supports an additional list of widgets to display
/// when the switch is enabled. These optional list of widgets is accessed
/// through `childrenIfEnabled` property of this widget.
///
/// This widget works similar to [CheckboxSettingsTile].
///
///  Example:
///
/// ```dart
///  SwitchSettingsTile(
///   leading: Icon(Icons.developer_mode),
///   settingKey: 'key-switch-dev-mode',
///   title: 'Developer Settings',
///   onChange: (value) {
///     debugPrint('key-switch-dev-mod: $value');
///   },
///   childrenIfEnabled: <Widget>[
///     CheckboxSettingsTile(
///       leading: Icon(Icons.adb),
///       settingKey: 'key-is-developer',
///       title: 'Developer Mode',
///       onChange: (value) {
///         debugPrint('key-is-developer: $value');
///       },
///     ),
///     SwitchSettingsTile(
///       leading: Icon(Icons.usb),
///       settingKey: 'key-is-usb-debugging',
///       title: 'USB Debugging',
///       onChange: (value) {
///         debugPrint('key-is-usb-debugging: $value');
///       },
///     ),
///     SimpleSettingsTile(
///       title: 'Root Settings',
///       subtitle: 'These settings is not accessible',
///       enabled: false,
///     )
///   ],
///  );
///  ```
class SwitchSettingsTile extends StatelessWidget {
  /// Settings Key string for storing the state of switch in cache (assumed to be unique)
  final String settingKey;

  /// initial value to be used as state of the switch, default = false
  final bool defaultValue;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// on change callback for handling the value change
  final OnChanged<bool>? onChange;

  /// A Widget that will be displayed in the front of the tile
  final Widget? leading;

  /// A specific text that will be displayed as subtitle when switch is set to enable state
  /// if provided, default = ''
  final String enabledLabel;

  /// A specific text that will be displayed as subtitle when switch is set to disable state
  /// if provided, default = ''
  final String disabledLabel;

  /// A List of widgets that will be displayed when the switch is set to enable
  /// state, Any flutter widget can be added in this list
  final List<Widget>? childrenIfEnabled;

  final Color? activeColor;

  final bool showDivider;

  SwitchSettingsTile({
    required this.title,
    required this.settingKey,
    this.defaultValue = false,
    this.enabled = true,
    this.onChange,
    this.leading,
    this.enabledLabel = '',
    this.disabledLabel = '',
    this.childrenIfEnabled,
    this.subtitle = '',
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.activeColor,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder: (BuildContext context, bool value, OnChanged<bool> onChanged) {
        Widget mainWidget = _SettingsTile(
          leading: leading,
          title: title,
          subtitle: getSubtitle(value),
          onTap: () => _onSwitchChange(context, !value, onChanged),
          enabled: enabled,
          titleTextStyle: titleTextStyle,
          subtitleTextStyle: subtitleTextStyle,
          showDivider: showDivider,
          child: _SettingsSwitch(
            value: value,
            onChanged: (value) => _onSwitchChange(context, value, onChanged),
            enabled: enabled,
            activeColor: activeColor,
          ),
        );

        var finalWidget = getFinalWidget(
          context,
          mainWidget,
          value,
          childrenIfEnabled,
        );
        return finalWidget;
      },
    );
  }

  Future<void> _onSwitchChange(BuildContext context, bool? value, OnChanged<bool> onChanged) async {
    if (value == null) return;
    onChanged(value);
    onChange?.call(value);
  }

  String getSubtitle(bool currentStatus) {
    if (subtitle.isNotEmpty) {
      return subtitle;
    }
    var label = '';
    if (currentStatus && enabledLabel.isNotEmpty) {
      label = enabledLabel;
    }
    if (!currentStatus && disabledLabel.isNotEmpty) {
      label = disabledLabel;
    }
    return label;
  }

  Widget getFinalWidget(BuildContext context, Widget mainWidget, bool currentValue, List<Widget>? childrenIfEnabled) {
    if (childrenIfEnabled == null || !currentValue) {
      return SettingsContainer(
        children: [mainWidget],
      );
    }
    var _children = getPaddedParentChildrenList(childrenIfEnabled);
    _children.insert(0, mainWidget);

    return SettingsContainer(
      children: _children,
    );
  }
}

/// [CheckboxSettingsTile] is a widget that has a [Checkbox] with given title,
/// subtitle and default value/status of the Checkbox
///
/// This widget supports an additional list of widgets to display
/// when the Checkbox is checked. These optional list of widgets is accessed
/// through `childrenIfEnabled` property of this widget.
///
/// This widget works similar to [SwitchSettingsTile].
///
///  Example:
///
/// ```dart
///  CheckboxSettingsTile(
///   leading: Icon(Icons.developer_mode),
///   settingKey: 'key-check-box-dev-mode',
///   title: 'Developer Settings',
///   onChange: (value) {
///     debugPrint('key-check-box-dev-mode: $value');
///   },
///   childrenIfEnabled: <Widget>[
///     CheckboxSettingsTile(
///       leading: Icon(Icons.adb),
///       settingKey: 'key-is-developer',
///       title: 'Developer Mode',
///       onChange: (value) {
///         debugPrint('key-is-developer: $value');
///       },
///     ),
///     SwitchSettingsTile(
///       leading: Icon(Icons.usb),
///       settingKey: 'key-is-usb-debugging',
///       title: 'USB Debugging',
///       onChange: (value) {
///         debugPrint('key-is-usb-debugging: $value');
///       },
///     ),
///   ],
///  );
///  ```
class CheckboxSettingsTile extends StatelessWidget {
  /// Settings Key string for storing the state of checkbox in cache (assumed to be unique)
  final String settingKey;

  /// initial value to be used as state of the checkbox, default = false
  final bool defaultValue;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// on change callback for handling the value change
  final OnChanged<bool>? onChange;

  /// A Widget that will be displayed in the front of the tile
  final Widget? leading;

  /// A specific text that will be displayed as subtitle when checkbox is set to enable state
  /// if provided, default = ''
  final String enabledLabel;

  /// A specific text that will be displayed as subtitle when checkbox is set to disable state
  /// if provided, default = ''
  final String disabledLabel;

  /// A List of widgets that will be displayed when the checkbox is set to enable
  /// state, Any flutter widget can be added in this list
  final List<Widget>? childrenIfEnabled;

  final bool showDivider;

  CheckboxSettingsTile({
    required this.title,
    required this.settingKey,
    this.defaultValue = false,
    this.enabled = true,
    this.onChange,
    this.leading,
    this.enabledLabel = '',
    this.disabledLabel = '',
    this.childrenIfEnabled,
    this.subtitle = '',
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<bool>(
      cacheKey: settingKey,
      defaultValue: defaultValue,
      builder: (BuildContext context, bool value, OnChanged<bool> onChanged) {
        var mainWidget = _SettingsTile(
          leading: leading,
          title: title,
          enabled: enabled,
          subtitle: getSubtitle(value),
          onTap: () => _onCheckboxChange(!value, onChanged),
          titleTextStyle: titleTextStyle,
          subtitleTextStyle: subtitleTextStyle,
          showDivider: showDivider,
          child: _SettingsCheckbox(
            value: value,
            onChanged: (value) => _onCheckboxChange(value, onChanged),
            enabled: enabled,
          ),
        );

        var finalWidget = getFinalWidget(
          context,
          mainWidget,
          value,
          childrenIfEnabled,
        );
        return finalWidget;
      },
    );
  }

  Future<void> _onCheckboxChange(bool? value, OnChanged<bool> onChanged) async {
    if (value == null) return;
    onChanged(value);
    onChange?.call(value);
  }

  String getSubtitle(bool currentStatus) {
    if (subtitle.isNotEmpty) {
      return subtitle;
    }

    var label = '';
    if (currentStatus && enabledLabel.isNotEmpty) {
      label = enabledLabel;
    }
    if (!currentStatus && disabledLabel.isNotEmpty) {
      label = disabledLabel;
    }
    return label;
  }

  Widget getFinalWidget(BuildContext context, Widget mainWidget, bool currentValue, List<Widget>? childrenIfEnabled) {
    if (childrenIfEnabled == null || !currentValue) {
      return SettingsContainer(
        children: [mainWidget],
      );
    }
    var _children = getPaddedParentChildrenList(childrenIfEnabled);
    _children.insert(0, mainWidget);

    return SettingsContainer(
      children: _children,
    );
  }
}

/// [RadioSettingsTile] is a widget that has a list of [Radio] widgets with given title,
/// subtitle and default/group value which determines which Radio will be selected
/// initially.
///
/// This widget support Any type of values which should be put in the preference.
/// However, since any types of the value is supported, the input for this widget
/// is a Map to the required values with their string representation.
///
/// For example if the required value type is a boolean then the values map can
/// be as following:
///  <bool, String> {
///     true: 'Enabled',
///     false: 'Disabled'
///  }
///
/// So, if the `Enabled` value radio is selected then the value `true` will be
/// stored in the preference
///
/// Complete Example:
///
/// ```dart
/// RadioSettingsTile<int>(
///   title: 'Preferred Sync Period',
///   settingKey: 'key-radio-sync-period',
///   values: <int, String>{
///     0: 'Never',
///     1: 'Daily',
///     7: 'Weekly',
///     15: 'Fortnight',
///     30: 'Monthly',
///   },
///   selected: 0,
///   onChange: (value) {
///     debugPrint('key-radio-sync-period: $value days');
///   },
/// )
/// ```
class RadioSettingsTile<T> extends StatefulWidget {
  /// Settings Key string for storing the state of Radio buttons in cache (assumed to be unique)
  final String settingKey;

  /// Selected value in the radio button group otherwise known as group value
  final T selected;

  /// A map containing unique values along with the display name
  final Map<T, String> values;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// flag which allows showing the display names along with the radio button
  final bool showTitles;

  /// on change callback for handling the value change
  final OnChanged<T>? onChange;

  /// A Widget that will be displayed in the front of the tile
  final Widget? leading;

  final Color? activeColor;

  final bool showDivider;

  RadioSettingsTile({
    required this.title,
    required this.settingKey,
    required this.selected,
    required this.values,
    this.enabled = true,
    this.onChange,
    this.leading,
    this.showTitles = true,
    this.subtitle = '',
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.activeColor,
    this.showDivider = true,
  });

  @override
  _RadioSettingsTileState<T> createState() => _RadioSettingsTileState<T>();
}

class _RadioSettingsTileState<T> extends State<RadioSettingsTile<T>> {
  late T selectedValue;

  @override
  void initState() {
    selectedValue = widget.selected;
    super.initState();
  }

  Future<void> _onRadioChange(T? value, OnChanged<T> onChanged) async {
    if (value == null) return;
    selectedValue = value;
    onChanged(value);
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: <Widget>[
            Visibility(
              visible: showTitles,
              child: _SimpleHeaderTile(
                title: widget.title,
                subtitle: widget.subtitle.isNotEmpty ? widget.subtitle : widget.values[selectedValue],
                leading: widget.leading,
                titleTextStyle: widget.titleTextStyle,
                subtitleTextStyle: widget.subtitleTextStyle,
              ),
            ),
            _buildRadioTiles(context, value, onChanged, widget.activeColor)
          ],
        );
      },
    );
  }

  bool get showTitles => widget.showTitles;

  Widget _buildRadioTiles(BuildContext context, T groupValue, OnChanged<T> onChanged, Color? activeColor) {
    var radioList = widget.values.entries.map<Widget>((MapEntry<T, String> entry) {
      return _SettingsTile(
        title: entry.value,
        titleTextStyle: widget.titleTextStyle,
        onTap: () => _onRadioChange(entry.key, onChanged),
        enabled: widget.enabled,
        showDivider: widget.showDivider,
        child: _SettingsRadio<T>(
          value: entry.key,
          onChanged: (newValue) => _onRadioChange(newValue, onChanged),
          enabled: widget.enabled,
          groupValue: groupValue,
          activeColor: activeColor,
        ),
      );
    }).toList();
    return Column(
      children: radioList,
    );
  }
}

/// [DropDownSettingsTile] is a widget that has a list of [DropdownMenuItem]s
/// with given title, subtitle and default/group value which determines
/// which value will be set to selected initially.
///
/// This widget support Any type of values which should be put in the preference.
///
/// However, since any types of the value is supported, the input for this widget
/// is a Map to the required values with their string representation.
///
/// For example if the required value type is a boolean then the values map can
/// be as following:
///  <bool, String> {
///     true: 'Enabled',
///     false: 'Disabled'
///  }
///
/// So, if the `Enabled` value is selected then the value `true` will be
/// stored in the preference
///
/// Complete Example:
///
/// ```dart
/// DropDownSettingsTile<int>(
///   title: 'E-Mail View',
///   settingKey: 'key-dropdown-email-view',
///   values: <int, String>{
///     2: 'Simple',
///     3: 'Adjusted',
///     4: 'Normal',
///     5: 'Compact',
///     6: 'Squeezed',
///   },
///   selected: 2,
///   onChange: (value) {
///     debugPrint('key-dropdown-email-view: $value');
///   },
/// );
/// ```
class DropDownSettingsTile<T> extends StatefulWidget {
  /// Settings Key string for storing the state of Radio buttons in cache (assumed to be unique)
  final String settingKey;

  /// Selected value in the radio button group otherwise known as group value
  final T selected;

  /// A map containing unique values along with the display name
  final Map<T, String> values;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// The widget shown in front of the title
  final Widget? leading;

  /// Alignment of the dropdown. Defaults to [AlignmentDirectional.centerEnd].
  final AlignmentGeometry alignment;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// on change callback for handling the value change
  final OnChanged<T>? onChange;

  final bool showDivider;

  DropDownSettingsTile({
    required this.title,
    required this.settingKey,
    required this.selected,
    required this.values,
    this.enabled = true,
    this.onChange,
    this.subtitle = '',
    this.leading,
    this.alignment = AlignmentDirectional.centerEnd,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.showDivider = true,
  });

  @override
  _DropDownSettingsTileState<T> createState() => _DropDownSettingsTileState<T>();
}

class _DropDownSettingsTileState<T> extends State<DropDownSettingsTile<T>> {
  late T selectedValue;

  @override
  void initState() {
    selectedValue = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: <Widget>[
            _SettingsTile(
              title: widget.title,
              subtitle: widget.subtitle,
              leading: widget.leading,
              enabled: widget.enabled,
              titleTextStyle: widget.titleTextStyle,
              subtitleTextStyle: widget.subtitleTextStyle,
              showDivider: widget.showDivider,
              child: _SettingsDropDown<T>(
                selected: value,
                alignment: widget.alignment,
                values: widget.values.keys.toList().cast<T>(),
                onChanged: (newValue) => _handleDropDownChange(newValue, onChanged),
                enabled: widget.enabled,
                itemBuilder: (T value) {
                  return Text(widget.values[value]!);
                },
              ),
            )
          ],
        );
      },
    );
  }

  Future<void> _handleDropDownChange(T? value, OnChanged<T> onChanged) async {
    if (value == null) return;
    selectedValue = value;
    onChanged(value);
    widget.onChange?.call(value);
  }
}

/// [SliderSettingsTile] is a widget that has a slider given title,
/// subtitle and default value which determines what the slider's position
/// will be set initially.
///
/// Example:
///
/// ```dart
/// SliderSettingsTile(
///  title: 'Volume',
///  settingKey: 'key-slider-volume',
///  defaultValue: 20,
///  min: 0,
///  max: 100,
///  step: 1,
///  leading: Icon(Icons.volume_up),
///  onChange: (value) {
///    debugPrint('key-slider-volume: $value');
///  },
/// );
/// ```
class SliderSettingsTile extends StatefulWidget {
  /// Settings Key string for storing the state of Slider in cache (assumed to be unique)
  final String settingKey;

  /// Selected value in the radio button group otherwise known as group value
  /// default = 0.0
  final double defaultValue;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// flag which allows updating the value of setting immediately when the
  /// slider is moved, default = true
  ///
  /// If this flag is enabled then [onChangeStart] & [onChangeEnd] callbacks are
  /// ignored & will not be executed
  ///
  /// If this flag is disabled only then the [onConfirm] will be executed
  final bool eagerUpdate;

  /// minimum allowed value for the slider, in other terms a start value
  /// for the slider
  final double min;

  /// maximum allowed value for the slider, in other terms a end value
  /// for the slider
  final double max;

  /// a step value which will be used to move the slider.
  /// default = 1.0
  ///
  /// i.e. if the step = 1.0 then moving slider from left to right
  /// will result in following values in order:
  ///  1.0, 2.0, 3.0, 4.0, ..., 100.0
  ///
  /// if the step = 5.0 then the same slider movement will result in:
  ///  5.0, 10.0, 15.0, 20.0, ..., 100.0
  final double step;

  /// on change callback for handling the value change
  final OnChanged<double>? onChange;

  /// callback for fetching the value slider movement starts
  final OnChanged<double>? onChangeStart;

  /// callback for fetching the value slider movement ends
  final OnChanged<double>? onChangeEnd;

  /// callback for fetching the value slider movement starts
  final Widget? leading;

  /// Value to be used as precision when printing the current value in widget
  ///
  /// Basically this value is used for input in [double.toStringAsFixed] method
  /// while printing display value
  ///
  /// default = 2, you'll need to adjust the precision according to step value
  ///
  /// Note:
  /// However this does not affect the actual value in the onChange callbacks
  ///
  /// For example:
  ///  case 1:
  ///   current value: 5.2500001
  ///   decimalPrecision: 0
  ///   result:
  ///     callback value: 5.2500001
  ///     display value: 5
  ///
  ///  case 2:
  ///   current value: 5.2500001
  ///   decimalPrecision: 1
  ///   result:
  ///     callback value: 5.2500001
  ///     display value: 5.2
  ///
  ///  case 3:
  ///   current value: 5.2500001
  ///   decimalPrecision: 2
  ///   result:
  ///     callback value: 5.2500001
  ///     display value: 5.25
  final int decimalPrecision;

  SliderSettingsTile({
    required this.title,
    required this.settingKey,
    required this.min,
    required this.max,
    this.subtitle = '',
    this.defaultValue = 0.0,
    this.enabled = true,
    this.eagerUpdate = true,
    this.step = 1.0,
    this.onChange,
    this.onChangeStart,
    this.onChangeEnd,
    this.leading,
    this.decimalPrecision = 2,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  _SliderSettingsTileState createState() => _SliderSettingsTileState();
}

class _SliderSettingsTileState extends State<SliderSettingsTile> {
  late double currentValue;

  @override
  void initState() {
    currentValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<double>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder: (BuildContext context, double value, OnChanged<double> onChanged) {
        // debugPrint('creating settings Tile: ${widget.settingKey}');
        return SettingsContainer(
          children: <Widget>[
            _SimpleHeaderTile(
              title: widget.title,
              subtitle: widget.subtitle.isNotEmpty ? widget.subtitle : value.toStringAsFixed(widget.decimalPrecision),
              leading: widget.leading,
              titleTextStyle: widget.titleTextStyle,
              subtitleTextStyle: widget.subtitleTextStyle,
            ),
            _SettingsSlider(
              onChanged: (newValue) => _handleSliderChanged(newValue, onChanged),
              onChangeStart: (newValue) => _handleSliderChangeStart(newValue, onChanged),
              onChangeEnd: (newValue) => _handleSliderChangeEnd(newValue, onChanged),
              enabled: widget.enabled,
              eagerUpdate: widget.eagerUpdate,
              value: value,
              max: widget.max,
              min: widget.min,
              step: widget.step,
            ),
            _SettingsTileDivider(),
          ],
        );
      },
    );
  }

  void _updateWidget(double newValue, OnChanged<double> onChanged) {
    currentValue = newValue;
    onChanged(newValue);
  }

  void _handleSliderChanged(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChange?.call(newValue);
  }

  void _handleSliderChangeStart(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeStart?.call(newValue);
  }

  Future<void> _handleSliderChangeEnd(double newValue, OnChanged<double> onChanged) async {
    _updateWidget(newValue, onChanged);
    widget.onChangeEnd?.call(newValue);
  }
}

/// [ColorPickerSettingsTile] is a widget which allows user to
/// select the a color from a set of Material color choices.
///
/// Since, [Color] is an in-memory object type, the serialized version
/// of the value of this widget will be a Hex value [String] of the selected
/// color.
///
/// This conversion string <-> color, makes this easy to check/debug the values
/// from the storage/preference manually.
///
/// The color panel shown in the widget is provided by `flutter_material_color_picker` library.
///
/// Example:
///
/// ```dart
///  ColorPickerSettingsTile(
///    settingKey: 'key-color-picker',
///    title: 'Accent Color',
///    defaultValue: Colors.blue,
///    onChange: (value) {
///      debugPrint('key-color-picker: $value');
///    },
///  );
/// ```
class ColorPickerSettingsTile extends StatefulWidget {
  /// Settings Key string for storing the state of Color picker in cache (assumed to be unique)
  final String settingKey;

  /// Default value of the color as a Hex String, default = '#ff000000'
  final String defaultStringValue;

  /// Default value of the color
  final Color? defaultValue;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// The widget shown in front of the title
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// on change callback for handling the value change
  final OnChanged<Color>? onChange;

  final bool showDivider;

  ColorPickerSettingsTile({
    required this.title,
    required this.settingKey,
    this.defaultValue,
    this.enabled = true,
    this.onChange,
    this.defaultStringValue = '#ff000000',
    this.subtitle = '',
    this.leading,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.showDivider = true,
  });

  @override
  _ColorPickerSettingsTileState createState() => _ColorPickerSettingsTileState();
}

class _ColorPickerSettingsTileState extends State<ColorPickerSettingsTile> {
  late String currentValue;

  @override
  void initState() {
    super.initState();

    if (widget.defaultValue != null) {
      currentValue = ConversionUtils.stringFromColor(widget.defaultValue!);
    } else {
      currentValue = widget.defaultStringValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<String>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder: (BuildContext context, String value, OnChanged<String> onChanged) {
        // debugPrint('creating settings Tile: ${widget.settingKey}');
        return _SettingsColorPicker(
          title: widget.title,
          value: value,
          leading: widget.leading,
          enabled: widget.enabled,
          subtitle: widget.subtitle,
          onChanged: (color) => _handleColorChanged(color, onChanged),
          titleTextStyle: widget.titleTextStyle,
          subtitleTextStyle: widget.subtitleTextStyle,
          showDivider: widget.showDivider,
        );
      },
    );
  }

  Future<void> _handleColorChanged(String color, OnChanged<String> onChanged) async {
    currentValue = color;
    onChanged(color);
    final colorFromString = ConversionUtils.colorFromString(color);
    widget.onChange?.call(colorFromString);
  }
}

/// [RadioModalSettingsTile] widget is the dialog version of the
/// [RadioSettingsTile] widget.
///
/// Meaning this widget is similar to a [RadioSettingsTile] shown in a dialog.
///
/// Use of this widget is similar to the [RadioSettingsTile], only the displayed
/// widget will be in a different position. i.e instead of the settings screen,
/// it will be shown in a dialog above the settings screen.
///
/// Example:
/// ```dart
/// RadioModalSettingsTile<int>(
///   title: 'Preferred Sync Period',
///   settingKey: 'key-radio-sync-period',
///   values: <int, String>{
///     0: 'Never',
///     1: 'Daily',
///     7: 'Weekly',
///     15: 'Fortnight',
///     30: 'Monthly',
///   },
///   selected: 0,
///   onChange: (value) {
///     debugPrint('key-radio-sync-period: $value days');
///   },
/// );
/// ```
///
class RadioModalSettingsTile<T> extends StatefulWidget {
  /// Settings Key string for storing the state of Radio setting in cache (assumed to be unique)
  final String settingKey;

  /// Selected value or group value of the radio buttons
  final T selected;

  /// A map containing unique values along with the display name
  final Map<T, String> values;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// The widget shown in front of the title
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// flag which allows showing the display names along with the radio button
  final bool showTitles;

  /// on change callback for handling the value change
  final OnChanged<T>? onChange;

  final Color? activeColor;

  final bool showDivider;

  RadioModalSettingsTile({
    required this.title,
    required this.settingKey,
    required this.selected,
    required this.values,
    this.enabled = true,
    this.showTitles = false,
    this.onChange,
    this.subtitle = '',
    this.leading,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.activeColor,
    this.showDivider = true,
  });

  @override
  _RadioModalSettingsTileState<T> createState() => _RadioModalSettingsTileState<T>();
}

class _RadioModalSettingsTileState<T> extends State<RadioModalSettingsTile<T>> {
  late T selectedValue;

  @override
  void initState() {
    selectedValue = widget.selected;
    super.initState();
  }

  Future<void> _onRadioChange(T? value, OnChanged<T> onChanged) async {
    if (value == null) return;
    selectedValue = value;
    onChanged(value);
    widget.onChange?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<T>(
      cacheKey: widget.settingKey,
      defaultValue: selectedValue,
      builder: (BuildContext context, T value, OnChanged<T> onChanged) {
        return SettingsContainer(
          children: [
            _ModalSettingsTile<T>(
              title: widget.title,
              subtitle: widget.subtitle.isNotEmpty ? widget.subtitle : widget.values[value],
              leading: widget.leading,
              titleTextStyle: widget.titleTextStyle,
              subtitleTextStyle: widget.subtitleTextStyle,
              children: <Widget>[
                RadioSettingsTile<T>(
                  title: '',
                  showTitles: widget.showTitles,
                  enabled: widget.enabled,
                  values: widget.values,
                  settingKey: widget.settingKey,
                  onChange: (value) => _onRadioChange(value, onChanged),
                  selected: value,
                  activeColor: widget.activeColor,
                  showDivider: widget.showDivider,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// [SliderModalSettingsTile] widget is the dialog version of the
/// [SliderSettingsTile] widget.
///
/// Meaning this widget is similar to a [SliderSettingsTile] shown in a dialog.
///
/// Use of this widget is similar to the [SliderSettingsTile], only the displayed
/// widget will be in a different position. i.e instead of the settings screen,
/// it will be shown in a dialog above the settings screen.
///
/// Example:
/// ```dart
/// SliderSettingsTile(
///  title: 'Volume',
///  settingKey: 'key-slider-volume',
///  defaultValue: 20,
///  min: 0,
///  max: 100,
///  step: 1,
///  leading: Icon(Icons.volume_up),
///  onChange: (value) {
///    debugPrint('key-slider-volume: $value');
///  },
/// );
/// ```
///
class SliderModalSettingsTile extends StatefulWidget {
  /// Settings Key string for storing the state of Slider in cache (assumed to be unique)
  final String settingKey;

  /// Selected value in the radio button group otherwise known as group value
  /// default = 0.0
  final double defaultValue;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// The widget shown in front of the title
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// flag which allows updating the value of setting immediately when the
  /// slider is moved, default = true
  ///
  /// If this flag is enabled then [onChangeStart] & [onChangeEnd] callbacks are
  /// ignored & will not be executed
  ///
  /// If this flag is disabled only then the [onConfirm] will be executed
  final bool eagerUpdate;

  /// minimum allowed value for the slider, in other terms a start value
  /// for the slider
  final double min;

  /// maximum allowed value for the slider, in other terms a end value
  /// for the slider
  final double max;

  /// a step value which will be used to move the slider.
  /// default = 1.0
  ///
  /// i.e. if the step = 1.0 then moving slider from left to right
  /// will result in following values in order:
  ///  1.0, 2.0, 3.0, 4.0, ..., 100.0
  ///
  /// if the step = 5.0 then the same slider movement will result in:
  ///  5.0, 10.0, 15.0, 20.0, ..., 100.0
  final double step;

  /// on change callback for handling the value change
  final OnChanged<double>? onChange;

  /// callback for fetching the value slider movement starts
  final OnChanged<double>? onChangeStart;

  /// callback for fetching the value slider movement ends
  final OnChanged<double>? onChangeEnd;

  SliderModalSettingsTile({
    required this.title,
    required this.settingKey,
    required this.min,
    required this.max,
    this.defaultValue = 0.0,
    this.enabled = true,
    this.step = 0.0,
    this.onChange,
    this.onChangeStart,
    this.onChangeEnd,
    this.subtitle = '',
    this.leading,
    this.eagerUpdate = true,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  _SliderModalSettingsTileState createState() => _SliderModalSettingsTileState();
}

class _SliderModalSettingsTileState extends State<SliderModalSettingsTile> {
  late double currentValue;

  @override
  void initState() {
    currentValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueChangeObserver<double>(
      cacheKey: widget.settingKey,
      defaultValue: currentValue,
      builder: (BuildContext context, double value, OnChanged<double> onChanged) {
        // debugPrint('creating settings Tile: ${widget.settingKey}');
        return SettingsContainer(
          children: <Widget>[
            _ModalSettingsTile<double>(
              title: widget.title,
              subtitle: widget.subtitle.isNotEmpty ? widget.subtitle : value.toString(),
              leading: widget.leading,
              titleTextStyle: widget.titleTextStyle,
              subtitleTextStyle: widget.subtitleTextStyle,
              children: <Widget>[
                _SettingsSlider(
                  onChanged: (double newValue) => _handleSliderChanged(newValue, onChanged),
                  onChangeStart: (double newValue) => _handleSliderChangeStart(newValue, onChanged),
                  onChangeEnd: (double newValue) => _handleSliderChangeEnd(newValue, onChanged),
                  enabled: widget.enabled,
                  eagerUpdate: widget.eagerUpdate,
                  value: value,
                  max: widget.max,
                  min: widget.min,
                  step: widget.step,
                )
              ],
            ),
          ],
        );
      },
    );
  }

  void _handleSliderChanged(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChange?.call(newValue);
  }

  void _handleSliderChangeStart(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeStart?.call(newValue);
  }

  void _handleSliderChangeEnd(double newValue, OnChanged<double> onChanged) {
    _updateWidget(newValue, onChanged);
    widget.onChangeEnd?.call(newValue);
  }

  void _updateWidget(double newValue, OnChanged<double> onChanged) {
    currentValue = newValue;
    onChanged(newValue);
  }
}

/// [SimpleRadioSettingsTile] is a simpler version of
/// the [RadioSettingsTile].
///
/// Instead of a Value-String map, this widget just takes a list
/// of String values.
///
/// Example:
/// ```dart
/// SimpleRadioSettingsTile(
///   title: 'Sync Settings',
///   settingKey: 'key-radio-sync-settings',
///   values: <String>[
///     'Never',
///     'Daily',
///     'Weekly',
///     'Fortnight',
///     'Monthly',
///   ],
///   selected: 'Daily',
///   onChange: (value) {
///     debugPrint('key-radio-sync-settings: $value');
///   },
/// );
/// ```
class SimpleRadioSettingsTile extends StatelessWidget {
  /// Settings Key string for storing the state of Radio setting in cache (assumed to be unique)
  final String settingKey;

  /// Selected value or group value of the radio buttons
  final String selected;

  /// A map containing unique values along with the display name
  final List<String> values;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// The widget shown in front of the title
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// on change callback for handling the value change
  final OnChanged<String>? onChange;

  SimpleRadioSettingsTile({
    required this.title,
    required this.settingKey,
    required this.selected,
    required this.values,
    this.enabled = true,
    this.onChange,
    this.subtitle = '',
    this.leading,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RadioSettingsTile<String>(
      title: title,
      subtitle: subtitle,
      leading: leading,
      settingKey: settingKey,
      selected: selected,
      enabled: enabled,
      onChange: onChange,
      values: getValues(values),
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
    );
  }

  Map<String, String> getValues(List<String> values) {
    var valueMap = <String, String>{};
    values.forEach((String value) {
      valueMap[value] = value;
    });
    return valueMap;
  }
}

/// [SimpleDropDownSettingsTile] is a simpler version of
/// the [DropDownSettingsTile].
///
/// Instead of a Value-String map, this widget just takes a list
/// of String values.
///
/// Example:
/// ```dart
/// SimpleDropDownSettingsTile(
///   title: 'Beauty Filter',
///   settingKey: 'key-dropdown-beauty-filter',
///   values: <String>[
///     'Simple',
///     'Normal',
///     'Little Special',
///     'Special',
///     'Extra Special',
///     'Bizzar',
///     'Horrific',
///   ],
///   selected: 'Special',
///   onChange: (value) {
///     debugPrint('key-dropdown-beauty-filter: $value');
///  },
/// );
/// ```
class SimpleDropDownSettingsTile extends StatelessWidget {
  /// Settings Key string for storing the state of Radio buttons in cache (assumed to be unique)
  final String settingKey;

  /// Selected value in the radio button group otherwise known as group value
  final String selected;

  /// A map containing unique values along with the display name
  final List<String> values;

  /// title for the settings tile
  final String title;

  /// subtitle for the settings tile, default = ''
  final String subtitle;

  /// title text style
  final TextStyle? titleTextStyle;

  /// subtitle text style
  final TextStyle? subtitleTextStyle;

  /// The widget shown in front of the title
  final Widget? leading;

  /// flag which represents the state of the settings, if false the the tile will
  /// ignore all the user inputs, default = true
  final bool enabled;

  /// on change callback for handling the value change
  final OnChanged<String>? onChange;

  SimpleDropDownSettingsTile({
    required this.title,
    required this.settingKey,
    required this.selected,
    required this.values,
    this.enabled = true,
    this.onChange,
    this.subtitle = '',
    this.leading,
    this.titleTextStyle,
    this.subtitleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DropDownSettingsTile<String>(
      title: title,
      subtitle: subtitle,
      leading: leading,
      settingKey: settingKey,
      selected: selected,
      enabled: enabled,
      onChange: onChange,
      values: getValues(values),
      titleTextStyle: titleTextStyle,
      subtitleTextStyle: subtitleTextStyle,
    );
  }

  Map<String, String> getValues(List<String> values) {
    var valueMap = <String, String>{};
    values.forEach((String value) {
      valueMap[value] = value;
    });
    return valueMap;
  }
}
