/// Module for valid error model.

import { frontendError, structures, errorCodes} from '../types';
import { validModel } from '../validifier';
import { isNullOrUndefined } from '../util';


/**
 * The frontend error type for `validModel`.
 */
const frontendErrorType: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties:
    {
      "message":
        {
          typeCategory: structures.typeCategory.primitive,
          type: structures.primitiveType.string,
          restriction: (message) => {
            if(isNullOrUndefined(message)) {
              return Promise.reject({
                message: "An error message cannot be null or undefined",
                errorCode: errorCodes.internalError
              });
            }
          }
        },
      "errorCode":
        {
          typeCategory: structures.typeCategory.primitive,
          type: structures.primitiveType.number,
          restriction: (errorCode) => {
            if(isNullOrUndefined(errorCode)) {
              return Promise.reject({
                message: "An error errorCode cannot be null or undefined",
                errorCode: errorCodes.internalError
              });
            }
          }
        }
    },
    restriction: (error) => {
      if(isNullOrUndefined(error)) {
        return Promise.reject({
          message: "An error cannot be null or undefined",
          errorCode: errorCodes.internalError
        });
      }
    }
}


/**
 * Throws error if error is not of the frontend error.
 */
export const validError = (error: any): Promise<void> => {
  return validModel(error, frontendErrorType);
}
