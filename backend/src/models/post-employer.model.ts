/// Module for `PostEmployer`s, which are employers being sent from the
/// frontend.

import { structures, errorCodes } from '../types';
import { isNullOrUndefined } from '../util';
import { validPositiveInteger, validMoney} from '../validifier';


/**
 * The type of a `PostEmployer` from the frontend, must contain a single field,
 * the `name` of the employer.
 */
export const postEmployerType: structures.interfaceStructure {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "name": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (name: string) => {
        if(isNullOrUndefined(name)) {
          return Promise.reject({
            message: "name cannot be null/undefined",
            errorCode: errorCodes.invalidEmployer
          });
        }
      }
    }
  },
  restriction: (postEmployer) => {
    if(isNullOrUndefined(postEmployer)) {
      return Promise.reject({
        message: "Employer cannot be null/undefined",
        errorCode: errorCodes.invalidEmployer
      });
    }
  }
}
