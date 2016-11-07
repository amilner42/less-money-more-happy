/// Module for `PostExpenditure`s, which are expenditures being sent from the
/// frontend.

import { errorCodes } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from "kleen";


// A valid PostExpenditure from the frontend.
export const postExpenditureType: kleen.objectStructure = {
  kindOfType: kleen.kindOfType.object,
  customErrorOnTypeFailure: {
    message: "Expenditure must be an exact expenditure",
    errorCode: errorCodes.invalidExpenditure
  },
  properties: {
    "cost": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The cost field must be a string",
        errorCode: errorCodes.invalidExpenditure
      },
      restriction: (cost: string) => {
        if(!validMoney(cost)) {
          return Promise.reject({
            message: "Cost must be a valid money",
            errorCode: errorCodes.invalidExpenditure
          });
        }

        if(parseFloat(cost) <= 0) {
          return Promise.reject({
            message: "Cost must be positive!",
            errorCode: errorCodes.invalidExpenditure
          });
        }
      }
    },
    "categoryID": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The categoryID must be a string",
        errorCode: errorCodes.invalidExpenditure
      },
      restriction: (categoryID: string) => {
        if(!validPositiveInteger(categoryID)) {
          return Promise.reject({
            message: "CategoryID must be a valid positive integer",
            errorCode: errorCodes.invalidExpenditure
          });
        }
      }
    }
  }
}


/**
 * Validifies a `postExpenditureType`.
 */
export const validPostExpenditure = kleen.validModel(postExpenditureType);
