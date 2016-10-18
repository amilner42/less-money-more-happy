/// Module for the expenditureCategoryWithGoals model.


import { validModel, validMoney, validPositiveInteger, validMongoID } from '../validifier';
import { structures, errorCodes } from '../types';

import { isNullOrUndefined } from '../util';


/**
 * Specifically designed for the POST request when the user has already picked
 * the names of the categories but now needs to pick goalSpending and
 * perNumberOfDays.
 */
const expenditureCategoryWithGoalType: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "id": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.number,
      restriction: (id: number) => {
        if(isNullOrUndefined(id)) {
          return Promise.reject({
            message: "ID cannot be null/undefined.",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }
      }
    },
    "name": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (name: string) => {
        if(isNullOrUndefined(name)) {
          return Promise.reject({
            message: "name cannot be null/undefined",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }
      }
    },
    "goalSpending": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (goalSpending: string) => {
        if(isNullOrUndefined(goalSpending)) {
          return Promise.reject({
            message: "Goal spending cannot be null/undefined",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }

        if(!validMoney(goalSpending) || goalSpending.charAt(0) == "-") {
          return Promise.reject({
            message: "Goal Spending must be valid positive money, eg. 2 or 2.32",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    },
    "perNumberOfDays": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (perNumberOfDays: string) => {
        if(isNullOrUndefined(perNumberOfDays)) {
          return Promise.reject({
            message: "perNumberOfDays cannot be null/undefined",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }

        if(!validPositiveInteger(perNumberOfDays)) {
          return Promise.reject({
            message: "perNumberOfDays must be a positive integer.",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    },
    "colorID": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (colorID: string) => {
        if(isNullOrUndefined(colorID)) {
          return Promise.reject({
            message: "colorID cannot be null/undefined",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }

        if(!validMongoID(colorID)) {
          return Promise.reject({
            message: "colorID must be a valid mongo ID",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    }
  },
  restriction: (model) => {
    if(isNullOrUndefined(model)) {
      return Promise.reject({
        errorCode: errorCodes.invalidCategoriesWithGoals,
        message: "Category cannot be null/undefined."
      });
    }
  }
}


/**
 * The array helper type.
 */
const arrayOfExpenditureCategoryWithGoalType: structures.arrayStructure = {
  typeCategory: structures.typeCategory.array,
  type: expenditureCategoryWithGoalType,
  restriction: (array) => {
    if(isNullOrUndefined(array)) {
      return Promise.reject({
        message: "Array of categories cannot be null/undefined",
        errorCode: errorCodes.invalidCategoriesWithGoals
      });
    }
  }
}


/**
 * Checks if an array of expenditure categories with goals are valid.
 */
export const validExpenditureCategoryWithGoalsArray = (obj): Promise<void> => {
  return validModel(obj, arrayOfExpenditureCategoryWithGoalType);
}
