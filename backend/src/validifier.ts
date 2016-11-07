/// Module for encapsulating all validation logic and helpers.

import { isNullOrUndefined } from './util';


/**
 * Regex for superficially valid phone number.
 *
 * @credit: http://stackoverflow.com/questions/6478875/regular-expression-matching-e-164-formatted-phone-numbers
 */
export const validPhone = (phoneNumber: string) => /^\+?[1-9]\d{1,14}$/.test(phoneNumber);

/**
 * Regex for superficially valid email.
 *
 * @credit: http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
 */
export const validEmail = (email: string) => /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(email);


/**
 * Checks that a balance is valid. Refer to tests to see what is currently
 * considered valid.
 */
export const validMoney = (balance: string): boolean => {

  const regex = /^-?\d+(\.\d{0,2})?$/;

  return regex.test(balance);
}


/**
 * Checks that a string is a valid positive integer, not including zero.
 */
export const validPositiveInteger = (positiveInteger: string): boolean => {

  const regex = /^[1-9]\d*$/;

  return regex.test(positiveInteger);
}


/**
 * Checks that a string is not null/undefined and has at least one non space.
 */
export const validNotJustSpacesString = (someString: string): boolean => {
  if(isNullOrUndefined(someString)) {
    return false;
  }

  const regex = /\S/;

  return regex.test(someString);
}


/**
 * Checks that a password is considered "strong" enough.
 *
 * Currently we only require 6-char passwords.
 */
export const validPassword = (password: string) => {
  return !(isNullOrUndefined(password)) && (password.length > 6);
}

/**
 * Checks if an id is a valid mongo ID.
 *
 * Currently only checking 24 hex chars.
 */
export const validMongoID = (id: string = ""): boolean => {
  return /^[0-9a-fA-F]{24}$/.test(id);
}
