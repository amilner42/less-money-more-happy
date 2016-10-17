/**
 * The default expenditure categories to populate the database.
 */
const defaultExpenditureCategories = [
  {
    name: "groceries"
  },
  {
    name: "rent",
  },
  {
    name: "drugs"
  },
  {
    name: "concerts"
  },
  {
    name: "video games"
  },
  {
    name: "athletics"
  },
  {
    name: "education"
  },
  {
    name: "eating out"
  },
  {
    name: "gambling"
  },
  {
    name: "other"
  },
  {
    name: "fashion"
  },
  {
    name: "clothing"
  },
  {
    name: "charity"
  },
  {
    name: "investing"
  },
  {
    name: "going out"
  },
  {
    name: "drinks"
  },
  {
    name: "weed"
  },
  {
    name: "cigarettes"
  },
  {
    name: "tobacco"
  },
  {
    name: "flights"
  },
  {
    name: "vacation"
  },
  {
    name: "family"
  },
  {
    name: "mortgage"
  }
];


/**
 * Manually copied from: http://cloford.com/resources/colours/500col.htm
 *
 * Please run in a shell when you update these, outputs MUST be equal.
 * - With fields
 *   - db.getCollection('colors').count({"_id": {$exists: true}, "name": { $exists: true}, "hex": {$exists: true}, "defaultColor": { $exists: true}, "dark": { $exists: true} })
 * - In database (all)
 *   - db.getCollection('colors').count({})
 *
 *   --> Makes sure no missing fields.
1-init.migration.js*/
const defaultColors = [
  {
    name: "pink",
    hex: "#FFC0CB",
    defaultColor: true,
    dark: false
  },
  {
    name: "indian red",
    hex: "#B0171F",
    defaultColor: false,
    dark: true
  },
  {
    name: "pale violet red",
    hex: "#DB7093",
    defaultColor: false,
    dark: false
  },
  {
    name: "violet red",
    hex: "#FF3E96",
    defaultColor: false,
    dark: false
  },
  {
    name: "hot pink",
    hex: "#FF69B4",
    defaultColor: false,
    dark: false
  },
  {
    name: "raspberry",
    hex: "#872657",
    defaultColor: true,
    dark: true
  },
  {
    name: "deep pink",
    hex: "#FF1493",
    defaultColor: true,
    dark: false
  },
  {
    name: "maroon",
    hex: "#CD2990",
    defaultColor: false,
    dark: true
  },
  {
    name: "orchid",
    hex: "#DA70D6",
    defaultColor: false,
    dark: false
  },
  {
    name: "dark orchid",
    hex: "#8B4789",
    defaultColor: false,
    dark: true
  },
  {
    name: "thistle",
    hex: "#D8BFD8",
    defaultColor: false,
    dark: false
  },
  {
    name: "plum",
    hex: "#FFBBFF",
    defaultColor: false,
    dark: false
  },
  {
    name: "magenta",
    hex: "#FF00FF",
    defaultColor: false,
    dark: false
  },
  {
    name: "dark magenta",
    hex: "#8B008B",
    defaultColor: false,
    dark: true
  },
  {
    name: "purple",
    hex: "#800080",
    defaultColor: false,
    dark: true
  },
  {
    name: "dark violet",
    hex: "#9400D3",
    defaultColor: true,
    dark: true
  },
  {
    name: "indigo",
    hex: "#4B0082",
    defaultColor: true,
    dark: true
  },
  {
    name: "slate blue",
    hex: "#6A5ACD",
    defaultColor: true,
    dark: true
  },
  {
    name: "lavender",
    hex: "#E6E6FA",
    defaultColor: false,
    dark: false
  },
  {
    name: "blue",
    hex: "#0000FF",
    defaultColor: false,
    dark: true
  },
  {
    name: "navy",
    hex: "#000080",
    defaultColor: true,
    dark: true
  },
  {
    name: "midnight blue",
    hex: "#191970",
    defaultColor: false,
    dark: true
  },
  {
    name: "cobolt",
    hex: "#3D59AB",
    defaultColor: false,
    dark: true
  },
  {
    name: "royal blue",
    hex: "#4169E1",
    defaultColor: true,
    dark: true
  },
  {
    name: "cornflower blue",
    hex: "#6495ED",
    defaultColor: false,
    dark: false
  },
  {
    name: "steel blue",
    hex: "#4682B4",
    defaultColor: false,
    dark: true
  },
  {
    name: "light sky blue",
    hex: "#87CEFA",
    defaultColor: false,
    dark: false
  },
  {
    name: "sky blue",
    hex: "#87CEFF",
    defaultColor: true,
    dark: false
  },
  {
    name: "deep sky blue",
    hex: "#00BFFF",
    defaultColor: true,
    dark: false
  },
  {
    name: "light blue",
    hex: "#ADD8E6",
    defaultColor: false,
    dark: false
  },
  {
    name: "powder blue",
    hex: "#B0E0E6",
    defaultColor: false,
    dark: false
  },
  {
    name: "turquoise",
    hex: "#00F5FF",
    defaultColor: false,
    dark: false
  },
  {
    name: "dark turquoise",
    hex: "#00CED1",
    defaultColor: true,
    dark: true
  },
  {
    name: "light cyan",
    hex: "#E0FFFF",
    defaultColor: false,
    dark: false
  },
  {
    name: "cyan",
    hex: "#00FFFF",
    defaultColor: false,
    dark: false
  },
  {
    name: "teal",
    hex: "#008080",
    defaultColor: true,
    dark: true
  },
  {
    name: "spring green",
    hex: "#00FF7F",
    defaultColor: false,
    dark: false
  },
  {
    name: "sea green",
    hex: "#54FF9F",
    defaultColor: false,
    dark: false
  },
  {
    name: "emerald green",
    hex: "#00C957",
    defaultColor: true,
    dark: true
  },
  {
    name: "mint",
    hex: "#BDFCC9",
    defaultColor: false,
    dark: false
  },
  {
    name: "dark sea green",
    hex: "#8FBC8F",
    defaultColor: false,
    dark: true
  },
  {
    name: "lime",
    hex: "#00FF00",
    defaultColor: false,
    dark: false
  },
  {
    name: "green",
    hex: "#00EE00",
    defaultColor: false,
    dark: false
  },
  {
    name: "forest green",
    hex: "#228B22",
    defaultColor: true,
    dark: true
  },
  {
    name: "dark green",
    hex: "#006400",
    defaultColor: true,
    dark: true
  },
  {
    name: "dark olive green",
    hex: "#6E8B3D",
    defaultColor: false,
    dark: true
  },
  {
    name: "ivory",
    hex: "#6E8B3D",
    defaultColor: false,
    dark: true
  },
  {
    name: "beige",
    hex: "#F5F5DC",
    defaultColor: false,
    dark: false
  },
  {
    name: "yellow",
    hex: "#FFFF00",
    defaultColor: false,
    dark: false
  },
  {
    name: "warm grey",
    hex: "#808069",
    defaultColor: false,
    dark: false
  },
  {
    name: "cold grey",
    hex: "#808A87",
    defaultColor: true,
    dark: true
  },
  {
    name: "olive",
    hex: "#808000",
    defaultColor: false,
    dark: true
  },
  {
    name: "khaki",
    hex: "#FFF68F",
    defaultColor: false,
    dark: false
  },
  {
    name: "banana",
    hex: "#E3CF57",
    defaultColor: false,
    dark: false
  },
  {
    name: "gold",
    hex: "#FFD700",
    defaultColor: true,
    dark: false
  },
  {
    name: "orange",
    hex: "#EE9A00",
    defaultColor: true,
    dark: false
  },
  {
    name: "wheat",
    hex: "#F5DEB3",
    defaultColor: false,
    dark: false
  },
  {
    name: "eggshell",
    hex: "#FCE6C9",
    defaultColor: false,
    dark: false
  },
  {
    name: "melon",
    hex: "#E3A869",
    defaultColor: false,
    dark: true
  },
  {
    name: "carrot",
    hex: "#ED9121",
    defaultColor: true,
    dark: false
  },
  {
    name: "dark orange",
    hex: "#FF7F00",
    defaultColor: true,
    dark: true
  },
  {
    name: "chocalate",
    hex: "#8B4513",
    defaultColor: true,
    dark: true
  },
  {
    name: "salmon",
    hex: "#FF8C69",
    defaultColor: false,
    dark: false
  },
  {
    name: "dark salmon",
    hex: "#E9967A",
    defaultColor: false,
    dark: true
  },
  {
    name: "tomato",
    hex: "#FF6347",
    defaultColor: true,
    dark: false
  },
  {
    name: "snow",
    hex: "#EEE9E9",
    defaultColor: false,
    dark: false
  },
  {
    name: "dark red",
    hex: "#8B0000",
    defaultColor: false,
    dark: true
  },
  {
    name: "grey",
    hex: "#808080",
    defaultColor: false,
    dark: false
  },
  {
    name: "black",
    hex: "#000000",
    defaultColor: false,
    dark: true
  },
  {
    name: "brown",
    hex: "#A52A2A",
    defaultColor: false,
    dark: true
  }
];


db.expenditureCategories.insert(defaultExpenditureCategories);
db.colors.insert(defaultColors);
