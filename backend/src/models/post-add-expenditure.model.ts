/// Module for `PostExpenditure`s, which are expenditures being sent from the
/// frontend.

import { errorCodes, frontendID } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from "kleen";


/**
 * An expenditure made by the user.
 */
export interface expenditure {
  id: frontendID;
  date: Date;
  categoryID: frontendID;
  cost: number;
}


/**
 * The schema for adding an `expenditure`.
 */
const postAddExpenditureSchema: kleen.objectSchema = {
  typeFailureError: {
    message: "Expenditure must be an exact expenditure",
    errorCode: errorCodes.invalidExpenditure
  },
  objectProperties: {
    "cost": {
      primitiveType: kleen.kindOfPrimitive.string,
      typeFailureError: {
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
      primitiveType: kleen.kindOfPrimitive.string,
      typeFailureError: {
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
 * Validifies a `postAddExpenditureSchema`.
 */
export const validPostAddExpenditure =
  kleen.validModel(postAddExpenditureSchema);
