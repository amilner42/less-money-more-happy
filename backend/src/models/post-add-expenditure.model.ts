/// Module for `PostExpenditure`s, which are expenditures being sent from the
/// frontend.

import { errorCodes, frontendID } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from "kleen";
import {
  stringPositiveMoneySchema,
  stringPositiveIntegerSchema } from './shared-schemas';


/**
 * A `postAddExpenditure` is the format for adding an expenditure.
 */
export interface postAddExpenditure {
  cost: string,
  categoryID: string
};


/**
 * The schema for adding an `expenditure`.
 */
const postAddExpenditureSchema: kleen.objectSchema = {
  objectProperties: {
    "cost": stringPositiveMoneySchema({
      message: "The cost field must be a string representing a positive moeny, eg, 2 or 2.32",
      errorCode: errorCodes.invalidExpenditure
    }),
    "categoryID": stringPositiveIntegerSchema({
      message: "CategoryID must be a string representing a positive integer",
      errorCode: errorCodes.invalidExpenditure
    })
  },
  typeFailureError: {
    message: "Expenditure must be an exact expenditure",
    errorCode: errorCodes.invalidExpenditure
  }
};


/**
 * Validifies a `postAddExpenditureSchema`.
 */
export const validPostAddExpenditure =
  kleen.validModel(postAddExpenditureSchema);
