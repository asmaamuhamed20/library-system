
The Library System is a backend application that allows users to manage books, borrow and return them, and leave reviews. It includes features like user authentication, book management, and a review system.

## Cloning the Repository

To clone this repository and run the application locally, follow these steps:

1. **Clone the Repository:**

   git clone https://github.com/your-username/library-system.git

2. **Navigate to the Project Directory:**
   cd library-system
3. **Install Dependencies:**
  bundle install
4. **Set Up the Database:**
   rails db:create
  rails db:migrate

5.**Start the Server:**
  rails server

The application will be available at http://localhost:3000.


**How to Use the Application**
User Registration
Register a New User:

Send a POST request to /api/v1/users with the following JSON body:
{
  "user": {
    "email": "user@example.com",
    "password": "password",
    "password_confirmation": "password"
  }
}

   
