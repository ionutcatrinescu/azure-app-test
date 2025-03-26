const express = require("express");
const db = require("./database");
const path = require("path");

const app = express();
app.use(express.urlencoded({ extended: true })); // Middleware to handle form data
app.use(express.json()); // Middleware to handle JSON data


// Serve static files with correct MIME types
app.use(express.static(path.join(__dirname), {
  setHeaders: (res, filePath) => {
    if (filePath.endsWith('.css')) {
      res.setHeader('Content-Type', 'text/css');
    }
  }
}));

// Serve the static UI (HTML file)
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "ui.html")); // Serve the UI file
});

// Health check endpoint
app.get("/health", (req, res) => {
  res.status(200).send("Application is Healthy!");
});

// Test database connection
app.get("/db-test", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.send(`Database connection successful! Server time: ${result.rows[0].now}`);
  } catch (err) {
    console.error("Database connection error:", err);
    res.status(500).send("Database connection failed.");
  }
});

// API route to create a new user
app.post("/add-user", async (req, res) => {
  const { name, email } = req.body;
  try {
    const result = await db.query("INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *", [name, email]);
    res.send(`User added: ${JSON.stringify(result.rows[0])}`);
  } catch (error) {
    console.error("Error inserting user into database:", error);
    res.status(500).send("Error adding user");
  }
});

// API route to fetch all users
app.get("/users", async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (error) {
    console.error("Error fetching users from database:", error);
    res.status(500).send("Error fetching users");
  }
});

// Start the server
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`App is running on http://localhost:${PORT}`);
});