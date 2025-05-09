const express = require("express");
const sql = require("mssql");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const port = 3000;

// Middleware to parse JSON requests and enable CORS
app.use(cors()); // Enable CORS for all routes
app.use(bodyParser.json()); // Parse JSON bodies

// Database connection configuration
const dbConfig = {
    server: 'MIANZAIN',  
    authentication: {
        type: 'default',
        options: {
            userName: 'sa',  
            password: '07022004'  
        }
    },
    options: {
        encrypt: true,  
        database: 'WHEELISTER',
        trustServerCertificate: true,
        connectTimeout: 30000 // 30 seconds timeout
    }
};

// Connect to database
sql.connect(dbConfig)
    .then(() => console.log("Connected to SQL Server"))
    .catch(err => console.log("Database Connection Error:", err));
// Signup route using stored procedure
app.post("/signup", async (req, res) => { // "/signup" is the endpoint for signup and async used for asynchronous operations
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ message: "All fields are required" });
    }

    try {
        const pool = await sql.connect(dbConfig); 
        const result = await pool // await is used to wait for the promise to resolve
            .request()
            .input("Username", sql.NVarChar, username)
            .input("Password", sql.NVarChar, password)
            .execute("RegisterUser"); // Calling the stored procedure

        res.status(201).json({ message: "User registered successfully" });
    } catch (error) {
        console.error("Signup Error:", error);
        res.status(500).json({ message: "Internal Server Error" });
    }
});

app.post("/login", async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ success: false, message: "Username and password required" });
    }

    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool
            .request()
            .input("Username", sql.NVarChar, username)
            .input("Password", sql.NVarChar, password)
            .execute("CheckUserLogin"); // Call stored procedure

        if (result.recordset.length === 0) {
            return res.status(401).json({ success: false, message: "Invalid username or password" });
        }

        res.json({ success: true, message: "Login successful" });
    } catch (error) {
        console.error("Login Error:", error);
        res.status(500).json({ success: false, message: "Internal Server Error" });
    }
});
app.post("/getuser", async (req, res) => {
    console.log("POST /getuser called");
    const { username } = req.body;
  
    if (!username) return res.status(400).json({ success: false, message: "Username required" });
  
    try {
      const pool = await sql.connect(dbConfig);
      const result = await pool
        .request()
        .input("Username", sql.NVarChar, username)
        .query("SELECT username, email, mobilenumber AS phone, location FROM Users WHERE username = @Username");
  
      if (result.recordset.length > 0) {
        res.json({ success: true, data: result.recordset });
      } else {
        res.json({ success: false, message: "User not found" });
      }
    } catch (error) {
      console.error("DB error:", error);
      res.status(500).json({ success: false, message: "Internal server error" });
    }
  });

  
// Search user route
app.post("/search", async (req, res) => {
    const { username } = req.body;
    console.log("Received username:", username); // 🔍

    if (!username) {
        return res.status(400).json({ success: false, message: "Username is required" });
    }

    try {
        const pool = await sql.connect(dbConfig);
        console.log("DB Connected ✅");

        const result = await pool
            .request()
            .input("Username", sql.NVarChar, username)
            .query("SELECT car_name, car_miles,car_booking_price FROM cars WHERE car_name LIKE '%' + @Username + '%'")


        console.log("Query Result:", result.recordset); // 🔍

        if (result.recordset.length > 0) {
            res.json({ success: true, data: result.recordset });
        } else {
            res.json({ success: false, message: "No users found." });
        }
    } catch (error) {
        console.error("Search Error:", error); // 🔥
        res.status(500).json({ success: false, message: "Internal Server Error" });
    }
});

app.post("/getuser", async (req, res) => {
    console.log("POST /getuser called");
    const { username } = req.body;

    if (!username) return res.status(400).json({ success: false, message: "Username required" });

    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool
            .request()
            .input("Username", sql.NVarChar, username)
            .query("SELECT username, email, mobilenumber AS phone, location FROM Users WHERE username = @Username");

        if (result.recordset.length > 0) {
            res.json({ success: true, data: result.recordset });
        } else {
            res.json({ success: false, message: "User not found" });
        }
    } catch (error) {
        console.error("DB error:", error);
        res.status(500).json({ success: false, message: "Internal server error" });
    } finally {
        sql.close(); // Ensure the connection is closed
    }
});

// Assuming you are using Express and a MongoDB database
app.post("/updateuser", async (req, res) => {
    const { username, email, phone, location } = req.body;
  
    if (!username || !email || !phone || !location) {
      return res.status(400).json({ success: false, message: "All fields are required." });
    }
  
    try {
      const pool = await sql.connect(dbConfig);
      const result = await pool
        .request()
        .input("Username", sql.NVarChar, username)
        .input("Email", sql.NVarChar, email)
        .input("MobileNumber", sql.NVarChar, phone)
        .input("Location", sql.NVarChar, location)
        .query(`
          UPDATE Users
          SET email = @Email, mobilenumber = @MobileNumber, location = @Location
          WHERE username = @Username
        `);
  
      if (result.rowsAffected[0] > 0) {
        res.json({ success: true, message: "User updated successfully." });
      } else {
        res.json({ success: false, message: "No user found or no changes made." });
      }
    } catch (error) {
      console.error("Update error:", error); // 🔥 log it
      res.status(500).json({ success: false, message: "Server error." });
    }
  });
  
  app.post("/search-warehouse", async (req, res) => {
    const { location } = req.body;

    if (!location) {
        return res.status(400).json({ success: false, message: "Location is required" });
    }

    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool
            .request()
            .input("Location", sql.NVarChar, location)
            .query("SELECT warehouse_no, warehouse_name, address,phonenumber FROM warehouse WHERE warehouse_name LIKE '%' + @Location + '%'");

        if (result.recordset.length > 0) {
            res.json({ success: true, data: result.recordset });
        } else {
            res.json({ success: false, message: "No warehouses found." });
        }
    } catch (error) {
        console.error("Warehouse Search Error:", error);
        res.status(500).json({ success: false, message: "Internal Server Error" });
    }
});


app.post("/book", async (req, res) => {
    console.log("Working");

    const {
        car_name,
        pickup_date,
        return_date,
        rental_period,
        pickup_location,
        total_price,
        username // Make sure this comes from frontend
    } = req.body;
console.log(username);
    if (!car_name || !pickup_date || !return_date || !pickup_location || !rental_period || !total_price || !username) {
        return res.status(400).json({ success: false, message: "All fields are required, including username and total price." });
    }

    try {
        const pool = await sql.connect(dbConfig);
        
        // Step 1: Get userID from users table using username
        const userResult = await pool
            .request()
            .input("Username", sql.NVarChar, username)
            .query("SELECT userID FROM users WHERE username = @Username");

        if (userResult.recordset.length === 0) {
            return res.status(404).json({ success: false, message: "User not found." });
        }

        const userID = userResult.recordset[0].userID;
        console.log('User ID:', userID);
        // Step 2: Insert booking with userID
        const bookingResult = await pool
            .request()
            .input("UserID", sql.Int, userID)
            .input("CarName", sql.NVarChar, car_name)
            .input("PickupDate", sql.Date, pickup_date)
            .input("ReturnDate", sql.Date, return_date)
            .input("RentalPeriod", sql.NVarChar, rental_period)
            .input("PickupLocation", sql.NVarChar, pickup_location)
            .input("TotalPrice", sql.NVarChar, total_price)
            .query(`
                INSERT INTO car_bookings (userID, car_name, pickup_date, return_date, rental_period, pickup_location, booking_date, total_price)
                VALUES (@UserID, @CarName, @PickupDate, @ReturnDate, @RentalPeriod, @PickupLocation, GETDATE(), @TotalPrice);
                SELECT SCOPE_IDENTITY() AS BookingID;
            `);

        const bookingId = bookingResult.recordset[0].BookingID;

        res.status(201).json({
            success: true,
            message: `Booking for ${car_name} has been successfully created.`,
            booking_id: bookingId,
            user_id: userID,
            car_name,
            pickup_date,
            return_date,
            total_price,
            userID

        });

    } catch (error) {
        console.error("Error booking the car:", error);
        res.status(500).json({ success: false, message: "Internal server error." });
    }
});

app.get("/bookings", async (req, res) => {
    try {
        const pool = await sql.connect(dbConfig);
        const result = await pool
            .request()
            .query("SELECT * from car_bookings");

        if (result.recordset.length > 0) {
            res.json({ success: true, data: result.recordset });
        } else {
            res.json({ success: false, message: "No bookings found." });
        }
    } catch (error) {
        console.error("Error fetching bookings:", error);
        res.status(500).json({ success: false, message: "Internal Server Error" });
    }
});

app.post('/warehouse-cars', async (req, res) => {
    const { warehouse_no } = req.body;
    console.log('Received warehouse_no:', warehouse_no);

    try {
        const pool = await sql.connect(dbConfig);

        const result = await pool
        .request()
            .input('warehouse_no', sql.VarChar, warehouse_no)
            .query(`
                SELECT 
                    c.car_name, 
                    c.car_miles, 
                    c.car_booking_price, 
                    w.warehouse_name, 
                    w.address, 
                    w.phonenumber
                FROM 
                    cars c
                JOIN 
                    warehouse w ON c.warehouse_no = w.warehouse_no
                WHERE 
                    c.warehouse_no = @warehouse_no
            `);

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error('Warehouse Cars Fetch Error:', error);
        res.status(500).json({ success: false, message: 'Internal server error' });
    }
});

app.post("/add-warehouse", async (req, res) => {
    const { warehouse_name, address, phonenumber } = req.body;

    if (!warehouse_name || !address || !phonenumber) {
        return res.status(400).json({ success: false, message: "All fields are required." });
    }

    try {
        const pool = await sql.connect(dbConfig);

        // Insert warehouse data into the warehouse table
        const result = await pool
            .request()
            .input("WarehouseName", sql.NVarChar, warehouse_name)
            .input("Address", sql.NVarChar, address)
            .input("PhoneNumber", sql.NVarChar, phonenumber)
            .query(`
                INSERT INTO warehouse (warehouse_name, address, phonenumber)
                VALUES (@WarehouseName, @Address, @PhoneNumber);
                SELECT SCOPE_IDENTITY() AS WarehouseNo;
            `);

        const warehouseNo = result.recordset[0].WarehouseNo;

        res.status(201).json({
            success: true,
            message: `Warehouse "${warehouse_name}" has been successfully added.`,
            warehouse_no: warehouseNo,
            warehouse_name,
            address,
            phonenumber
        });
    } catch (error) {
        console.error("Error adding warehouse:", error);
        res.status(500).json({ success: false, message: "Internal server error" });
    }
});

app.post("/add-car", async (req, res) => {
    const { car_name, car_miles, car_booking_price, warehouse_name } = req.body;
    console.log('Received data:', req.body);  // Log the incoming data

    try {
        const pool = await sql.connect(dbConfig);

        // Fetch warehouse_no using the warehouse_name
        const warehouseResult = await pool
            .request()
            .input('WarehouseName', sql.NVarChar, warehouse_name)
            .query('SELECT warehouse_no FROM warehouse WHERE warehouse_name = @WarehouseName');
        
        if (warehouseResult.recordset.length === 0) {
            return res.status(400).json({ message: 'Warehouse not found' });
        }

        const warehouse_no = warehouseResult.recordset[0].warehouse_no;
        console.log('Found warehouse no:', warehouse_no);  // Log warehouse no

        // Get the last car_no from the cars table
        const lastCarResult = await pool
            .request()
            .query('SELECT MAX(car_no) AS last_car_no FROM cars');

        const lastCarNo = lastCarResult.recordset[0].last_car_no || 0;
        const car_no = lastCarNo + 1;

        // Insert new car data into the cars table
        await pool
            .request()
            .input('CarNo', sql.Int, car_no)
            .input('CarName', sql.NVarChar, car_name)
            .input('CarMiles', sql.Int, car_miles)
            .input('CarBookingPrice', sql.Decimal, car_booking_price)
            .input('WarehouseNo', sql.Int, warehouse_no)
            .query(`
                INSERT INTO cars (car_no, car_name, car_miles, car_booking_price, warehouse_no)
                VALUES (@CarNo, @CarName, @CarMiles, @CarBookingPrice, @WarehouseNo)
            `);

        console.log('Car added successfully');
        res.status(200).json({ message: 'Car added successfully', car_no });
    } catch (error) {
        console.error('Error adding car:', error);
        res.status(500).json({ message: 'Error adding car' });
    }
});

app.get("/all-cars", async (req, res) => {
    try {
      const pool = await sql.connect(dbConfig);
      const result = await pool
        .request()
        .query("SELECT car_no, car_name, car_miles, car_booking_price, warehouse_no FROM cars");
  
      if (result.recordset.length > 0) {
        res.json({ success: true, data: result.recordset });
      } else {
        res.json({ success: false, message: "No cars found" });
      }
    } catch (error) {
      console.error("Error fetching all cars:", error);
      res.status(500).json({ success: false, message: "Internal server error" });
    }
  });
  

  app.post("/update-username", async (req, res) => {
    const { oldUsername, newUsername } = req.body;

    if (!oldUsername || !newUsername) {
        return res.status(400).json({ success: false, message: "Both old and new usernames are required." });
    }

    try {
        const pool = await sql.connect(dbConfig);

        const result = await pool
            .request()
            .input("OldUsername", sql.NVarChar, oldUsername)
            .input("NewUsername", sql.NVarChar, newUsername)
            .query(`
                UPDATE Users
                SET username = @NewUsername
                WHERE username = @OldUsername
            `);

        if (result.rowsAffected[0] > 0) {
            res.json({ success: true, message: "Username updated successfully." });
        } else {
            res.json({ success: false, message: "Old username not found or no change made." });
        }
    } catch (error) {
        console.error("Username update error:", error);
        res.status(500).json({ success: false, message: "Internal server error." });
    }
});

app.post("/change-password", async (req, res) => {
    const { username, oldPassword, newPassword } = req.body;

    if (!username || !oldPassword || !newPassword) {
        return res.status(400).json({ success: false, message: "Username, old password, and new password are required." });
    }

    try {
        const pool = await sql.connect(dbConfig);

        // First, check if the username and old password match
        const checkResult = await pool
            .request()
            .input("Username", sql.NVarChar, username)
            .input("OldPassword", sql.NVarChar, oldPassword)
            .query(`
                SELECT * FROM Users
                WHERE username = @Username AND password = @OldPassword
            `);

        if (checkResult.recordset.length === 0) {
            return res.status(401).json({ success: false, message: "Old password is incorrect or user not found." });
        }

        // Proceed to update the password
        const updateResult = await pool
            .request()
            .input("Username", sql.NVarChar, username)
            .input("NewPassword", sql.NVarChar, newPassword)
            .query(`
                UPDATE Users
                SET password = @NewPassword
                WHERE username = @Username
            `);

        if (updateResult.rowsAffected[0] > 0) {
            res.json({ success: true, message: "Password updated successfully." });
        } else {
            res.json({ success: false, message: "Password update failed." });
        }

    } catch (error) {
        console.error("Password update error:", error);
        res.status(500).json({ success: false, message: "Internal server error." });
    }
});


app.post("/change-admin-password", async (req, res) => {
    const { adminName, oldPassword, newPassword } = req.body;

    // Check if fields are provided
    if (!adminName || !oldPassword || !newPassword) {
        return res.status(400).json({ success: false, message: "Admin name, old password, and new password are required." });
    }

    try {
        const pool = await sql.connect(dbConfig);

        const checkResult = await pool
            .request()
            .input("AdminName", sql.NVarChar, adminName)
            .input("OldPassword", sql.NVarChar, oldPassword)
            .query(`
                SELECT * FROM admins
                WHERE admin_name = @AdminName AND password = @OldPassword
            `);

        if (checkResult.recordset.length === 0) {
            return res.status(401).json({ success: false, message: "Old password is incorrect or admin not found." });
        }

        const updateResult = await pool
            .request()
            .input("AdminName", sql.NVarChar, adminName)
            .input("NewPassword", sql.NVarChar, newPassword)
            .query(`
                UPDATE admins
                SET password = @NewPassword
                WHERE admin_name = @AdminName
            `);

        if (updateResult.rowsAffected[0] > 0) {
            res.json({ success: true, message: "Admin password updated successfully." });
        } else {
            res.json({ success: false, message: "Password update failed." });
        }
    } catch (error) {
        console.error("Admin password update error:", error);
        res.status(500).json({ success: false, message: "Internal server error." });
    }
});







// Start server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});