/// Module for `PostEmployer`s, which are employers being sent from the
/// frontend.

import { errorCodes } from '../types';
import { validNotJustSpacesString } from '../validifier';
import * as kleen from "kleen";
import { nameSchema } from './shared-schemas';


/**
 * A `postAddEmployer` is the format in which an employer is added.
 */
export interface postAddEmployer {
  name: string;
}


/**
 * The schema for a `postAddEmployer`.
 */
const postAddEmployerSchema: kleen.objectSchema = {
  objectProperties: {
    "name": nameSchema({
      message: "The name field must a be valid string (not just spaces).",
      errorCode: errorCodes.invalidEmployer
    })
  },
  typeFailureError: {
    message: "Employer must be an exact employer",
    errorCode: errorCodes.invalidEmployer
  }
}


/**
 * Validifies a `postAddEmployerSchema`.
 */
export const validPostAddEmployer = kleen.validModel(postAddEmployerSchema);
