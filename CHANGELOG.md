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