/// Module for `PostEarning`s, which are earnings being sent from the
/// frontend.

import { structures, errorCodes } from '../types';
import { isNullOrUndefined } from '../util';
import { validPositiveInteger, validMoney} from '../validifier';


/**
 * The `type` of a `PostEarning`, a partial earning from a frontend "POST"
 * request. It must have an `amount` and `fromEmployerID`.
 */
export const postEarningType: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "amount": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (amount: string) => {
        if(isNullOrUndefined(amount)) {
          return Promise.reject({
            message: "amount cannot be null/undefined",
            errorCode: errorCodes.invalidEarning
          });
        }

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
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (employerID: string) => {
        if(isNullOrUndefined(employerID)) {
          return Promise.reject({
            message: "fromEmployerID cannot be null/undefined",
            errorCode: errorCodes.invalidEarning
          });
        }
      }
    }
  },
  restriction: (postEarning) => {
    if(isNullOrUndefined(postEarning)) {
      return Promise.reject({
        message: "Earning cannot be undefined/null",
        errorCode: errorCodes.invalidEarning
      });
    }
  }
}
