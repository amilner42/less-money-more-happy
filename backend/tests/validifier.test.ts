/// <reference path="../typings_manual/index.d.ts" />

import assert from 'assert';
import R from "ramda";

import {
  validPhone,
  validEmail,
  validPassword,
  validMongoID,
  validMoney,
  validPositiveInteger,
  validNotJustSpacesString } from '../src/validifier';


describe('Validifier', function() {

  describe('#validPhone', function() {

    it('should return false if the email is undefined', function() {
      assert.equal(false, validPhone(undefined));
    });

    it('should return false if the email is null', function() {
      assert.equal(false, validPhone(null));
    });

    it('should return false if the phone number contains a char', function() {
      assert.equal(false, validPhone("604343a232"));
    });

    it('should return false if the phone number is 1 char', function() {
      assert.equal(false, validPhone("1"));
    });

    it('should return true if a valid phone number is passed', function() {
      const validPhoneNumbers = ["6049822922", "23222", "123456789012345"];

      R.map((validPhoneNumber) => {
        assert.equal(true, validPhone(validPhoneNumber));
      }, validPhoneNumbers);
    });

    it('should return false if a phone number is longer than 15 chars', function() {
      assert.equal(false, validPhone("1234567890123456"));
    });
  });

  describe('#validEmail', function() {

    it('should return false if the email is undefined', function() {
      assert.equal(false, validEmail(undefined));
    });

    it('should return false if the email is null', function() {
      assert.equal(false, validEmail(null));
    });

    it('should return false if the email has no @', function() {
      const invalidEmails = ["asdf", "asdf.gmail.com", "asdfATgmail.com"];

      R.map((email) => {
        assert.equal(false, validEmail(email));
      }, invalidEmails);
    });

    it('should return false if the email ends with an @', function() {
      const invalidEmail = "bla@";

      assert.equal(false, validEmail(invalidEmail));
    });

    it('should return false if the email starts with an @', function() {
      const invalidEmail = "@gmail.com";

      assert.equal(false, validEmail(invalidEmail));
    });

    it('should return true for valid emails', function() {
      const validEmails = ["bla@gmail.com", "bilbo@yahoo.ca", "what_what@b.ca"];

      R.map((email) => {
        assert.equal(true, validEmail(email));
      }, validEmails);
    });
  });

  describe('#validPassword', function() {

    it('should return false if the password is undefined', function() {
      assert.equal(false, validPassword(undefined));
    });

    it('should return false if the password is null', function() {
      assert.equal(false, validPassword(null));
    });

    it('should return false if the password is <= 6 chars', function() {
      assert.equal(false, validPassword("123456"));
    });
  });

  describe('#validMoney', function() {

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
        if(validMoney(balance)) {
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
        if(!validMoney(balance)) {
          assert.fail("Not a valid balance (but should be): " + balance);
        }
      });
    });
  });

  describe('#validPositiveInteger', function() {

    it('should return false for invalid positive integers', function() {
      const invalidPositiveIntegers: string[] = [
        null,
        undefined,
        "-3",
        "3.2",
        "0",
        "asdf",
        "23as"
      ];

      invalidPositiveIntegers.map((invalidPositiveInteger) => {
        if(validPositiveInteger(invalidPositiveInteger)) {
          assert.fail("Valid positive integer (but shouldn't be): " + invalidPositiveInteger);
        }
      });
    });

    it('should return true for valid positive integers', function() {
      const validPositiveIntegers = [
        "12",
        "2323222",
        "54",
        "2"
      ];

      validPositiveIntegers.map((aValidPositiveInteger) => {
        if(!validPositiveInteger(aValidPositiveInteger)) {
          assert.fail("Invalid positive integer (but shouldn't be): " + aValidPositiveInteger);
        }
      });
    });
  });

  describe('#validNotJustSpacesString', function() {

    it('should return false for invalid strings', function() {
      const invalidStrings = [null, undefined, "", " ", "      ", "     " ];

      invalidStrings.map((invalidString) => {
        if(validNotJustSpacesString(invalidString)) {
          assert.fail("Valid string (but shouldn't be): " + invalidString);
        }
      });
    });

    it('should return true for valid strings', function() {
      const validStrings = ["a", "basdfasdf ", "    a    ", "    _" ];

      validStrings.map((validString) => {
        if(!validNotJustSpacesString(validString)) {
          assert.fail("Invalid string (but shouldn't be): " + validString);
        }
      });
    });
  });

  describe('#validMongoID', function() {

    it('should return false if the ID is undefined', function() {
      assert.equal(false, validMongoID(undefined));
    });

    it('should return false if the ID is null', function() {
      assert.equal(false, validMongoID(null));
    });

    it('should return false if the ID is not 24 hex chars', function() {
      const invalidMongoIDs = ["23", "12345678901234567890123-", "12345678901234567890123G"];

      R.map((invalidMongoID) => {
        assert.equal(false, validMongoID(invalidMongoID));
      }, invalidMongoIDs);
    });

    it('should return true if the ID is 24 hex chars ', function() {
      const validMongoIDs = ["123456789012345678901234", "12a456F890a2345d78901234"];

      R.map((aValidMongoID) => {
        assert.equal(true, validMongoID(aValidMongoID));
      }, validMongoIDs);
    });
  });
});
