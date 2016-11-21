/// Module for the expenditureCategoryWithGoals model.

import { validMoney, validPositiveInteger, validMongoID } from '../validifier';
import { errorCodes, frontendID, mongoID } from '../types';
import * as kleen from "kleen";
import {
  frontendIDSchema,
  mongoIDSchema,
  nameSchema,
  stringPositiveMoneySchema,
  stringPositiveIntegerSchema } from "./shared-schemas";


/**
 * A category and it's respective goal.
 */
export type expenditureCategoryWithGoals = {
  id: frontendID;
  colorID: mongoID;
  name: string;
  goalSpending?: string;
  perNumberOfDays?: string;
};


/**
 * The schema for `expenditureCategoryWithGoals`.
 */
const expenditureCategoryWithGoalSchema: kleen.objectSchema = {
  objectProperties: {
    "id": frontendIDSchema({
      message: "The id field must be a number!",
      errorCode: errorCodes.invalidCategoriesWithGoals
    }),
    "colorID": mongoIDSchema({
      message: "The colorID field must be a string",
      errorCode: errorCodes.invalidCategoriesWithGoals
    }),
    "name": nameSchema({
      message: "The name field must be a string",
      errorCode: errorCodes.invalidCategoriesWithGoals
    }),
    "goalSpending": stringPositiveMoneySchema({
      message: "Goal Spending must be valid positive money, eg. 2 or 2.32",
      errorCode: errorCodes.invalidCategoriesWithGoals
    }),
    "perNumberOfDays": stringPositiveIntegerSchema({
      message: "perNumberOfDays must be a positive integer.",
      errorCode: errorCodes.invalidCategoriesWithGoals
    })
  },
  typeFailureError: {
    errorCode: errorCodes.invalidCategoriesWithGoals,
    message: "Category type incorrect."
  }
};


/**
 * The schema for an array of `expenditureCategoryWithGoalSchema`.
 */
const arrayOfExpenditureCategoryWithGoalSchema: kleen.arraySchema = {
  arrayElementType: expenditureCategoryWithGoalSchema,
  typeFailureError: {
    message: "Array of categories type incorrect.",
    errorCode: errorCodes.invalidCategoriesWithGoals
  }
};


/**
 * Validifies a `arrayOfExpenditureCategoryWithGoalSchema`.
 */
export const validExpenditureCategoryWithGoalsArray =
  kleen.validModel(arrayOfExpenditureCategoryWithGoalSchema);
