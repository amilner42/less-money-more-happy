/// Module for all typings specific to the app.

import { Handler } from "express";


/**
 * A mongo unique id.
 */
export type mongoID = string;


/**
 * IDs created on the frontend, I'm going to try out just using the index in
 * the list as the ID with basic incrementing.
 */
 export type frontendID = number;


/**
 * Format of the application's routes.
 */
export interface appRoutes {
  [routeUrl: string]: {
    [methodType: string]: Handler;
  }
}


/**
 * A color.
 */
export interface color {
  _id?: mongoID;
  name: String;
  hex: String;
  defaultColor: boolean;
  dark: boolean;
}


/**
 * A user earning.
 */
export interface earning {
  id: frontendID;
  date: Date;
  amount: number;
  fromEmployerID: frontendID;
}


/**
 * A user employer.
 */
export interface employer {
  id: frontendID;
  name: string;
}


/**
 * An expenditure made by the user.
 */
export interface expenditure {
  id: frontendID;
  date: Date;
  categoryID: frontendID;
  cost: number;
}


/**
 * A `balance`.
 */
export interface balance {
  balance: String; // string but value should be a float (money).
}


/**
 * All models (in `/models`) should export an implementation of this
 * interface.
 */
export interface model<T> {

  /**
   * Unique name, should be identical to the name of interface `T`.
   */
  name: string;

  /**
   * Prior to responding to an HTTP request with a model, this method should
   * be called to strip sensitive data, eg you don't wanna be sending the
   * user his data with the password attached.
   */
  stripSensitiveDataForResponse: (model: T) => T;
}

/**
 * All errorCodes for simpler programmatic communication between the client and
 * server.
 *
 * NOTE An identical enum should be kept on the frontend/backend.
 */
export enum errorCodes {
  youAreUnauthorized = 1,
  emailAddressAlreadyRegistered,
  noAccountExistsForEmail,
  incorrectPasswordForEmail,
  phoneNumberAlreadyTaken,
  invalidMongoID,
  invalidEmail,
  invalidPassword,
  modelHasInvalidTypeStructure,     // This implies that the API was queried direclty with an incorrectly formed object.
  internalError,                    // For errors that are not handleable
  modelUnionTypeHasMultipleErrors,
  passwordDoesNotMatchConfirmPassword,
  invalidBalance,
  invalidCategories,
  invalidCategoriesWithGoals,
  invalidExpenditure,
  invalidEarning,
  invalidEmployer,
  invalidUpdateCategory,
  invalidAddCategory
}
