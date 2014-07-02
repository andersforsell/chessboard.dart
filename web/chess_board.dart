import 'package:polymer/polymer.dart';
import 'package:chess/chess.dart';
import 'dart:html';

/**
 * A Polymer chessboard element.
 */
@CustomTag('chess-board')
class ChessBoard extends PolymerElement {
  @published String position = Chess.DEFAULT_POSITION;

  @published String orientation = 'white';

  @published bool showNotation = true;

  @published String pieceTheme = 'img/chesspieces/wikipedia/{piece}.png';

  static final COLUMNS = 'abcdefgh'.split('');

  Element _boardEl;

  Element _dragPiece;

  Element _dragSquare;

  int _squareSize;

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
  }

  void _resize() {
    // Calculate the new square size
    _squareSize = _calculateSquareSize(clientWidth);

    // Set board width
    _boardEl.style.width = '${_squareSize * 8}px';

    // Redraw the board
    _drawBoard();
  }

  void _drawBoard() {
    _boardEl.setInnerHtml(_buildBoard(orientation == 'white'), validator:
        _htmlValidator);

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

  final _htmlValidator = new NodeValidatorBuilder.common()
      ..allowElement('div', attributes: ['style'])
      ..allowElement('img', attributes: ['style']);

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
              width: _squareSize, height: _squareSize)
              ..className = 'piece'
              ..onDragStart.listen(_onDragStart);
          squareElement.children.add(pieceElement);
        }
      }
    }
  }

  String _buildBoard(bool isWhiteOrientation) {
    var html = '';

    // algebraic notation / orientation
    var alpha = isWhiteOrientation ? COLUMNS : COLUMNS.reversed;
    var row = isWhiteOrientation ? 8 : 1;

    var squareColor = 'white';
    for (var i = 0; i < 8; i++) {
      html += '<div class="row">';
      for (var j = 0; j < 8; j++) {
        var square = "${alpha[j]}$row";

        html += '<div class="square $squareColor" ' +
            'style="width: ${_squareSize}px; height: ${_squareSize}px" ' + 'id="$square">';

        if (showNotation) {
          // alpha notation
          if ((isWhiteOrientation && row == 1) || (!isWhiteOrientation && row ==
              8)) {
            html += '<div class="notation alpha">${alpha[j]}</div>';
          }

          // numeric notation
          if (j == 0) {
            html += '<div class="notation numeric">$row</div>';
          }
        }

        html += '</div>'; // end .square

        squareColor = (squareColor == 'white' ? 'black' : 'white');
      }
      html += '<div class="clearfix"></div></div>';

      squareColor = (squareColor == 'white' ? 'black' : 'white');

      if (isWhiteOrientation) {
        row--;
      } else {
        row++;
      }
    }

    return html;
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
    if (_getValidMove(_dragSquare, dropTarget) != null) {
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
    var move = _getValidMove(_dragSquare, dropTarget);
    if (move != null) {
      _currentPosition.move(move);
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

  dynamic _getValidMove(Element fromSquare, Element toSquare) {
    String from = fromSquare.id;
    String to = toSquare.id;
    for (var move in _moves) {
      if (move['from'] == from && move['to'] == to) {
        return move;
      }
    }
    return null;
  }
}
