/// Module for `PostEarning`s, which are earnings being sent from the
/// frontend.

import { errorCodes } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from "kleen";


/**
 * The `type` of a `PostEarning`, a partial earning from a frontend "POST"
 * request. It must have an `amount` and `fromEmployerID`.
 */
export const postEarningType: kleen.objectStructure = {
  kindOfType: kleen.kindOfType.object,
  customErrorOnTypeFailure: {
    message: "Earning must be an exact earning",
    errorCode: errorCodes.invalidEarning
  },
  properties: {
    "amount": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The amount field must be a string",
        errorCode: errorCodes.invalidEarning
      },
      restriction: (amount: string) => {
        if(!validMoney(amount)) {
          return Promise.reject({
            message: "amount must be a valid money",
            errorCode: errorCodes.invalidEarning
          });
        }

        const amountAsFloat = parseFloat(amount);
        if(amountAsFloat <= 0) {
          return Promise.reject({
            message: "amount must be positive",
            errorCode: errorCodes.invalidEarning
          });
        }
      }
    },
    "fromEmployerID": {
      kindOfType: kleen.kindOfType.primitive,
      kindOfPrimitive: kleen.kindOfPrimitive.string,
      customErrorOnTypeFailure: {
        message: "The fromEmployerID field must be a string",
        errorCode: errorCodes.invalidEarning
      }
    }
  }
}


/**
 * Validifies a `postEarningType`.
 */
export const validPostEarning = kleen.validModel(postEarningType);
