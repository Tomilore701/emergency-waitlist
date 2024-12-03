const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 3000;

const pool = new Pool({
    host: "127.0.0.1",
    port: "5432",
    user: "postgres",
    password: "moimeme",
    database: "emergency_waitlist"
});


// GET /getAllPatients - Fetch all patients (for admin access)
app.get('/getAllPatients', async (req, res) => {
    try {
        const client = await pool.connect();
        const result = await client.query('SELECT * FROM Patients');
        res.json(result.rows);  // Return all patients data
        client.release();
    } catch (err) {
        console.error('Error fetching all patients:', err.stack);
        res.status(500).send('Server error');
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
