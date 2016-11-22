/// Module for implementing useful utilities.

import { errorCodes } from "./types";
import { validFrontendError } from './models/frontend-error.model';
import { frontendError } from './models/';

/**
 * Returns true if `thing` is null or undefined.
 */
export const isNullOrUndefined: isNullOrUndefined = (thing: any) => {
  return (thing == null || thing == undefined);
}


/**
 * Checks if error is of the correct format, if not it wraps it in an
 * `internalError`, this makes our code more reliable.
 *
 * This swallows all errors so it should never need a `.catch` branch.
 */
export const prepareErrorForFrontend = (error: frontendError): Promise<frontendError> => {
  return validFrontendError(error)
  .then(() => {
    return Promise.resolve(error);
  })
  .catch(() => {
    return Promise.resolve({
      message: "An unknown internal error occured...",
      errorCode: errorCodes.internalError
    });
  });
}


/**
 * Turns the '_id' field to 'mongoID', the frontend can't have an `_`.
 */
export const renameMongoIDField = (mongoObject: { _id?: string, mongoID?: string}) => {
  mongoObject.mongoID = mongoObject._id;
  delete mongoObject._id;
  return mongoObject;
}


/**
 * Rounds a number so it has `xDecimalPlaces` decimal places.
 */
export const roundNumber = (num: number, xDecimalPlaces: number): number => {
  const baseTenMultiplier = Math.pow(10,xDecimalPlaces);
  const result = Math.round(num*baseTenMultiplier)/baseTenMultiplier;
  return result;
}
