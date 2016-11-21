/// Module for `PostEarning`s, which are earnings being sent from the
/// frontend.

import { errorCodes } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from "kleen";
import {
  stringPositiveMoneySchema,
  stringPositiveIntegerSchema } from './shared-schemas';


/**
 * A `postAddEarning` is the format for adding a new earning.
 */
export interface postAddEarning {
  amount: string,
  fromEmployerID: string
};


/**
 * The schema for a `postAddEarning`.
 */
const postAddEarningSchema: kleen.objectSchema = {
  objectProperties: {
    "amount": stringPositiveMoneySchema({
      message: "The `amount` field must represent positive money",
      errorCode: errorCodes.invalidEarning
    }),
    "fromEmployerID": stringPositiveIntegerSchema({
      message: "The `fromEmployerID` field must be a string representing a positive int.",
      errorCode: errorCodes.invalidEarning
    })
  },
  typeFailureError: {
    message: "Earning must be an exact earning",
    errorCode: errorCodes.invalidEarning
  }
};


/**
 * Validifies a `postAddEarningSchema`.
 */
export const validPostAddEarning = kleen.validModel(postAddEarningSchema);
