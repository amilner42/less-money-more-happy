/// Module for valid error model.

import { frontendError, errorCodes } from '../types';
import * as kleen from 'kleen';


/**
 * The frontend error type for `validModel`.
 */
const frontendErrorType: kleen.objectSchema = {
  objectProperties:
    {
      "message":
        {
          primitiveType: kleen.kindOfPrimitive.string,
          typeFailureError: {
            message: "The message field must be a string",
            errorCode: errorCodes.internalError
          }
        },
      "errorCode":
        {
          primitiveType: kleen.kindOfPrimitive.string,
          typeFailureError: {
            message: "An error errorCode cannot be null or undefined",
            errorCode: errorCodes.internalError
          }
        }
    },
    typeFailureError: {
      message: "Error code did not have the exact correct type",
      errorCode: errorCodes.internalError
    }
}


/**
 * Validifies a `frontendErrorType`.
 */
export const validFrontendError = kleen.validModel(frontendErrorType);
