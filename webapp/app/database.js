const { Pool } = require('pg');

// Setup DB connection
const connectionPool = new Pool({
  host: process.env.DATABASE_HOST,
  user: process.env.DATABASE_USERNAME,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
  port: 5432, // Default PostgreSQL port
});

module.exports = connectionPool;