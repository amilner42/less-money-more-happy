/// Module for the user model.

import { omit } from "ramda";

import { model, mongoID, earning, employer } from '../types';
import { takeLast } from "ramda";
import { isNullOrUndefined } from "../util";
import { expenditureCategoryWithGoals, expenditure } from './';


/**
 * This dictates how many expenditures/earnings we will send back to the user.
 */
const MAX_ARRAY_RESULTS = 250;


/**
 * A `user`.
 */
export interface user {
  _id?: mongoID;
  email: string;
  password?: string;
  currentBalance?: number;
  categoriesWithGoals?: expenditureCategoryWithGoals[];
  expenditures?: expenditure[];
  earnings?: earning[];
  employers?: employer[];
}


/**
 * The `user` model.
 */
export const userModel: model<user> = {
  name: "user",
  // Additional optional param `capResults`, if explicitely set to `false` then
  // the results will not be capped, otherwise it will cap nested arrays.
  stripSensitiveDataForResponse: (user: user, capResults = true) => {
    // We don't send the password.
    user.password = null;
    // We only send over the last 250 expenditures/earnings.
    if(!isNullOrUndefined(user.expenditures) && capResults) {
      user.expenditures = takeLast(MAX_ARRAY_RESULTS, user.expenditures);
    }

    if(!isNullOrUndefined(user.earnings) && capResults) {
      user.earnings = takeLast(MAX_ARRAY_RESULTS, user.earnings);
    }
    return omit(['_id'])(user);
  }
};
