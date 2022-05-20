import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sudoku_game/board/board_solver.dart';
import 'package:sudoku_game/models/board.dart';
import 'package:sudoku_game/models/cell.dart';
import 'package:sudoku_game/util/extensions.dart';

abstract class BoardFactory {
  @visibleForTesting
  static var i = 0;
  @visibleForTesting
  static var j = 0;

  @visibleForTesting
  static int getRandomDigitOf(int max) => Random().nextInt(max) + 1;

  static var _board = Board();

  @visibleForTesting
  static void goNextTile() {
    assert(i < 9);
    if (j < 8) {
      j++;
    } else {
      i++;
      j = 0;
    }
  }

  @visibleForTesting
  static void clearCurrentTileAndGoPrevious() {
    assert(i >= 0);
    _board.cells[i][j].number = 0;

    if (j > 0) {
      j--;
    } else {
      i--;
      j = 8;
    }
  }

  @visibleForTesting
  static bool isBoardFilled() {
    for (final row in _board.cells) {
      for (final cell in row) {
        if (cell.isNotFilled) return false;
      }
    }

    return true;
  }

  static Board buildEasyBoard() {
    _board = Board();
    i = 0;
    j = 0;

    int _currentNumber() => _board.cells[i][j].availableNumbers![0];

    while (!isBoardFilled()) {
      if (_board.cells[i][j].availableNumbers!.isEmpty) {
        _board.cells[i][j].refillAvailableNumbers();
        clearCurrentTileAndGoPrevious();
      } else {
        if (isConflict(_currentNumber(), i, j, _board)) {
          _board.cells[i][j].availableNumbers!.remove(_currentNumber());
        } else {
          _board.cells[i][j]
            ..number = _currentNumber()
            ..solutionNumber = _currentNumber()
            ..coordinates = [i, j];
          goNextTile();
        }
      }
    }

    final _boardCopy = List.of(_board.cells.expand((List<Cell> e) => e))..shuffle();

    while (_boardCopy.isNotEmpty) {
      var _oldNumber = _board.cells[_boardCopy[0].i][_boardCopy[0].j].number;
      _board.cells[_boardCopy[0].i][_boardCopy[0].j].number = null;

      var _solutionCount = 0;

      for (var k = 1; k < 10; k++) {
        if (!isConflict(k, _boardCopy[0].i, _boardCopy[0].j, _board)) {
          _solutionCount++;
        }
      }
      assert(_solutionCount > 0);

      if (_solutionCount > 1) {
        _board.cells[_boardCopy[0].i][_boardCopy[0].j]
          ..number = _oldNumber
          ..isClickable = false;
      }

      _boardCopy.removeAt(0);
    }

    return _board;
  }

  static Board buildMediumBoard() {
    _board = _mediumBoards[getRandomDigitOf(_mediumBoards.length) - 1].toBoard();
    _shuffleBoard();
    return BoardSolver.getSolvedBoard(_board);
  }

  static Board buildHardBoard() {
    _board = _hardBoards[getRandomDigitOf(_hardBoards.length) - 1].toBoard();
    _shuffleBoard();
    return BoardSolver.getSolvedBoard(_board);
  }

  static Board buildExtremeBoard() {
    final _boardJson = _solvedExtremeBoardsAsJson[getRandomDigitOf(_solvedExtremeBoardsAsJson.length) - 1];
    final _boardDeserialized = jsonDecode(_boardJson);

    _board = Board.fromJson(_boardDeserialized);
    _shuffleBoard();
    return _board;
  }

  static void _shuffleBoard() {
    var _count = getRandomDigitOf(50);

    while (_count > 0) {
      final _firstDigit = getRandomDigitOf(9);
      final _secondDigit = getRandomDigitOf(9);

      for (var i = 0; i < 9; i++) {
        for (var j = 0; j < 9; j++) {
          final _cell = _board.cells[i][j];

          if (_cell.solutionNumber == _firstDigit) {
            _cell.solutionNumber = _secondDigit;

            if (_cell.number != null) {
              _cell.number = _secondDigit;
            }
          } else if (_cell.solutionNumber == _secondDigit) {
            _cell.solutionNumber = _firstDigit;

            if (_cell.number != null) {
              _cell.number = _firstDigit;
            }
          }
        }
      }
      _count--;
    }
  }

  static bool isOccupiedNumberInGroup(int index, int number, int groupIndex) {
    final _isOccupiedInGroup =
        BoardFactory.cellsByGroup(_board)[groupIndex].where((cell) => cell.number == number).length > 1;

    final _isOccupiedInRow = BoardFactory.cellsByRow(BoardFactory.getRowInGroup(index), groupIndex)
            .where((cell) => cell.number == number)
            .length >
        1;

    final _isOccupiedInColumn = BoardFactory.cellsByColumn(BoardFactory.getColumnInGroup(index), groupIndex)
            .where((cell) => cell.number == number)
            .length >
        1;

    return _isOccupiedInGroup || _isOccupiedInRow || _isOccupiedInColumn;
  }

  static bool isConflict(int num, int i, int j, Board board) {
    return cellsByGroup(board)[getGroupIndexOf(i, j)].where((cell) => cell.number == num).isNotEmpty ||
        List.generate(9, (row) => board.cells[i][row]).where((cell) => cell.number == num).isNotEmpty ||
        List.generate(9, (col) => board.cells[col][j]).where((cell) => cell.number == num).isNotEmpty;
  }

  static List<List<Cell>> cellsByGroup(Board board) {
    return List.generate(9, (i) {
      return getGroupCoordinates(i).map((coordinates) => board.cells[coordinates[0]][coordinates[1]]).toList();
    });
  }

  static List<Cell> cellsByRow(int row, int groupIndex) {
    if (groupIndex > 2 && groupIndex <= 5) {
      row += 3;
    } else if (groupIndex > 5) {
      row += 6;
    }

    return List.generate(9, (i) => _board.cells[row][i]);
  }

  static List<Cell> cellsByColumn(int column, int groupIndex) {
    if (groupIndex == 1 || groupIndex == 4 || groupIndex == 7) {
      column += 3;
    } else if (groupIndex == 2 || groupIndex == 5 || groupIndex == 8) {
      column += 6;
    }

    return List.generate(9, (i) => _board.cells[i][column]);
  }

  static int getRowInGroup(int i) {
    if (i <= 2) {
      return 0;
    } else if (i <= 5) {
      return 1;
    } else {
      return 2;
    }
  }

  static int getColumnInGroup(int i) {
    if (i == 0 || i == 3 || i == 6) {
      return 0;
    } else if (i == 1 || i == 4 || i == 7) {
      return 1;
    } else {
      return 2;
    }
  }

  static int getGroupIndexOf(int a, int b) {
    var res = -1;

    if (a >= 0 && a <= 2 && b >= 0 && b <= 2) {
      res = 0;
    } else if (a >= 0 && a <= 2 && b >= 3 && b <= 5) {
      res = 1;
    } else if (a >= 0 && a <= 2 && b >= 6 && b <= 8) {
      res = 2;
    } else if (a >= 3 && a <= 5 && b >= 0 && b <= 2) {
      res = 3;
    } else if (a >= 3 && a <= 5 && b >= 3 && b <= 5) {
      res = 4;
    } else if (a >= 3 && a <= 5 && b >= 6 && b <= 8) {
      res = 5;
    } else if (a >= 6 && a <= 8 && b >= 0 && b <= 2) {
      res = 6;
    } else if (a >= 6 && a <= 8 && b >= 3 && b <= 5) {
      res = 7;
    } else if (a >= 6 && a <= 8 && b >= 6 && b <= 8) {
      res = 8;
    }

    assert(res >= 0);
    return res;
  }

  static List<List<int>> getGroupCoordinates(int groupIndex) {
    var res = <List<int>>[];

    switch (groupIndex) {
      case 0:
        for (var i = 0; i < 3; i++) {
          for (var j = 0; j < 3; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 1:
        for (var i = 0; i < 3; i++) {
          for (var j = 3; j < 6; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 2:
        for (var i = 0; i < 3; i++) {
          for (var j = 6; j < 9; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 3:
        for (var i = 3; i < 6; i++) {
          for (var j = 0; j < 3; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 4:
        for (var i = 3; i < 6; i++) {
          for (var j = 3; j < 6; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 5:
        for (var i = 3; i < 6; i++) {
          for (var j = 6; j < 9; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 6:
        for (var i = 6; i < 9; i++) {
          for (var j = 0; j < 3; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 7:
        for (var i = 6; i < 9; i++) {
          for (var j = 3; j < 6; j++) {
            res.add([i, j]);
          }
        }
        break;
      case 8:
        for (var i = 6; i < 9; i++) {
          for (var j = 6; j < 9; j++) {
            res.add([i, j]);
          }
        }
        break;
    }

    return res;
  }

  static void setBoard(Board board) {
    _board = board;
  }

  /*
 * Since I've not managed to generate harder boards yet, so I'll use
 * those hard coded boards from https://github.com/ogarcia/opensudoku for now.
 * Good Luck and Have Fun!
 * */
  static final List<String> _mediumBoards = [
    '916004072800620050500008930060000200000207000005000090097800003080076009450100687',
    '000900082063001409908000000000670300046050290007023000000000701704300620630007000',
    '035670000400829500080003060020005807800206005301700020040900070002487006000052490',
    '030070902470009000009003060024000837007000100351000620040900200000400056708050090',
    '084200000930840000057000000600401700400070002005602009000000980000028047000003210',
    '007861000008003000560090010100070085000345000630010007050020098000600500000537100',
    '040001003000050079560002804100270080082000960030018007306100098470080000800500040',
    '000500006000870302270300081000034900793050614008790000920003057506087000300005000',
    '000900067090000208460078000320094070700603002010780043000850016501000090670009000',
    '024000017000301000300000965201000650000637000093000708539000001000502000840000570',
    '200006143004000600607008029100800200003090800005003001830500902006000400942600005',
    '504002030900073008670000020000030780005709200047060000050000014100450009060300502',
    '580000637000000000603540000090104705010709040807205090000026304000000000468000072',
    '000010000900003408670500021000130780015000240047065000750006014102400009000090000',
    '780300050956000000002065001003400570600000003025008100200590800000000417030004025',
    '200367500500800060300450700090530400080000070003074050001026005030005007002783001',
    '801056200000002381900003000350470000008000100000068037000600002687100000004530806',
    '300004005841753060000010000003000087098107540750000100000070000030281796200300008',
    '000064810040050062009010300003040607008107500704030100006070200430080090017390000',
    '000040320000357080000600400357006040600705003080900675008009000090581000064070000',
    '905040026026050900030600050350000009009020800100000075010009030003080760560070108',
    '010403060030017400200000300070080004092354780500070030003000005008530040050906020',
    '605900100000100073071300005009010004046293510700040600200001730160002000008009401',
    '049060002800210490100040000000035084008102300630470000000080001084051006700020950',
    '067020300003700000920103000402035060300000002010240903000508039000009200008010750',
    '050842001004000900800050040600400019007506800430009002080090006001000400500681090',
    '000076189000002030009813000025000010083000590070000460000365200010700000536120000',
    '080000030400368000350409700000003650003000900078100000004201076000856009060000020',
    '000500748589000001700086900302010580000000000067050204004760002200000867876005000',
    '021009008000004031740100025000007086058000170160800000910008052230900000800300410',
  ];

  static final List<String> _hardBoards = [
    '600300100071620000805001000500870901009000600407069008000200807000086410008003002',
    '906013008058000090030000010060800920003409100049006030090000080010000670400960301',
    '300060250000500103005210486000380500030000040002045000413052700807004000056070004',
    '060001907100007230080000406018002004070040090900100780607000040051600009809300020',
    '600300208400185000000000450000070835030508020958010000069000000000631002304009006',
    '400030090200001600760800001500318000032000510000592008900003045001700006040020003',
    '004090170900070002007204000043000050798406213060000890000709400600040001085030700',
    '680001003007004000000820000870009204040302080203400096000036000000500400700200065',
    '000002000103400005200050401340005090807000304090300017605030009400008702000100000',
    '050702003073480005000050400040000200027090350006000010005030000400068730700109060',
    '500080020007502801002900040024000308000324000306000470090006700703208900060090005',
    '108090000200308096090000400406009030010205060080600201001000040360904007000060305',
    '010008570607050009052170000001003706070000040803700900000017260100020407024300090',
    '020439800080000001003001520050092703000000000309740080071300900600000030008924010',
    '000500201800006005005207080017960804000000000908074610080405300700600009504009000',
    '920000000500870000038091000052930160090000030073064980000410250000053001000000073',
    '590006010001254709000001400003715008100000004200648100002500000708463900050100047',
    '309870004000005008870400000104580003000706000700034105000009081900300000400057206',
    '800200000910300706000007002084000009095104860100000230500600000609003071000005008',
    '005037001000050627600002530020070000001968200000010090013700008486090000700840100',
    '090350700000800029000402008710000000463508297000000051300204000940005000008037040',
    '000005904080090605006000030030701450008040700074206090060000300801060070309800000',
    '030004087948700500060800009010586720000000000087312050800003070003007865570200090',
    '300687015000030082050000300400300000601050709000004003008000020210040000970521004',
    '702000004030702010400093008000827090007030800080956000300570009020309080600000503',
    '300040057400853060025700000000000430800406001034000000000005690090624003160080002',
    '000260050000005900000380046020094018004000500950810070380021000005700000040058000',
    '062080504008050090700320001000740620000203000027065000200036007040070100803090240',
    '002001000068000003000086090900002086804000102520800009080140000100000920000700500',
    '000030065460950200000086004003070006004090100500010300200140000007065028630020000',
  ];

  // static final List<String> _extremeBoards = [
  //   '030000000000007510940000000000000091000526004007010005000300700000400000020000100',
  //   '500000804000060500009145000800002000000000061090000000316000000004000000000000907',
  //   '400018000000000090000000610300050002070800000000100000003086004090000000201000005',
  // ];

  /*
  * Those boards were solved by my BoardSolver class.
  * To eliminate the long loading times of solving Extreme boards.
  * */
  static final List<String> _solvedExtremeBoardsAsJson = [
    '{"hasBeenStartedPlaying": false, "cells":[[{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,0],"availableNumbers":[6,1,9,8,2]},{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,1],"availableNumbers":[6,8,2,5,1,7,3,9,4]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,2],"availableNumbers":[7,3,2,8,5,1]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,3],"availableNumbers":[2,1,4]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,4],"availableNumbers":[3,9]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,5],"availableNumbers":[4]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,6],"availableNumbers":[1,6,5,8,2,7,4,3,9]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,7],"availableNumbers":[8,4]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,8],"availableNumbers":[9,1,4,7,3]}],[{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,0],"availableNumbers":[8,2,4,1,6]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,1],"availableNumbers":[4,8,1,6,5,7]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,2],"availableNumbers":[2]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,3],"availableNumbers":[9,6,3,8]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,4],"availableNumbers":[1,5,9,8,7]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[1,5],"availableNumbers":[9,4,7,5,1,8,2,3,6]},{"number":3,"solutionNumber":3,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[1,6],"availableNumbers":[2,7,1,6,8,3,4,9,5]},{"number":7,"solutionNumber":7,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[1,7],"availableNumbers":[2,6,3,8,5,7,4,9,1]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,8],"availableNumbers":[5,2,8,3,1,9,6,7]}],[{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,0],"availableNumbers":[5,2,1,4,7,3,9,8,6]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,1],"availableNumbers":[1,7,3,8,5,9,2,6,4]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,2],"availableNumbers":[3,8,4]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,3],"availableNumbers":[7,2,3,4,1]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,4],"availableNumbers":[8,2]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,5],"availableNumbers":[5,2,9,1,7]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,6],"availableNumbers":[2,8,5]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,7],"availableNumbers":[4,7,6,2,5,1,8,9,3]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,8],"availableNumbers":[6,4,5,1,9,2,3]}],[{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,0],"availableNumbers":[2,3,4,1,9,5,6,7,8]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,1],"availableNumbers":[3,6,9,5,2,8,7]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,2],"availableNumbers":[4,3,5,2,9,6,8,1,7]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,3],"availableNumbers":[6,8,7,9,5,2,4,1,3]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,4],"availableNumbers":[5,9,6,7,8]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,5],"availableNumbers":[1,5,6,4,7,8]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,6],"availableNumbers":[8,1,4,5]},{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,7],"availableNumbers":[2,4,3,8,6,5,1,9,7]},{"number":7,"solutionNumber":7,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,8],"availableNumbers":[3,6,1,9,2,8,7,4,5]}],[{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,0],"availableNumbers":[7,3,5,6,8,4,9]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,1],"availableNumbers":[9,2,5,8]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,2],"availableNumbers":[5,7,3,9,2,8]},{"number":3,"solutionNumber":3,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,3],"availableNumbers":[2,8,5,1,9,4,7,3,6]},{"number":2,"solutionNumber":2,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,4],"availableNumbers":[4,1,8,9,3,7,6,5,2]},{"number":8,"solutionNumber":8,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,5],"availableNumbers":[9,8,1,6,2,3,7,5,4]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,6],"availableNumbers":[4]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,7],"availableNumbers":[6,8,2,5,9,1,4,7]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,8],"availableNumbers":[8,9,2,1,4,7,3,6,5]}],[{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,0],"availableNumbers":[1,4,2,9,8]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,1],"availableNumbers":[8,9,3,5,7,4,2]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[5,2],"availableNumbers":[1,3,7,5,9,4,6,8,2]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,3],"availableNumbers":[4,2,6,5]},{"number":7,"solutionNumber":7,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[5,4],"availableNumbers":[4,3,7,9,8,6,5,2,1]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,5],"availableNumbers":[9,5,2,1]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,6],"availableNumbers":[5,6,8,4,3,7,9]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,7],"availableNumbers":[2,7,1,6,3]},{"number":3,"solutionNumber":3,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[5,8],"availableNumbers":[4,9,5,8,2,6,3,1,7]}],[{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,0],"availableNumbers":[4,2,8,1,7,9]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,1],"availableNumbers":[7,6,5,3,2,9]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,2],"availableNumbers":[1,7,4,2,5,6,8,3,9]},{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,3],"availableNumbers":[3,9,4,7,6,8,2,5,1]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,4],"availableNumbers":[9,8,6,5,4,3,1,2,7]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,5],"availableNumbers":[2,7,5,9]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,6],"availableNumbers":[9,1,3,7,5,6,2,4,8]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,7],"availableNumbers":[3,6,7]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,8],"availableNumbers":[8,4,3,7,2,1,6,9,5]}],[{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,0],"availableNumbers":[3,7,4,8,1,9,2]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,1],"availableNumbers":[6,5,8,4,3,1]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,2],"availableNumbers":[8,2,4,7,1]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[7,3],"availableNumbers":[7,6,9,8,2,5,3,1,4]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,4],"availableNumbers":[4,1,5,8]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,5],"availableNumbers":[7]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,6],"availableNumbers":[9,8,3,7,1,2,6,4,5]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,7],"availableNumbers":[5,9,8,3,4,6,2,1]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,8],"availableNumbers":[2,6,4,7,8,3,5,9,1]}],[{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,0],"availableNumbers":[5,2]},{"number":2,"solutionNumber":2,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,1],"availableNumbers":[4,5,1,8,2,7,3,9,6]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,2],"availableNumbers":[9,2,4,7,3,6]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,3],"availableNumbers":[8,9,7,2]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,4],"availableNumbers":[6,9,5,8,3,7]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,5],"availableNumbers":[3]},{"number":7,"solutionNumber":7,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,6],"availableNumbers":[4,6,9,8,7,3,2,5,1]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,7],"availableNumbers":[1,3,7]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,8],"availableNumbers":[4,1,8]}]]}',
    '{"hasBeenStartedPlaying": false, "cells":[[{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,0],"availableNumbers":[1,4,6,5,9,2,7,3,8]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,1],"availableNumbers":[6,2,8,4,3]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,2],"availableNumbers":[3,2,9,5,6,8,7]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,3],"availableNumbers":[9,3,4,8]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,4],"availableNumbers":[2,4]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,5],"availableNumbers":[7,9,6,2,1,4]},{"number":8,"solutionNumber":8,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,6],"availableNumbers":[3,4,2,7,1,6,9,8,5]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,7],"availableNumbers":[1,6,4,2,3,7,9,5,8]},{"number":4,"solutionNumber":4,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,8],"availableNumbers":[7,2,3,5,1,9,4,8,6]}],[{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,0],"availableNumbers":[1,7,5,6,8,9]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,1],"availableNumbers":[4,8,6]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,2],"availableNumbers":[2,1,3,9]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,3],"availableNumbers":[8,9,7]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[1,4],"availableNumbers":[1,9,6,4,7,5,3,2,8]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,5],"availableNumbers":[3,2,8,7,1]},{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[1,6],"availableNumbers":[1,8,3,9,7,2,4,6,5]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,7],"availableNumbers":[7]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,8],"availableNumbers":[9,1,4,6,7]}],[{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,0],"availableNumbers":[7,3,5,9,8,4]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,1],"availableNumbers":[8,6,4,5]},{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,2],"availableNumbers":[5,2,1,4,6,9,3,8,7]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,3],"availableNumbers":[2,7,6,9,5,3,8,1,4]},{"number":4,"solutionNumber":4,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,4],"availableNumbers":[2,4,8,6,9,3,7,1,5]},{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,5],"availableNumbers":[8,6,1,7,4,9,2,3,5]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,6],"availableNumbers":[6,9,5,1,2]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,7],"availableNumbers":[2]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,8],"availableNumbers":[3,4,5,7,6,8,9]}],[{"number":8,"solutionNumber":8,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,0],"availableNumbers":[7,4,1,9,2,3,8,5,6]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,1],"availableNumbers":[3,5,8]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,2],"availableNumbers":[1,3]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,3],"availableNumbers":[6,3,1,2,7,9]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,4],"availableNumbers":[7,9]},{"number":2,"solutionNumber":2,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,5],"availableNumbers":[8,3,9,5,1,6,2,7,4]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,6],"availableNumbers":[4,3,7,8]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,7],"availableNumbers":[9,6,4,2,5,3,8]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,8],"availableNumbers":[5,7,1,8,2,6,3,9,4]}],[{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,0],"availableNumbers":[4,2,5]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,1],"availableNumbers":[2,7,8,5,4,9,6,3,1]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,2],"availableNumbers":[7,4,8,9,5,1,6]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,3],"availableNumbers":[5,1,7]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,4],"availableNumbers":[8,2,7,9,4,3,6,5]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,5],"availableNumbers":[9,2,1,4,6,7]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,6],"availableNumbers":[3,6,9,8,7,2,1]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,7],"availableNumbers":[4,1,7,8,5,6,3,9,2]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,8],"availableNumbers":[2,5,9,6,8,3,1,7,4]}],[{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,0],"availableNumbers":[6,1,4,8,9,3,5]},{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[5,1],"availableNumbers":[3,8,5,4,1,2,7,9,6]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,2],"availableNumbers":[5,4,9,6,7,2,1,8,3]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,3],"availableNumbers":[4,8,2,6,9,3,7,1]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,4],"availableNumbers":[3]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,5],"availableNumbers":[1,3,8,9,5,7,2,6]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,6],"availableNumbers":[7,3,1,2,5,8]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,7],"availableNumbers":[8,1,7,3,2,6,4,5]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,8],"availableNumbers":[2,8,3]}],[{"number":3,"solutionNumber":3,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,0],"availableNumbers":[2,3,4,5,8,6,7,1,9]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,1],"availableNumbers":[9,7,8,6,2,1,3,5,4]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,2],"availableNumbers":[4,3,8,7,1,5,9,6,2]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,3],"availableNumbers":[7,5,2,1,6,9]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,4],"availableNumbers":[9,5]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,5],"availableNumbers":[4,3,7,8,1,9,6,2]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,6],"availableNumbers":[2,4,8,9,5,3,1,6,7]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,7],"availableNumbers":[5,2]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,8],"availableNumbers":[8,1,2,9,7,4,6,5,3]}],[{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,0],"availableNumbers":[9,3,8]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,1],"availableNumbers":[7,3,9]},{"number":4,"solutionNumber":4,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[7,2],"availableNumbers":[6,8,9,2,3,1,4,5,7]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,3],"availableNumbers":[2,3,1,7,8,4,9,5]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,4],"availableNumbers":[5,4,1,9,3,8,6,7,2]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,5],"availableNumbers":[8,9,1,2,5,7,4,6,3]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,6],"availableNumbers":[1,9]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,7],"availableNumbers":[3,6,4,5,1,2]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,8],"availableNumbers":[6,9,5,4]}],[{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,0],"availableNumbers":[2,4,8,3,1,6,5,9,7]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,1],"availableNumbers":[5]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,2],"availableNumbers":[8]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,3],"availableNumbers":[3,5,6,4,2,7]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,4],"availableNumbers":[1,5,9]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,5],"availableNumbers":[6,7,5]},{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,6],"availableNumbers":[9,8,2,4,7,1,5,6,3]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,7],"availableNumbers":[4,2]},{"number":7,"solutionNumber":7,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,8],"availableNumbers":[9,6,2,1,3,4,5,8,7]}]]}',
    '{"hasBeenStartedPlaying": false, "cells":[[{"number":4,"solutionNumber":4,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,0],"availableNumbers":[2,3,4,7,1,8,9,5,6]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,1],"availableNumbers":[3,4,2,7,8]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,2],"availableNumbers":[9,6,2,7,3,5,1,8,4]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,3],"availableNumbers":[6,9,1,8,4]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,4],"availableNumbers":[4,1,5,7,2,9,3,6,8]},{"number":8,"solutionNumber":8,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[0,5],"availableNumbers":[1,4,9,3,5,6,2,7,8]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,6],"availableNumbers":[2,3,4]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,7],"availableNumbers":[5,8,1,6,2,3,9,4]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[0,8],"availableNumbers":[7,1]}],[{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,0],"availableNumbers":[1]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,1],"availableNumbers":[2]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,2],"availableNumbers":[6,9,4,3,2]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,3],"availableNumbers":[7,2,9,8,1,3]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,4],"availableNumbers":[3,2,5,4,7]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,5],"availableNumbers":[5,9,3,1,2]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,6],"availableNumbers":[4,7,8,6,9,5,1]},{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[1,7],"availableNumbers":[3,8,9,4,2,6,1,5,7]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[1,8],"availableNumbers":[8,6,4,9]}],[{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,0],"availableNumbers":[5,9,7,2,1,3,4]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,1],"availableNumbers":[8,9,6,3,5,1,4,7]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,2],"availableNumbers":[7,2,3]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,3],"availableNumbers":[2,3,1,7,4,9,6]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,4],"availableNumbers":[9,7,6,4]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,5],"availableNumbers":[4,7,1]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,6],"availableNumbers":[6,5,1,9,7,2,3,8,4]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[2,7],"availableNumbers":[3,9,4,1,2,5,6,8,7]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[2,8],"availableNumbers":[3,1,9,8,5,7]}],[{"number":3,"solutionNumber":3,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,0],"availableNumbers":[2,1,6,9,5,7,4,3,8]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,1],"availableNumbers":[1]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,2],"availableNumbers":[8,4,3]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,3],"availableNumbers":[4,9,3,7,6,2,1,8,5]},{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,4],"availableNumbers":[6,7,8,2,9,5,1,4,3]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,5],"availableNumbers":[9,4,2,3,7,5,6]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,6],"availableNumbers":[7,8,4,6]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[3,7],"availableNumbers":[6,5,3,4]},{"number":2,"solutionNumber":2,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[3,8],"availableNumbers":[9,1,6,5,4,7,2,3,8]}],[{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,0],"availableNumbers":[9,6,8,1,3,7,4,2,5]},{"number":7,"solutionNumber":7,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,1],"availableNumbers":[7,2,9,1,3,6,5,8,4]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,2],"availableNumbers":[2,1,5,6,7]},{"number":8,"solutionNumber":8,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[4,3],"availableNumbers":[9,3,7,4,8,1,5,2,6]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,4],"availableNumbers":[6,7,4,5]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,5],"availableNumbers":[3,1,6,8,9,5,7,2,4]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,6],"availableNumbers":[5,1,8,6,3,4,9,2]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,7],"availableNumbers":[4,2,3,6,8,7,5]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[4,8],"availableNumbers":[1,4,2,7,6,9]}],[{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,0],"availableNumbers":[6,3,1,2,7,8]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,1],"availableNumbers":[4,7,3,2,5,6,9,1,8]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,2],"availableNumbers":[5]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[5,3],"availableNumbers":[2,1,4,8,5,9,7,6,3]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,4],"availableNumbers":[7,3,2,5,4,1]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,5],"availableNumbers":[2,7]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,6],"availableNumbers":[8,4]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,7],"availableNumbers":[3,1,7,8,9,4,2,5]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[5,8],"availableNumbers":[9,5,7,4,6,3]}],[{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,0],"availableNumbers":[7]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,1],"availableNumbers":[5,6,3,4,7]},{"number":3,"solutionNumber":3,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,2],"availableNumbers":[8,1,9,4,5,2,3,6,7]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,3],"availableNumbers":[9,4,2,5,7,6,8,1]},{"number":8,"solutionNumber":8,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,4],"availableNumbers":[1,3,9,6,8,4,5,7,2]},{"number":6,"solutionNumber":6,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,5],"availableNumbers":[9,8,4,5,7,6,2,1,3]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,6],"availableNumbers":[1,3,6,2,8,4,9,7,5]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[6,7],"availableNumbers":[2]},{"number":4,"solutionNumber":4,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[6,8],"availableNumbers":[9,1,6,8,3,5,4,2,7]}],[{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,0],"availableNumbers":[8,5,6,2,1,3,4]},{"number":9,"solutionNumber":9,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[7,1],"availableNumbers":[2,3,4,9,7,5,6,8,1]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,2],"availableNumbers":[4,5,3,9]},{"number":null,"solutionNumber":5,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,3],"availableNumbers":[5,3,9,4,1,6,8]},{"number":null,"solutionNumber":2,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,4],"availableNumbers":[2,9,5,1,8]},{"number":null,"solutionNumber":1,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,5],"availableNumbers":[1,7,4,8,9]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,6],"availableNumbers":[3,5,4,9,8]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,7],"availableNumbers":[7,6,5,3,8,1,2]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[7,8],"availableNumbers":[6]}],[{"number":2,"solutionNumber":2,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,0],"availableNumbers":[5,2,6,8,4,9,1,3,7]},{"number":null,"solutionNumber":6,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,1],"availableNumbers":[6,1,9,3,8,7,4]},{"number":1,"solutionNumber":1,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,2],"availableNumbers":[1,9,5,7,2,4,3,6,8]},{"number":null,"solutionNumber":3,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,3],"availableNumbers":[3]},{"number":null,"solutionNumber":4,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,4],"availableNumbers":[4,1,5,6,9,2,7]},{"number":null,"solutionNumber":7,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,5],"availableNumbers":[7]},{"number":null,"solutionNumber":9,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,6],"availableNumbers":[9,4,2,7,6,3,1]},{"number":null,"solutionNumber":8,"isClickable":true,"isSelected":false,"isHighlighted":false,"coordinates":[8,7],"availableNumbers":[8,1,6,7,3,5,2]},{"number":5,"solutionNumber":5,"isClickable":false,"isSelected":false,"isHighlighted":false,"coordinates":[8,8],"availableNumbers":[4,5,9,1,2,8,3,6,7]}]]}',
  ];
}
