const db = require("../database");

test("Database connection works", async () => {
  const result = await db.query("SELECT NOW();");
  expect(result[0]).toBeDefined();
});