/// Module for the user model.

import { omit } from "ramda";

import { model, user } from '../types';


/**
 * The `user` model.
 */
export const userModel: model<user> = {
  name: "user",
  stripSensitiveDataForResponse: (user: user) => {
    user.password = null;
    return omit(['_id'])(user);
  }
};
