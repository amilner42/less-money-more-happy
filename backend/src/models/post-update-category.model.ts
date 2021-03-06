/// Module for `PostUpdateCategory`s, which is sent on post requests from the
/// frontend to update the goals for a single category.

import { errorCodes } from '../types';
import { validPositiveInteger, validMoney} from '../validifier';
import * as kleen from 'kleen';
import {
  frontendIDSchema,
  stringPositiveMoneySchema,
  stringPositiveIntegerSchema } from './shared-schemas';


/**
 * A `postUpdateCategory` is the format for updating a category.
 */
export type postUpdateCategory = {
  categoryID: number,
  newGoalSpending: string,
  newPerNumberOfDays: string
};


/**
 * The schema for a `postUpdateCategory`.
 */
const postUpdateCategorySchema: kleen.objectSchema = {
  objectProperties: {
    "categoryID": frontendIDSchema({
      message: "The `categoryID` field must be a number.",
      errorCode: errorCodes.invalidUpdateCategory
    }),
    "newGoalSpending": stringPositiveMoneySchema({
      message: "The `newGoalSpending` field must be valid positive money, eg. 2 or 2.32",
      errorCode: errorCodes.invalidUpdateCategory
    }),
    "newPerNumberOfDays": stringPositiveIntegerSchema({
      message: "The `newPerNumberOfDays` field must be a string representing a positive integer.",
      errorCode: errorCodes.invalidUpdateCategory
    })
  },
  typeFailureError: {
    message: "PostUpdateCategory must be an exact postUpdateCategory",
    errorCode: errorCodes.invalidUpdateCategory
  }
};


/**
 * Validifies a `postUpdateCategorySchema`.
 */
export const validPostUpdateCategory =
  kleen.validModel(postUpdateCategorySchema);
