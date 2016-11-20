/// Module for `PostAddCategory`s, which are categories being sent from the
/// frontend, we add these categories and their goals to the users list.

import { errorCodes } from '../types';
import {
  validPositiveInteger,
  validMoney,
  validNotJustSpacesString } from '../validifier';
import { collection } from '../db';
import * as kleen from "kleen";
import {
  nameSchema,
  stringPositiveIntegerSchema,
  stringPositiveMoneySchema } from './shared-schemas';


/**
 * A `PostAddCategory` is the format for adding a new category.
 */
export type postAddCategory = {
  newName: string,
  newPerNumberOfDays: string,
  newGoalSpending: string
};


/**
 * `PostAddCategory` type. is the format for adding category.
 */
export const postAddCategoryType: kleen.objectSchema = {
  objectProperties: {
    "newName": nameSchema({
      message: "The newName field must be a string (and not just spaces).",
      errorCode: errorCodes.invalidAddCategory
    }),
    "newPerNumberOfDays": stringPositiveIntegerSchema({
      message: "The newPerNumberOfDays field must represent a positive integer",
      errorCode: errorCodes.invalidAddCategory
    }),
    "newGoalSpending": stringPositiveMoneySchema({
      message: "The newGoalSpending field must represent positive money, eg. 2 or 2.32",
      errorCode: errorCodes.invalidAddCategory
    })
  },
  typeFailureError: {
    message: "Category must be an exact category!",
    errorCode: errorCodes.invalidAddCategory
  }
}


/**
 * Validifies a `postAddCategoryType`.
 */
export const validPostAddCategory = kleen.validModel(postAddCategoryType);
