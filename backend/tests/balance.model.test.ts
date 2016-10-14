/// <reference path="../typings_manual/index.d.ts" />


import assert from "assert";

import { validBalance } from '../src/models/';


describe('Balance Model', function() {

  describe('#validBalance', function() {

    it('shoud return false for invalid balances', function () {
      const invalidBalances = [
        "",
        "-",
        "3430.34.",
        "34343a",
        "-b",
        "2323b232",
        "a3223.2",
        "a",
        ".",
        ".23",
        "3.232222",
        undefined,
        null
      ];

      invalidBalances.map((balance) => {
        if(validBalance(balance)) {
          assert.fail("Valid balance (but shouldn't be): " + balance);
        }
      });
    });

    it('should return true for valid balances', function () {
      const validBalances = [
        "2",
        "23423412341",
        "23232.",
        "232332.2",
        "232322.23",
        "-23",
        "-2",
        "-232.32"
      ];

      validBalances.map((balance) => {
        if(!validBalance(balance)) {
          assert.fail("Not a valid balance (but should be): " + balance);
        }
      });
    });
  });
});
