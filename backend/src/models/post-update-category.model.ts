/// Module for `PostUpdateCategory`s, which is sent on post requests from the
/// frontend to update the goals for a single category.

import { errorCodes } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from 'kleen';


/**
 * A `PostUpdateCategory` must have:
 *  - `categoryID` of category we are updating
 *  - `newGoalSpending`
 *  - `newPerNumberOfDays`
 */
export const postUpdateCategoryType: kleen.objectStructure = {
  kindOfType: kleen.kindOfType.object,
  customErrorOnTypeFailure: {
    message: "PostUpdateCategory must be an exact postUpdateCategory",
    errorCode: errorCodes.invalidUpdateCategory
  },
  properties: {
    "categoryID": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.number,
      customErrorOnTypeFailure: {
        message: "The categoryID field must be a number",
        errorCode: errorCodes.invalidUpdateCategory
      }
    },
    "newGoalSpending": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The newGoalSpending field must be a string",
        errorCode: errorCodes.invalidUpdateCategory
      },
      restriction: (newGoalSpending) => {
        if(!validMoney(newGoalSpending) || newGoalSpending.charAt(0) == "-") {
          return Promise.reject({
            message: "Goal Spending must be valid positive money, eg. 2 or 2.32",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    },
    "newPerNumberOfDays": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The newPerNumberOfDays field must be a string",
        errorCode: errorCodes.invalidUpdateCategory
      },
      restriction: (newPerNumberOfDays) => {
        if(!validPositiveInteger(newPerNumberOfDays)) {
          return Promise.reject({
            message: "perNumberOfDays must be a positive integer.",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }
      }
    }
  }
}


/**
 * Validifies a `postUpdateCategory`.
 */
export const validPostUpdateCategory = kleen.validModel(postUpdateCategoryType);
