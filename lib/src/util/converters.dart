class Converters {
  static String numberWithCommas(String number) {
    // Get rid of decimals first.
    String numWODecimals = number.substring(0, number.indexOf('.'));

    String newNumber = '';

    if (numWODecimals.length > 3 && numWODecimals.length < 4) {
      newNumber += numWODecimals[0];
      newNumber += ',';
      newNumber += numWODecimals.substring(1);
    } else if (numWODecimals.length >= 4 && numWODecimals.length < 6) {
      newNumber += numWODecimals[0];
      newNumber += numWODecimals[1];
      newNumber += ',';
      newNumber += numWODecimals.substring(2);
    } else if (numWODecimals.length >= 6 && numWODecimals.length < 7) {
      newNumber += numWODecimals[0];
      newNumber += numWODecimals[1];
      newNumber += ', ';
      newNumber += numWODecimals[2];
      newNumber += numWODecimals[3];
      newNumber += numWODecimals[4];
      newNumber += ', ';
      newNumber += numWODecimals.substring(5);
    }

    // Add back the decimals.
    newNumber += number.substring(number.indexOf('.'));
    return newNumber;
  }
}
