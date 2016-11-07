/// Module for all typings specific to the app.

import { Handler } from "express";


/**
 * A mongo unique id.
 */
type mongoID = string;


/**
 * IDs created on the frontend, I'm going to try out just using the index in
 * the list as the ID with basic incrementing.
 */
type frontendID = number;


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
 * An expenditure made by the user.
 */
export interface expenditure {
  id: frontendID;
  date: Date;
  categoryID: frontendID;
  cost: number;
}


/**
 * An expenditure category.
 */
export interface expenditureCategory {
  _id?: mongoID;
  name: string;
}


/**
 * A category and it's respective goal.
 */
export type expenditureCategoryWithGoals = {
  id: frontendID;
  name: string;
  colorID: mongoID;
  goalSpending?: string;
  perNumberOfDays?: string;
};


/**
 * An employer that pays a user.
 */
export interface employer {
  id: number;
  name: string;
}


/**
 * The user will input when they recieve money, this seems easiest.
 */
export interface earning {
  id: number;
  date: Date;
  amount: number;
  fromEmployerID: number;
}


/**
 * A `user`.
 */
export interface user {
  _id?: mongoID;
  email: string;
  password?: string;
  currentBalance?: number;
  categoriesWithGoals?: expenditureCategoryWithGoals[];
  expenditures?: expenditure[];
  earnings?: earning[];
  employers?: employer[];
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


/**
 * The error we always send to the frontend.
 */
export interface frontendError {
  message: String;
  errorCode: errorCodes;
}
