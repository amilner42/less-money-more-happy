/// Module for `PostExpenditure`s, which are expenditures being sent from the
/// frontend.

import { structures, errorCodes } from '../types';
import { isNullOrUndefined } from '../util';
import { validPositiveInteger, validMoney} from '../validifier';


// A valid PostExpenditure from the frontend.
export const postExpenditureType: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "cost": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (cost: string) => {
        if(isNullOrUndefined(cost)) {
          return Promise.reject({
            message: "Cost cannot be null/undefined.",
            errorCode: errorCodes.invalidExpenditure
          });
        }

        if(!validMoney(cost)) {
          return Promise.reject({
            message: "Cost must be a valid money",
            errorCode: errorCodes.invalidExpenditure
          });
        }
      }
    },
    "categoryID": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (categoryID: string) => {
        if(isNullOrUndefined(categoryID)) {
          return Promise.reject({
            message: "CategoryID cannot be null/undefined",
            errorCode: errorCodes.invalidExpenditure
          });
        }

        if(!validPositiveInteger(categoryID)) {
          return Promise.reject({
            message: "CategoryID must be a valid positive integer",
            errorCode: errorCodes.invalidExpenditure
          });
        }
      }
    }
  },
  restriction: (postExpenditure) => {
    if(isNullOrUndefined(postExpenditure)) {
      return Promise.reject({
        message: "Expenditure cannot be null/undefined",
        errorCode: errorCodes.invalidExpenditure
      });
    }
  }
}
