/// Module for `PostAddCategory`s, which are categories being sent from the
/// frontend, we add these categories and their goals to the users list.

import { errorCodes } from '../types';
import {
  validPositiveInteger,
  validMoney,
  validNotJustSpacesString } from '../validifier';
import { collection } from '../db';
import * as kleen from "kleen";


/**
 * A `PostAddCategory` is the format for adding a new category.
 */
export type postAddCategory = {
  newName: string,
  newPerNumberOfDays: string,
  newGoalSpending: string
};


/**
 * `PostAddCategory` type. is the format for adding category.
 */
export const postAddCategoryType: kleen.objectSchema = {
  typeFailureError: {
    message: "Category must be an exact category!",
    errorCode: errorCodes.invalidAddCategory
  },
  objectProperties: {
    "newName": {
      primitiveType: kleen.kindOfPrimitive.string,
      typeFailureError: {
        message: "The newName field must be a string",
        errorCode: errorCodes.invalidAddCategory
      },
      restriction: (newName: string) => {
        if(!validNotJustSpacesString(newName)) {
          return Promise.reject({
            message: "The newName field cannot be just spaces",
            errorCode: errorCodes.invalidAddCategory
          });
        }
      }
    },
    "newPerNumberOfDays": {
      primitiveType: kleen.kindOfPrimitive.string,
      typeFailureError: {
        message: "The newPerNumberOfDays field must be a string",
        errorCode: errorCodes.invalidAddCategory
      },
      restriction: (newPerNumberOfDays: string) => {
        if(!validPositiveInteger(newPerNumberOfDays)) {
          return Promise.reject({
            message: "The newPerNumberOfDays field must represent a positive integer",
            errorCode: errorCodes.invalidAddCategory
          });
        }
      }
    },
    "newGoalSpending": {
      primitiveType: kleen.kindOfPrimitive.string,
      typeFailureError: {
        message: "The newGoalSpending field must be a string",
        errorCode: errorCodes.invalidAddCategory
      },
      restriction: (newGoalSpending: string) => {
        if(!validMoney(newGoalSpending) || newGoalSpending.charAt(0) == "-") {
          return Promise.reject({
            message: "The newGoalSpending field must represent positive money, eg. 2 or 2.32",
            errorCode: errorCodes.invalidAddCategory
          });
        }
      }
    }
  }
}


/**
 * Validifies a `postAddCategoryType`.
 */
export const validPostAddCategory = kleen.validModel(postAddCategoryType);
