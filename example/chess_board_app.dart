/* Copyright (c) 2014, Anders Forsell (aforsell1971@gmail.com)
 * Released under the MIT license
 * https://github.com/andersforsell/chessboard.dart/blob/master/LICENSE
 */

import 'dart:html';
import 'package:polymer/polymer.dart';
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
}
