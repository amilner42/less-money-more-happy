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
 * The schema for an `expenditureCategory`.
 */
const expenditureCategorySchema: kleen.objectSchema = {
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
 * The schema for an array of `expenditureCategorySchema`.
 *
 * ADDITIONALLY: Checks the length is greater than 0, this is what we require
                 for the post requests.
 */
const arrayOfExpenditureSchema: kleen.arraySchema = {
  arrayElementType: expenditureCategorySchema,
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
 * Validifies a `arrayOfExpenditureSchema`.
 */
export const validExpenditureArray =
  kleen.validModel(arrayOfExpenditureSchema);
