/// Module for the expenditureCategory model.

import { omit } from "ramda";

import { model, expenditureCategory } from '../types';


/**
 * The `expenditureCategory` model.
 */
export const expenditureCategoryModel: model<expenditureCategory> = {
  name: "expenditureCategory",
  stripSensitiveDataForResponse: (expenditureCategory: expenditureCategory) => {
    return omit(['_id'])(expenditureCategory);
  }
}
