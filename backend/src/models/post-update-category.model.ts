/// Module for `PostUpdateCategory`s, which is sent on post requests from the
/// frontend to update the goals for a single category.

import { structures, errorCodes } from '../types';
import { isNullOrUndefined } from '../util';
import { validPositiveInteger, validMoney} from '../validifier';


/**
 * A `PostUpdateCategory` must have:
 *  - `categoryID` of category we are updating
 *  - `newGoalSpending`
 *  - `newPerNumberOfDays`
 */
export const postUpdateCategory: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "categoryID": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.number,
      restriction: (categoryID) => {
        if(isNullOrUndefined(categoryID)) {
          return Promise.reject({
            message: "PostUpdateCategory.categoryID cannot be null/undefined.",
            errorCode: errorCodes.invalidUpdateCategory
          });
        }
      }
    },
    "newGoalSpending": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (newGoalSpending) => {
        if(isNullOrUndefined(newGoalSpending)) {
          return Promise.reject({
            message: "PostUpdateCategory.newGoalSpending cannot be null/undefined",
            errorCode: errorCodes.invalidUpdateCategory
          });
        }

        if(!validMoney(newGoalSpending) || newGoalSpending.charAt(0) == "-") {
          return Promise.reject({
            message: "Goal Spending must be valid positive money, eg. 2 or 2.32",
            errorCode: errorCodes.invalidCategoriesWithGoals
          })
        }
      }
    },
    "newPerNumberOfDays": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (newPerNumberOfDays) => {
        if(isNullOrUndefined(newPerNumberOfDays)) {
          return Promise.reject({
            message: "PostUpdateCategory.newPerNumberOfDays cannot be null/undefined",
            errorCode: errorCodes.invalidUpdateCategory
          });
        }

        if(!validPositiveInteger(newPerNumberOfDays)) {
          return Promise.reject({
            message: "perNumberOfDays must be a positive integer.",
            errorCode: errorCodes.invalidCategoriesWithGoals
          });
        }
      }
    }
  },
  restriction: (postUpdateCategory) => {
    if(isNullOrUndefined(postUpdateCategory)) {
      return Promise.reject({
        message: "PostUpdateCategory cannot be null/undefined",
        errorCode: errorCodes.invalidUpdateCategory
      });
    }
  }
}
