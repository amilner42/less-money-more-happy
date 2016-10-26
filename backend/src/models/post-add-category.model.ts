/// Module for `PostAddCategory`s, which are categories being sent from the
/// frontend, we add these categories and their goals to the users list.

import { structures, errorCodes } from '../types';
import { isNullOrUndefined } from '../util';
import {
  validPositiveInteger,
  validMoney,
  validNotJustSpacesString } from '../validifier';
import { collection } from '../db';


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
export const postAddCategoryType: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "newName": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (newName: string) => {
        if(isNullOrUndefined(newName)) {
          return Promise.reject({
            message: "category.newName cannot be null/undefined",
            errorCode: errorCodes.invalidAddCategory
          });
        }

        if(!validNotJustSpacesString(newName)) {
          return Promise.reject({
            message: "category.newName cannot be just spaces",
            errorCode: errorCodes.invalidAddCategory
          });
        }
      }
    },
    "newPerNumberOfDays": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (newPerNumberOfDays: string) => {
        if(isNullOrUndefined(newPerNumberOfDays)) {
          return Promise.reject({
            message: "category.newPerNumberOfDays cannot be null/undefined",
            errorCode: errorCodes.invalidAddCategory
          });
        }

        if(!validPositiveInteger(newPerNumberOfDays)) {
          return Promise.reject({
            message: "category.newPerNumberOfDays must be a positive integer",
            errorCode: errorCodes.invalidAddCategory
          });
        }
      }
    },
    "newGoalSpending": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (newGoalSpending: string) => {
        if(isNullOrUndefined(newGoalSpending)) {
          return Promise.reject({
            message: "category.newGoalSpending cannot be null/undefined",
            errorCode: errorCodes.invalidAddCategory
          });
        }

        if(!validMoney(newGoalSpending) || newGoalSpending.charAt(0) == "-") {
          return Promise.reject({
            message: "category.newGoalSpending must be valid positive money, eg. 2 or 2.32",
            errorCode: errorCodes.invalidAddCategory
          });
        }
      }
    }
  },
  restriction: (postAddCategory: postAddCategory) => {
    if(isNullOrUndefined(postAddCategory)) {
      return Promise.reject({
        message: "Category cannot be null/undefined",
        errorCode: errorCodes.invalidAddCategory
      });
    }
  }
}
