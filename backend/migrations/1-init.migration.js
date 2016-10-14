/**
 * The default expenditure categories to populate the database.
 */
const defaultExpenditureCategories = [
  {
    name: "Groceries"
  },
  {
    name: "Rent",
  },
  {
    name: "Drugs"
  },
  {
    name: "Concerts"
  },
  {
    name: "Video Games"
  },
  {
    name: "Athletics"
  },
  {
    name: "Education"
  },
  {
    name: "Eating out"
  },
  {
    name: "Gambling"
  },
  {
    name: "Other"
  }
]


db.expenditureCategories.insert(defaultExpenditureCategories);
