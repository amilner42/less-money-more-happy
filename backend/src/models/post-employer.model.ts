/// Module for `PostEmployer`s, which are employers being sent from the
/// frontend.

import { errorCodes } from '../types';
import { validNotJustSpacesString } from '../validifier';
import * as kleen from "kleen";


/**
 * The type of a `PostEmployer` from the frontend, must contain a single field,
 * the `name` of the employer.
 */
export const postEmployerType: kleen.objectSchema = {
  typeFailureError: {
    message: "Employer must be an exact employer",
    errorCode: errorCodes.invalidEmployer
  },
  objectProperties: {
    "name": {
      primitiveType: kleen.kindOfPrimitive.string,
      restriction: (name: string) => {
        if(!validNotJustSpacesString(name)) {
          return Promise.reject({
            message: "The name field cannot be just spaces",
            errorCode: errorCodes.invalidEmployer
          });
        }
      }
    }
  }
}


/**
 * Validifies a `postEmployerType`.
 */
export const validPostEmployer = kleen.validModel(postEmployerType);
