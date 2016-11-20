/// Module for valid error model.

import { errorCodes } from '../types';
import * as kleen from 'kleen';
import { positiveIntegerSchema } from "./shared-schemas";


/**
 * The error we always send to the frontend.
 */
export interface frontendError {
  message: string;
  errorCode: errorCodes;
};


/**
 * The frontend error type for `validModel`.
 */
const frontendErrorType: kleen.objectSchema = {
  objectProperties: {
    "message": {
      primitiveType: kleen.kindOfPrimitive.string,
      typeFailureError: {
        message: "The `message` field must be a string",
        errorCode: errorCodes.internalError
      }
    },
    "errorCode": positiveIntegerSchema({
      message: "The `errorCode` field must be a positive integer corresponding to an error code.",
      errorCode: errorCodes.internalError
    })
  },
  typeFailureError: {
    message: "A frontend error must have a message and errorCode.",
    errorCode: errorCodes.internalError
  }
};


/**
 * Validifies a `frontendErrorType`.
 */
export const validFrontendError = kleen.validModel(frontendErrorType);
