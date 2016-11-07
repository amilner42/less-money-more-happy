/// Module for valid error model.

import { frontendError, errorCodes } from '../types';
import * as kleen from 'kleen';


/**
 * The frontend error type for `validModel`.
 */
const frontendErrorType: kleen.objectStructure = {
  kindOfType: kleen.kindOfType.object,
  customErrorOnTypeFailure: {
    message: "Error code did not have the exact correct type",
    errorCode: errorCodes.internalError
  },
  properties:
    {
      "message":
        {
          kindOfType: kleen.kindOfType.primitive,
          kindOfPrimitive: kleen.kindOfPrimitive.string,
          customErrorOnTypeFailure: {
            message: "The message field must be a string",
            errorCode: errorCodes.internalError
          }
        },
      "errorCode":
        {
          kindOfType: kleen.kindOfType.primitive,
          kindOfPrimitive: kleen.kindOfPrimitive.string,
          customErrorOnTypeFailure: {
            message: "An error errorCode cannot be null or undefined",
            errorCode: errorCodes.internalError
          }
        }
    }
}


/**
 * Validifies a `frontendErrorType`.
 */
export const validFrontendError = kleen.validModel(frontendErrorType);
