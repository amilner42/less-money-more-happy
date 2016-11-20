/// Module for all `passport-local` authentication strategies.

import Bluebird from 'bluebird';
import { compareSync, genSaltSync, hashSync } from 'bcryptjs';
import { Strategy } from 'passport-local';

import { collection } from './db';
import { validEmail, validPassword } from './validifier';
import { errorCodes, user } from './types';
import { isNullOrUndefined } from './util';
import { InvalidModelError } from './errors';
import * as kleen from "kleen";


/**
 * Passport default username field is "username", we use "email".
 */
const usernameField = "email";


/**
 * Creates a default user from a login/register "basic user".
 */
const defaultUser = (basicUser: {email: string, password: string}): user => {
  // Null instead of empty lists because null lets us now this is a new user.
  // Perhaps for new users we want to display extra help.
  return {
    email: basicUser.email,
    password: basicUser.password,
    categoriesWithGoals: null,
    expenditures: null,
    earnings: null,
    employers: null,
    currentBalance: null
  }
};


/**
 * Check if a password is correct for a user.
 *
 * @param user User in database
 * @param password Password for user (string)
 * @return boolean, true if correct
 */
const correctPassword = (user, password) => {
  return compareSync(password, user.password);
};


/**
 * Register a new user.
 *
 * @required email Email does not exist
 * @param email Unique email for user
 * @param password Password for user
 * @return Promise for the user
 */
const register = (email, password): Promise<user> => {
  const salt = genSaltSync(10);
  const passwordAsHash = hashSync(password, salt);
  const user: user = defaultUser({
    email: email,
    password: passwordAsHash
  });

  return collection('users')
  .then((Users) => Users.save(user))
  .then(() => user);
};


/**
 * Standard login strategy, rejects with approprite error code if needed.
 */
export const loginStrategy: Strategy = new Strategy({ usernameField }, (email, password, next) => {

  let retrievedUser: user; // to avoid multiple queries to db for the user.

  /**
   * The user login structure.
   */
  const userLoginStructure: kleen.objectSchema = {
    objectProperties: {
      email: {
        primitiveType: kleen.kindOfPrimitive.string,
        restriction: (email: string) => {
          if(isNullOrUndefined(email)) {
            return Promise.reject(new InvalidModelError(
              "Email cannot be null or undefined",
              errorCodes.noAccountExistsForEmail
            ));
          }
        }
      },
      password: {
        primitiveType: kleen.kindOfPrimitive.string,
        restriction: (password: string) => {
          if(isNullOrUndefined(password)) {
            return Promise.reject(new InvalidModelError(
              "Password cannot be null or undefined",
              errorCodes.incorrectPasswordForEmail
            ));
          }
        }
      }
    },
    restriction: (user: {email: string, password: string}) => {

      if(isNullOrUndefined(user)) {
        return Promise.reject(new InvalidModelError(
          "Attempting to login with an undefined object",
          errorCodes.internalError
        ));
      }

      return new Promise<void>((resolve, reject) => {

        user.email = user.email.toLowerCase();

        return collection('users')
        .then((Users) => {
          return Users.findOne({ email: user.email });
        })
        .then((userInDB) => {
          if(!userInDB) {
            reject(new InvalidModelError(
              "No account exists for that email address",
              errorCodes.noAccountExistsForEmail
            ));
          }

          return userInDB;
        })
        .then((userInDB) => {
          if(!correctPassword(userInDB, user.password)) {
            reject(new InvalidModelError(
              "Incorrect password for that email address",
              errorCodes.incorrectPasswordForEmail
            ));
          }
          retrievedUser = userInDB; // save the user to outer block scope
          resolve();
        });
      });
    }
  };

  kleen.validModel(userLoginStructure)({email, password})
  .then(() => {
    return next(null, retrievedUser);
  })
  .catch((err) => {
    // custom error
    if(err.errorCode) {
      return next(null, false, err);
    }
    // internal error
    return next(err);
  });
});


/**
 * Standard sign-up strategy, rejects with approprite error code if needed.
 */
export const signUpStrategy: Strategy = new Strategy({ usernameField }, (email, password, next) => {

  /**
   * The user signup structure.
   */
  const userSignUpStructure: kleen.objectSchema = {
    objectProperties: {
      email: {
        primitiveType: kleen.kindOfPrimitive.string,
        restriction: (email: string) => {
          return new Promise<void>((resolve, reject) => {
            // All emails are stored in lower case.
            if(!isNullOrUndefined(email)) {
              email = email.toLowerCase();
            }

            if(!validEmail(email)) {
              reject(new InvalidModelError(
                "Invalid email",
                errorCodes.invalidEmail
              ));
              return;
            }

            return collection('users')
            .then((Users) => {
              return Users.findOne({ email });
            })
            .then((user) => {
              if(user) {
                reject(new InvalidModelError(
                  "Email address already registered",
                  errorCodes.emailAddressAlreadyRegistered
                ));
                return;
              }

              resolve();
              return;
            });
          });
        }
      },
      password: {
        primitiveType: kleen.kindOfPrimitive.string,
        restriction: (password: string) => {
          if(!validPassword(password)) {
            return Promise.reject(new InvalidModelError(
              'Password not strong enough',
              errorCodes.invalidPassword
            ));
          }
        }
      }
    },
    restriction: (user) => {

      if(isNullOrUndefined(user)) {
        return Promise.reject(new InvalidModelError(
          "Attempting to sign up with an undefined object",
          errorCodes.internalError
        ));
      }
    }
  };

  return kleen.validModel(userSignUpStructure)({ email, password })
  .then(() => {
    return register(email, password);
  })
  .then((user) => {
    return next(null, user);
  })
  .catch((err) => {
    // custom error.
    if(err.errorCode) {
      return next(null, false, err);
    }
    // internal error
    return next(err);
  });
});
