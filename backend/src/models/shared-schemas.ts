/// Module for schemas that are shared accross multiple models.

import * as kleen from "kleen";
import {
  validMongoID,
  validPositiveInteger,
  validNotJustSpacesString,
  validMoney } from "../validifier";
import { errorCodes } from "../types";

/**
 * A mongo id schema, will error with `error`.
 */
export const mongoIDSchema = (error: any): kleen.primitiveSchema => {
  return {
    primitiveType: kleen.kindOfPrimitive.string,
    typeFailureError: error,
    restriction: (mongoID: string) => {
      if(!validMongoID(mongoID)) {
        Promise.reject(error);
      }
    }
  }
};


/**
 * An optional mongo id schema, will error with `error`.
 */
export const optionaMongoIDSchema = (error: any): kleen.referenceSchema => {
  return {
    referenceName: "mongoID",
    withContext: () => {
      return {
        "mongoID": mongoIDSchema(error)
      }
    },
    undefinedAllowed: true
  }
};


/**
 * A frontend ID.
 */
export const frontendIDSchema = (error: any): kleen.primitiveSchema => {
  return {
    primitiveType: kleen.kindOfPrimitive.number,
    typeFailureError: error
  }
};


/**
 * An optional frontend ID.
 */
export const optionalFrontendIDSchema = (error: any): kleen.referenceSchema => {
  return {
    referenceName: "frontendID",
    withContext: () => {
      return {
        "frontendID": frontendIDSchema(error)
      }
    },
    undefinedAllowed: true
  }
};


/**
 * A name schema.
 *
 * Cannot be just spaces.
 */
export const nameSchema = (error: any): kleen.primitiveSchema => {
  return {
    primitiveType: kleen.kindOfPrimitive.string,
    typeFailureError: error,
    restriction: (newName: string) => {
      if(!validNotJustSpacesString(newName)) {
        return Promise.reject(error);
      }
    }
  }
};


/**
 * A string representing a positive amount of money (0 inclusive).
 */
export const stringPositiveMoneySchema = (error: any): kleen.primitiveSchema => {
  return {
    primitiveType: kleen.kindOfPrimitive.string,
    typeFailureError: error,
    restriction: (goalSpending: string) => {
      if(!validMoney(goalSpending) || goalSpending.charAt(0) == "-") {
        return Promise.reject(error);
      }
    }
  }
};


/**
 * A string representing a positive integer (0 exclusive).
 */
export const stringPositiveIntegerSchema = (error: any): kleen.primitiveSchema => {
  return {
    primitiveType: kleen.kindOfPrimitive.string,
    typeFailureError: error,
    restriction: (perNumberOfDays: string) => {
      if(!validPositiveInteger(perNumberOfDays)) {
        return Promise.reject(error);
      }
    }
  }
};


/**
 * A number representing a positive integer.
 */
export const positiveIntegerSchema = (error: any): kleen.primitiveSchema => {
  return {
    primitiveType: kleen.kindOfPrimitive.number,
    typeFailureError: error,
    restriction: (aNumber: number): Promise<void> => {
      const numberAsString = aNumber.toString();
      return kleen.validModel(stringPositiveIntegerSchema(error))(numberAsString);
    }
  }
};
