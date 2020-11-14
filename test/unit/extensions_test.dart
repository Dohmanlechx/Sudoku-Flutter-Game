import 'package:sudoku_game/providers/game_provider.dart';
import 'package:sudoku_game/util/extensions.dart';
import 'package:test/test.dart';

void main() {
  test('Difficulty Easy enum to String', () {
    const easyEnum = Difficulty.easy;
    const expected = 'easy';
    final actual = easyEnum.asString();

    expect(actual, expected);
  });

  test('Difficulty Medium enum to String', () {
    const mediumEnum = Difficulty.medium;
    const expected = 'medium';
    final actual = mediumEnum.asString();

    expect(actual, expected);
  });

  test('Difficulty Hard enum to String', () {
    const hardEnum = Difficulty.hard;
    const expected = 'hard';
    final actual = hardEnum.asString();

    expect(actual, expected);
  });

  test('String Easy to Difficulty Easy enum', () {
    const easyString = 'easy';
    const expected = Difficulty.easy;
    final actual = easyString.toDifficultyEnum();

    expect(actual, expected);
  });

  test('String Medium to Difficulty Medium enum', () {
    const mediumString = 'medium';
    const expected = Difficulty.medium;
    final actual = mediumString.toDifficultyEnum();

    expect(actual, expected);
  });

  test('String Hard to Difficulty Hard enum', () {
    const hardString = 'hard';
    const expected = Difficulty.hard;
    final actual = hardString.toDifficultyEnum();

    expect(actual, expected);
  });
}
