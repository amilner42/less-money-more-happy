/// Module for the expenditureCategory model.

import { omit } from "ramda";

import { model, mongoID, errorCodes } from '../types';
import * as kleen from "kleen";
import { optionaMongoIDSchema, nameSchema } from "./shared-schemas";


/**
 * An expenditure category.
 */
export interface expenditureCategory {
  _id?: mongoID;
  name: string;
}


/**
 * The expenditure `type` for `validifier` validation. This is used specifically
 * for the POST request from the user when their is nothing but `name`s on the
 * categories.
 */
const expenditureType: kleen.objectSchema = {
  objectProperties: {
    "_id": optionaMongoIDSchema({
      errorCode: errorCodes.invalidCategories,
      message: "The `_id` field must be a valid mongo ID"
    }),
    "name": nameSchema({
      errorCode: errorCodes.invalidCategories,
      message: "The `name` field must be a string."
    })
  }
};


/**
 * Just a helper for getting the array type.
 *
 * ADDITIONALLY: Checks the length is greater than 0, this is what we require
                 for the post requests.
 */
const arrayOfExpenditureType: kleen.arraySchema = {
  arrayElementType: expenditureType,
  typeFailureError: {
    errorCode: errorCodes.invalidCategories,
    message: "You must pass an array of categories!"
  },
  restriction: (arrayOfExpenditureCategories) => {
    if(arrayOfExpenditureCategories.length == 0) {
      return Promise.reject({
        errorCode: errorCodes.invalidCategories,
        message: "You cannot have 0 categories!"
      });
    };
  }
};


/**
 * The `expenditureCategory` model.
 */
export const expenditureCategoryModel: model<expenditureCategory> = {
  name: "expenditureCategory",
  stripSensitiveDataForResponse: (expenditureCategory: expenditureCategory) => {
    return omit(['_id'])(expenditureCategory);
  }
};


/**
 * Validifies a `arrayOfExpenditureType`.
 */
export const validExpenditureArray =
  kleen.validModel(arrayOfExpenditureType);
