/**
 * The default expenditure categories to populate the database.
 */
const defaultExpenditureCategories = [
  {
    name: "Groceries",
    color: "#893302"
  },
  {
    name: "Rent",
    color: "#082932"
  },
  {
    name: "Casual Spending",
    color: "#ad0211"
  }
]


db.expenditureCategories.insert(defaultExpenditureCategories);
