/* Copyright (c) 2014, Anders Forsell (aforsell1971@gmail.com)
 * Released under the MIT license
 * https://github.com/andersforsell/chessboard.dart/blob/master/LICENSE
 */

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'package:paper_elements/paper_input.dart';
import 'package:chessboard/chess_board.dart';

/**
 * A Polymer chessboard app for testing.
 */
@CustomTag('chess-board-app')
class ChessBoardApp extends PolymerElement {

  ChessBoardApp.created() : super.created();

  @override
  void domReady() {
    var navicon = $['navicon'];
    var drawerPanel = $['drawerPanel'];

    // TODO uncomment when https://github.com/dart-lang/core-elements/issues/39 is fixed
    // navicon.onClick.listen((e) => drawerPanel.togglePanel());
  }


  void onMove(CustomEvent event, detail, target) {
    ChessBoard chess = event.target;
    print('Move event, next turn is ${target.turn}');
  }

  void loadGameClicked(Event event, var detail, Node target) {
    PaperDialog loadGameDlg = $['loaddlg'];
    loadGameDlg.toggle();
  }

  void okClicked(Event event, var detail, Node target) {
      PaperInput feninput = $['feninput'];
      ChessBoard chess = $['chess_board'];
      chess.position = feninput.value;
      PaperDialog loadGameDlg = $['loaddlg'];
      loadGameDlg.toggle();
    }

}
