## 0.2.1+1
* improved overall alignment of settings tiles
* update cache provide code to make asynchronous calls to setter methods
  - autoValidated parameter in text input settings is now deprecated and will be removed soon. User `autoValidateMode` parameter instead.
* removed native platform dependency code as this library does not depend on native features. At least not directly.

## 0.2.1
* `SimpleSettingsTile` will take any widget as `child` instead of only `SettingsScreen`
  - **Breaking**: parameter name changed from `screen` to `child` for consistency
* Added `subtitle` property for most settings tiles to allow a describing how this setting may introduce change in behaviour of the app
* Improved Settings title and subtitle text style for consistency in UI
* `SliderSettings` now have 2 additional callbacks:
  - onChangeStart - allows detecting drag start event
  - onChangeEnd - allows detecting drag end event
     - Using this allows changing the slider value only when user stops sliding
* Updated Example code to reflect latest features 

## 0.2.0+1
* improved plugin initialization, now supports async method call
* resolved a bug where Radio Settings was not reflecting changes

## 0.2.0
* complete re-do of the whole library
  * removed rx-dart dependency
  * improved the working of the many existing settings widgets
    * many of the choice based widgets now support any primitive value as input/output values instead of just strings
    * added more customization choices per setting widget
  * added a default cache provider which is based on `shared_preferences` library by flutter team
* updated code documentation

#### Breaking Change:
Your existing use of some settings widgets might show error or not work as due to them being re-designed, like change in name/type of the parameters or the widget itself is renamed.

This was a major re-design/refactor of the library, so please re-test part of your code which uses this library.

## 0.1.0+0.2
* update in license file

## 0.1.0+0.1
* 0.1.0 release + update in documentation and sdk version constraints

## 0.1.0
* first release

## 0.0.1
* initial code release