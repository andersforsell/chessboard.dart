// DO NOT EDIT: auto-generated with `pub run custom_element_apigen:update`

/// Dart API for the polymer element `paper_input`.
library paper_elements.paper_input;

import 'dart:html';
import 'dart:js' show JsArray, JsObject;
import 'package:web_components/interop.dart' show registerDartType;
import 'package:polymer/polymer.dart' show initMethod;
import 'package:core_elements/core_input.dart';

/// `paper-input` is a single- or multi-line text field where user can enter input.
/// It can optionally have a label.
///
/// Example:
///
///     <paper-input label="Your Name"></paper-input>
///     <paper-input multiline label="Enter multiple lines here"></paper-input>
///
/// Theming
/// --------
///
/// Set `CoreStyle.g.paperInput.focusedColor` and `CoreStyle.g.paperInput.invalidColor` to theme
/// the focused and invalid states.
///
/// To add custom styling to only some elements, use these selectors:
///
///     html /deep/ paper-input[focused] .floated-label {
///         /* floating label color when the input has focus */
///         color: green;
///     }
///
///     html /deep/ paper-input .focused-underline,
///     html /deep/ paper-input .cursor {
///         /* line and cursor color when the input has focus */
///         background-color: green;
///     }
///
///     html /deep/ paper-input.invalid[focused] .floated-label,
///     html /deep/ paper-input[focused] .error-text,
///     html /deep/ paper-input[focused] .error-icon {
///         /* error text, icon, and floating label color when input is invalid */
///         color: salmon;
///     }
///
///     html /deep/ paper-input.invalid .focused-underline,
///     html /deep/ paper-input.invalid .cursor {
///         /* line and cursor color when the input is invalid */
///         background-color: salmon;
///     }
class PaperInput extends CoreInput {
  PaperInput.created() : super.created();
  factory PaperInput() => new Element.tag('paper-input');

  /// The label for this input. It normally appears as grey text inside
  /// the text input and disappears once the user enters text.
  String get label => jsElement['label'];
  set label(String value) { jsElement['label'] = value; }

  /// If true, the label will "float" above the text input once the
  /// user enters text instead of disappearing.
  bool get floatingLabel => jsElement['floatingLabel'];
  set floatingLabel(bool value) { jsElement['floatingLabel'] = value; }

  /// (multiline only) If set to a non-zero value, the height of this
  /// text input will grow with the value changes until it is maxRows
  /// rows tall. If the maximum size does not fit the value, the text
  /// input will scroll internally.
  num get maxRows => jsElement['maxRows'];
  set maxRows(num value) { jsElement['maxRows'] = value; }

  /// The message to display if the input value fails validation. If this
  /// is unset or the empty string, a default message is displayed depending
  /// on the type of validation error.
  String get error => jsElement['error'];
  set error(String value) { jsElement['error'] = value; }

  get inputValueForMirror => jsElement['inputValueForMirror'];

  get inputHasValue => jsElement['inputHasValue'];
}
@initMethod
upgradePaperInput() => registerDartType('paper-input', PaperInput);
