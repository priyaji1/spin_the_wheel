import 'package:integration_test/integration_test_driver.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:math';

void main() {
  group('Spin-the-Wheel Logic', () {
    test('Calculates correct factor and target for random luckyIndex with itemsLength = 7', () {
      // Given: Number of segments on the wheel
      int itemsLength = 7;

      for (int i = 0; i < 100; i++) { //We loop 100 times to cover multiple random cases.
        // Simulate the random luckyIndex generation
        int rdm = Random().nextInt(6); // Generates a value between 0 and 5
        int luckyIndex = rdm + 1; // Adjusts to a range between 1 and 6

        // Calculate the factor and target based on the luckyIndex
        int factor = luckyIndex % itemsLength;
        if (factor == 0) factor = itemsLength;
        double spinInterval = 1 / itemsLength;
        double target = 1 - ((spinInterval * factor) - (spinInterval / 2));

        // Validate the factor is within the expected range
        expect(factor, inInclusiveRange(1, itemsLength));

        // Calculate the expected target based on the factor
        double expectedTarget = 1 - ((spinInterval * factor) - (spinInterval / 2));

        // Validate that the calculated target matches the expected target compare two floating-point numbers
        expect(target, moreOrLessEquals(expectedTarget, epsilon: 1e-6));
      }
    });
  });
}

