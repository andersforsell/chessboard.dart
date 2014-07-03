library chessboard;

/* Copyright (c) 2014, Anders Forsell (aforsell1971@gmail.com)
 * Released under the MIT license
 * https://github.com/andersforsell/chessboard.dart/blob/master/LICENSE
 *
 * Based on chessboard.js
 * Copyright 2013 Chris Oakman
 * Released under the MIT license
 * https://github.com/oakmac/chessboardjs/blob/master/LICENSE
 */

import 'dart:html';
import 'package:polymer/polymer.dart';
import 'package:chess/chess.dart';
import 'package:paper_elements/paper_dialog.dart';

/**
 * A Polymer chessboard element.
 */
@CustomTag('chess-board')
class ChessBoard extends PolymerElement {
  @published String position = Chess.DEFAULT_POSITION;

  @published bool reversed = false;

  @published bool showNotation = true;

  @published String pieceTheme = 'img/chesspieces/wikipedia/{piece}.png';

  @observable int squareSize = 0;

  static final COLUMNS = 'abcdefgh'.split('');

  Element _boardEl;

  Element _dragPiece;

  Element _dragSquare;

  // Pawn promotion square
  Element _promotionSquare;

  PaperDialog _promotionDlg;

  Chess _currentPosition;

  List _moves;

  ChessBoard.created() : super.created();

  @override
  void domReady() {
    _currentPosition = new Chess.fromFEN(position);
    _moves = _currentPosition.moves({
      'verbose': true
    });

    _boardEl = shadowRoot.querySelector('.board');

    // Set the size and draw the board
    _resize();

    _setPromotionDialogAttributes();
  }

  void _setPromotionDialogAttributes() {
    for (Element button in shadowRoot.querySelector('#white_promo').children) {
      button.setAttribute('iconSrc', _buildPieceImgSrc(button.id));
    }
    for (Element button in shadowRoot.querySelector('#black_promo').children) {
      button.setAttribute('iconSrc', _buildPieceImgSrc(button.id));
    }
  }

  void _resize() {
    // Calculate the new square size
    squareSize = _calculateSquareSize(clientWidth);

    // Set board width
    _boardEl.style.width = '${squareSize * 8}px';

    // Redraw the board
    _drawBoard();
  }

  void _drawBoard() {
    _addDragDropListeners();

   _drawPositionInstant();
  }

  void _addDragDropListeners() {
    for (var square in _boardEl.querySelectorAll('.square')) {
      square
          ..onDragEnd.listen(_onDragEnd)
          ..onDragEnter.listen(_onDragEnter)
          ..onDragOver.listen(_onDragOver)
          ..onDragLeave.listen(_onDragLeave)
          ..onDrop.listen(_onDrop);
    }
  }

  void _drawPositionInstant() {
    // Draw board pieces
    for (var row = 1; row <= 8; row++) {
      for (var col in COLUMNS) {
        var square = "$col$row";
        var piece = _currentPosition.get(square);
        var squareElement = _boardEl.querySelector('#$square');
        var pieceElement = squareElement.querySelector('.piece');
        if (pieceElement != null) pieceElement.remove();
        if (piece != null) {
          var pieceStr = '${piece.color}${piece.type.toUpperCase()}';
          pieceElement = new ImageElement(src: _buildPieceImgSrc(pieceStr),
              width: squareSize, height: squareSize)
              ..className = 'piece'
              ..onDragStart.listen(_onDragStart);
          squareElement.children.add(pieceElement);
        }
      }
    }
  }

  String _buildPieceImgSrc(String piece) {
    return pieceTheme.replaceAll(new RegExp('{piece}'), piece);
  }

  /**
   * Calculates square size based on the width of the container
   * got a little CSS black magic here, so let me explain:
   * get the width of the container element (could be anything), reduce by 1 for
   * fudge factor, and then keep reducing until we find an exact mod 8 for
   * our square size.
   */
  int _calculateSquareSize(int containerWidth) {
    if (containerWidth <= 0) {
      return 0;
    }

    // pad one pixel
    var boardWidth = containerWidth - 1;

    while (boardWidth % 8 != 0 && boardWidth > 0) {
      boardWidth--;
    }

    return boardWidth ~/ 8;
  }

  void _onDragStart(MouseEvent event) {
    _dragPiece = event.target;
    _dragPiece.classes.add('moving');
    _dragSquare = _dragPiece.parent;
    event.dataTransfer.effectAllowed = 'move';
  }

  void _onDragEnd(MouseEvent event) {
    _dragPiece.classes.remove('moving');
    var squares = _boardEl.querySelectorAll('.square');
    for (var square in squares) {
      square.classes.remove('over');
    }
  }

  void _onDragEnter(MouseEvent event) {
    Element dropTarget = _getSquareElement(event);
    if (_getValidMoves(_dragSquare, dropTarget).isNotEmpty) {
      event.dataTransfer.effectAllowed = 'move';
      dropTarget.classes.add('over');
    } else {
      event.dataTransfer.effectAllowed = 'none';
    }
  }

  void _onDragOver(MouseEvent event) {
    // This is necessary to allow us to drop.
    event.preventDefault();
    event.dataTransfer.dropEffect = 'move';
  }

  void _onDragLeave(MouseEvent event) {
    Element dropTarget = _getSquareElement(event);
    dropTarget.classes.remove('over');
  }

  void _onDrop(MouseEvent event) {
    // Stop the browser from redirecting.
    event.stopPropagation();

    // Don't do anything if dropping onto the same column we're dragging.
    Element dropTarget = _getSquareElement(event);
    dropTarget.classes.remove('over');
    var moves = _getValidMoves(_dragSquare, dropTarget);
    if (moves.length > 1) {
      // Pawn promotion
      _promotionDlg = _boardEl.querySelector('#white_promo');
      _promotionDlg.opened = true;
      _promotionSquare = dropTarget;
    } else if (moves.length == 1) {
      _currentPosition.move(moves[0]);
      _moves = _currentPosition.moves({
        'verbose': true
      });
      _drawPositionInstant();
    }
  }

  Element _getSquareElement(MouseEvent event) {
    Element target = event.target;
    if (target.classes.contains('piece')) {
      return target.parent;
    }
    return target;
  }

  /**
   * Returns a list of valid moves between two squares, or an empty list
   * if there is no valid move. More than one is returned for pawn promotion.
   */
  List _getValidMoves(Element fromSquare, Element toSquare) {
    List moves = [];
    String from = fromSquare.id;
    String to = toSquare.id;
    for (var move in _moves) {
      if (move['from'] == from && move['to'] == to) {
        moves.add(move);
      }
    }
    return moves;
  }

  void promotionClicked(Event event, var detail, Node target) {
    if (target != null) {
      String pieceStr = (target as Element).id;
      var move = {
        'from': "${_dragSquare.id}",
        'to': "${_promotionSquare.id}",
        'promotion': "${pieceStr.substring(1).toLowerCase()}"
      };
      _currentPosition.move(move);
      _moves = _currentPosition.moves({
        'verbose': true
      });
      _drawPositionInstant();
      _promotionSquare = null;
      _promotionDlg.opened = false;
    }
  }
}
