/// Module for the expenditureCategory model.

import { omit } from "ramda";

import { model, expenditureCategory, structures, errorCodes } from '../types';
import { validModel } from '../validifier';
import { isNullOrUndefined } from '../util';


/**
 * The expenditure `type` for `validifier` validation. This is used specifically
 * for the POST request from the user when their is nothing but `name`s on the
 * categories.
 */
const expenditureType: structures.interfaceStructure = {
  typeCategory: structures.typeCategory.interface,
  properties: {
    "name": {
      typeCategory: structures.typeCategory.primitive,
      type: structures.primitiveType.string,
      restriction: (name) => {
        if(isNullOrUndefined(name)) {
          return Promise.reject({
            errorCode: errorCodes.invalidCategories,
            message: "The `name` propertry on a category cannot be null or undefined"
          });
        }
      }
    }
  }
}


/**
 * Just a helper for getting the array type
 *
 * ADDITIONALLY: Checks the length is greater than 0, this is what we require
                 for the post requests.
 */
const arrayOfExpenditureType: structures.arrayStructure = {
  typeCategory: structures.typeCategory.array,
  type: expenditureType,
  restriction: (arrayOfExpenditureCategories) => {
    if(isNullOrUndefined(arrayOfExpenditureCategories)) {
      return Promise.reject({
        errorCode: errorCodes.invalidCategories,
        message: "You must pass an array of categories, not null/undefined"
      });
    }

    if(arrayOfExpenditureCategories.length == 0) {
      return Promise.reject({
        errorCode: errorCodes.invalidCategories,
        message: "You cannot have 0 categories!"
      });
    };
  }
}


/**
 * The `expenditureCategory` model.
 */
export const expenditureCategoryModel: model<expenditureCategory> = {
  name: "expenditureCategory",
  stripSensitiveDataForResponse: (expenditureCategory: expenditureCategory) => {
    return omit(['_id'])(expenditureCategory);
  }
}


/**
 * Checks that an aray of expenditure categories are valid.
 */
export const validExpenditureArray = (expenditureArray): Promise<void> => {
  return validModel(expenditureArray, arrayOfExpenditureType);
}
