/// Module for encapsaluting all routes for the API. Any complex logic in here
/// should be moved to a seperate module.

import passport from 'passport';
import R from 'ramda';

import { APP_CONFIG } from '../app-config';
import {
  userModel,
  expenditureCategoryModel,
  validExpenditureArray,
  validExpenditureCategoryWithGoalsArray,
  postExpenditureType,
  postEarningType,
  postEmployerType,
  postUpdateCategory } from './models/';
import {
  appRoutes,
  errorCodes,
  expenditureCategory,
  color,
  user,
  expenditureCategoryWithGoals,
  structures,
  expenditure,
  earning } from './types';
import { collection } from './db';
import {
  prepareErrorForFrontend,
  renameMongoIDField,
  isNullOrUndefined } from './util';
import { validMoney, validModel } from './validifier';


/**
 * All routes by default will be assumed to require authentication, routes that
 * do not must be listed below. The API base url need not be included in the
 * array as it is `map`ed on.
 */
export const apiAuthlessRoutes = [
  '/register',
  '/login',
  '/defaultExpenditureCategories',
  '/defaultColors'
].map((route) => `${APP_CONFIG.app.apiSuffix}${route}`);

/**
 * The routes for the API.
 */
export const routes: appRoutes = {

  '/register': {
    /**
     * Register a user for the application, requires a username and password.
     */
    post: (req, res, next) => {

      passport.authenticate('sign-up', (err, user, info) => {
        // A 500-like error.
        if(err) {
          next(err);
          return;
        }

        // If no user an error must have occured.
        if(!user) {
          res.status(400).json(
            { message: info.message, errorCode: info.errorCode }
          );
          return;
        }

        // Log user in.
        req.login(user, (err) => {
          if(err) {
            next(err);
            return;
          }

          res.status(201).json(userModel.stripSensitiveDataForResponse(user));
          return;
        });
      })(req, res, next);
    }
  },

  '/login': {
    /**
     * Logs a user in and returns the user or a standard error + code.
     */
    post: (req, res, next) => {
      passport.authenticate('login', (err, user, info) => {
        // A 500-like error
        if (err) {
          next(err);
          return;
        }

        // If no user an error must have occured.
        if (!user) {
          res.status(400).json(
            { message: info.message, errorCode: info.errorCode }
          );
          return;
        }

        // Log user in.
        req.login(user, (err) => {
          if (err) {
            return next(err);
          }

          res.status(200).json(userModel.stripSensitiveDataForResponse(user));
          return;
        });
      })(req, res, next);
    }
  },

  '/account': {
    /**
     * Returns the users account with sensitive data stripped.
     */
    get: (req, res, next) => {
      res.status(200).json(userModel.stripSensitiveDataForResponse(req.user));
      return;
    }
  },

  '/account/setCurrentBalance': {
    /**
     * Sets the balance for a user,
     */
    post: (req, res, next) => {
      const user = req.user;
      const balance = req.body.balance;

      if(validMoney(balance)) {
        user.currentBalance = parseFloat(balance);
        collection("users")
        .then((Users) => {
          return Users.save(user);
        })
        .then(() => {
          res.status(200).json(userModel.stripSensitiveDataForResponse(user));
        })
        .catch((error) => {
          prepareErrorForFrontend(error)
          .then((error) => {
            res.status(400).json(error);
          });
        });
      } else {
        res.status(400).json({
          message: `Invalid balance: ${balance}`,
          errorCode: errorCodes.invalidBalance
        });
      }
    }
  },

  '/account/setExpenditureCategories': {
    /**
     * Sets the expenditure categories for a user, asks only for the name, will
     * automatically set the color and id. This will overwrite all existing
     * categories and set goalSpending and perNumberOfDays to null, this should
     * really only be used when the user is first signing up.
     */
    post: (req, res) => {
      const user: user = req.user;
      const expenditureCategories: expenditureCategoryWithGoals[] = req.body;

      return validExpenditureArray(expenditureCategories)
      .then(() => {
        return collection('colors');
      })
      .then((Colors) => {
        let lightDefaultColors: color[] = [];
        let darkDefaultColors: color[] = [];

        // parralel.
        return Promise.all([
          Colors.find({ defaultColor: true , dark: false}).toArray(),
          Colors.find({ defaultColor: true, dark: true}).toArray()
        ])
        .then(lightAndDarkColors => {
          [lightDefaultColors, darkDefaultColors] = lightAndDarkColors;

          for(let index = 0; index < expenditureCategories.length; index++) {
            let expenditureCategory = expenditureCategories[index];
            expenditureCategory.id = index + 1;
            if(index % 2 == 0) {
              expenditureCategory.colorID = lightDefaultColors[index % lightDefaultColors.length]._id;
            } else {
              expenditureCategory.colorID = darkDefaultColors[index % darkDefaultColors.length]._id;
            }
            expenditureCategory.goalSpending = null;
            expenditureCategory.perNumberOfDays = null;
          }

          user.categoriesWithGoals = expenditureCategories;

          return collection("users")
          .then((Users) => {
            return Users.save(user);
          })
          .then(() => {
            res.status(200).json(userModel.stripSensitiveDataForResponse(user));
          });
        });
      })
      .catch((error) => {
        prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
        })
      });
    }
  },

  '/account/setExpenditureCategoriesWithGoals': {
    /**
     * Sets a users `categoriesWithGoals`, does full data validation returning
     * errors if any of the category data is invalid.
     */
    post: (req, res) => {
      const user = req.user;
      const expenditureCategoryWithGoals = req.body;

      return validExpenditureCategoryWithGoalsArray(expenditureCategoryWithGoals)
      .then(() => {
        user.categoriesWithGoals = expenditureCategoryWithGoals;

        return collection('users')
        .then((Users) => {
          return Users.save(user);
        })
        .then(() => {
          res.status(200).json(userModel.stripSensitiveDataForResponse(user));
        });
      })
      .catch((error) => {
        prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
        });
      });
    }
  },

  '/account/updateCategory': {
    /**
     * Updates a single category of the users.
     */
    post: (req, res) => {
      const user: user = req.user;
      const updatedCategory = req.body;

      return validModel(updatedCategory, postUpdateCategory)
      .then(() => {
        for(let category of user.categoriesWithGoals || []) {
          if(category.id == updatedCategory.categoryID) {
            category.goalSpending = updatedCategory.newGoalSpending;
            category.perNumberOfDays = updatedCategory.newPerNumberOfDays;
            return collection('users');
          }
        }

        return Promise.reject({
          message: "No user category had that ID!",
          errorCode: errorCodes.invalidUpdateCategory
        });
      })
      .then((Users) => {
        return Users.save(user);
      })
      .then(() => {
        res.status(200).json(user);
      })
      .catch((error) => {
        return prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
        });
      })
    }
  },

  '/account/addExpenditure': {
    /**
     * Adds an expenditure to the users list of expenditures. Recomputes
     * currentBalance.
     */
    post: (req, res) => {
      const user: user = req.user;
      const expenditure = req.body;

      return validModel(expenditure, postExpenditureType)
      .then(() => {
        if(isNullOrUndefined(user.expenditures)) {
          user.expenditures = [];
        }
        const numberOfExpenditures = user.expenditures.length;

        // The new expenditure (backend fills `id` and `date`) as well as
        // converting fields from strings to the correct type.
        const newExpenditure: expenditure = {
          id: numberOfExpenditures + 1,
          date: new Date(),
          categoryID: parseInt(expenditure.categoryID),
          cost: parseFloat(expenditure.cost)
        };

        return collection('users')
        .then((Users) => {
          // Update the user.
          user.expenditures.push(newExpenditure);
          user.currentBalance -= newExpenditure.cost;
          return Users.save(user);
        })
        .then(() => {
          res.status(200).json(userModel.stripSensitiveDataForResponse(user));
          return;
        });
      })
      .catch((error) => {
        return prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
          return;
        });
      });
    }
  },

  '/account/addEarning': {
    /**
     * Adds an earning to the users list of earnings. Recomputes currentBalance.
     */
    post: (req, res) => {
      const user = req.user;
      const earning = req.body;

      return validModel(earning, postEarningType)
      .then(() => {
        if(isNullOrUndefined(user.earnings)) {
          user.earnings = [];
        }

        const numberOfEarnings = user.earnings.length;

        const newEarning: earning = {
          id: numberOfEarnings + 1,
          fromEmployerID: parseInt(earning.fromEmployerID),
          amount: parseFloat(earning.amount),
          date: new Date()
        };

        return collection('users')
        .then((Users) => {
          user.earnings.push(newEarning);
          user.currentBalance += newEarning.amount;

          return Users.save(user);
        })
        .then(() => {
          res.status(200).json(userModel.stripSensitiveDataForResponse(user));
        });
      })
      .catch((error) => {
        return prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
        });
      });
    }
  },

  '/account/addEmployer': {
    /**
     * Adds an employer.
     */
    post: (req, res) => {
      const user = req.user;
      const employer = req.body;

      return validModel(employer, postEmployerType)
      .then(() => {
        if(isNullOrUndefined(user.employers)) {
            user.employers = [];
        }

        const newEmployer = {
          name: employer.name,
          id: user.employers.length + 1
        };

        return collection('users')
        .then((Users) => {
          user.employers.push(newEmployer);
          return Users.save(user);
        })
        .then(() => {
          res.status(200).json(userModel.stripSensitiveDataForResponse(user));
        });
      })
      .catch((error) => {
        return prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
        })
      });
    }
  },

  '/logOut': {
    /**
     * Logs the user out and clears the session cookie.
     */
    get: (req, res) => {
      // req.logout();
      // http://stackoverflow.com/questions/13758207/why-is-passportjs-in-node-not-removing-session-on-logout
      req.session.destroy(function (err) {
        if(err) {
          console.log("Err removing session, ", err);
        }
        res.clearCookie('connect.sid');
        res.status(200).json({message: "Successfully logged out"});
        return;
      });
    }
  },

  '/defaultExpenditureCategories': {
    /**
     * Gets the default categories, not user-specific.
     */
    get: (req, res) => {
      collection('expenditureCategories')
      .then((ExpenditureCategories) => {
        return ExpenditureCategories.find({}).toArray();
      })
      .then((defaultCategories: expenditureCategory[]) => {
        const defaultCategoriesForResponse = defaultCategories.map(expenditureCategoryModel.stripSensitiveDataForResponse);
        res.status(200).json(defaultCategoriesForResponse);
      })
      .catch((err) => {
        res.status(400).json({
          message: "Cannot get default services from DB",
          errorCode: errorCodes.internalError
        });
      });
    }
  },

  '/defaultColors': {
    /**
     * Gets the default colors from the database, not user-specific.
     */
    get: (req, res) => {
      return collection('colors')
      .then((Colors) => {
        return Colors.find({}).toArray();
      })
      .then((colors) => {
        res.status(200).json(colors.map(renameMongoIDField));
      })
      .catch((error) => {
        prepareErrorForFrontend(error)
        .then((error) => {
          res.status(400).json(error);
        });
      });
    }
  }
}
