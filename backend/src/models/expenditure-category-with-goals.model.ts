/// Module for the expenditureCategoryWithGoals model.


import { validMoney, validPositiveInteger, validMongoID } from '../validifier';
import { errorCodes } from '../types';
import * as kleen from "kleen";


/**
 * Specifically designed for the POST request when the user has already picked
 * the names of the categories but now needs to pick goalSpending and
 * perNumberOfDays.
 */
const expenditureCategoryWithGoalType: kleen.objectStructure = {
  kindOfType: kleen.kindOfType.object,
  properties: {
    "id": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.number,
      customErrorOnTypeFailure: {
        message: "The id field must be number!",
        errorCode: errorCodes.invalidCategoriesWithGoals
      }
    },
    "name": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The name field must be a string",
        errorCode: errorCodes.invalidCategoriesWithGoals
      }
    },
    "goalSpending": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "Goal spending ",
        errorCode: errorCodes.invalidCategoriesWithGoals
      },
      restriction: (goalSpending: string) => {
        if(!validMoney(goalSpending) || goalSpending.charAt(0) == "-") {
          return Promise.reject({
            message: "Goal Spending must be valid positive money, eg. 2 or 2.32",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    },
    "perNumberOfDays": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The perNumberOfDays field must be a string",
        errorCode: errorCodes.invalidCategoriesWithGoals
      },
      restriction: (perNumberOfDays: string) => {
        if(!validPositiveInteger(perNumberOfDays)) {
          return Promise.reject({
            message: "perNumberOfDays must be a positive integer.",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    },
    "colorID": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The colorID field must be a string",
        errorCode: errorCodes.invalidCategoriesWithGoals
      },
      restriction: (colorID: string) => {
        if(!validMongoID(colorID)) {
          return Promise.reject({
            message: "colorID must be a valid mongo ID",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    }
  },
  customErrorOnTypeFailure: {
    errorCode: errorCodes.invalidCategoriesWithGoals,
    message: "Category cannot be null/undefined"
  }
}


/**
 * The array helper type.
 */
const arrayOfExpenditureCategoryWithGoalType: kleen.arrayStructure = {
  kindOfType: kleen.kindOfType.array,
  elementType: expenditureCategoryWithGoalType,
  customErrorOnTypeFailure: {
    message: "Array of categories cannot be null/undefined",
    errorCode: errorCodes.invalidCategoriesWithGoals
  }
}


/**
 * Validifies a `arrayOfExpenditureCategoryWithGoalType`.
 */
export const validExpenditureCategoryWithGoalsArray =
  kleen.validModel(arrayOfExpenditureCategoryWithGoalType);
