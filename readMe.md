# Good Night App

The Good Night App is a sleep tracking application that allows users to track their bedtime and wake-up time. It provides RESTful APIs for clock-in operations, user follows, and retrieving sleep records.

## Features

- Clock-in operation to record bedtime
- Follow and unfollow other users
- Retrieve sleep records of followed users, sorted by sleep duration

## Installation

1. Clone the repository:

   ```bash
   git clone git@github.com:phonehtetpaing/good_night.git
   ```

2. Install dependencies:

   ```bash
   cd good-night
   bundle install
   ```

3. Set up the database:

    ```bash
    rails db:setup
    ```

4. Run database migrations:

    ```bash
    rails db:migrate
    ```

5. Seed the database with sample data:

    ```bash
    rails db:seed
    ```

## API Endpoints

The following API routes are available:

### Sleep Records

- `POST /sleep_records/clock_in`: Creates a new sleep record entry for the current user.
- `GET /sleep_records`: Retrieves all sleep records, ordered by creation time.

### Users

- `POST /users/:id/follow`: Follows a specific user identified by `:id`.
- `DELETE /users/:id/unfollow`: Unfollows a specific user identified by `:id`.
- `GET /users/:id/followed_sleep_records`: Retrieves sleep records of all users followed by the specified user. The records are sorted based on the duration of their sleep length.

## Authentication

To make API call secured, JWT (JSON Web Tokens) authentication has been added. Since User registration APIs are not implemented, we will mock that in this project. The focus is on the functionality of tracking sleep records and following/unfollowing users.

## Mocking JWT

To facilitate testing and meet the requirement of not implementing user registration API, the Good Night App includes a mock JWT token for authentication. This allows you to test protected endpoints without the need for actual user authentication.

The mock JWT token is generated using a predefined secret key and includes a user ID. Here's an example of how to include the mock JWT token in your tests:

```ruby
let(:user) { create(:user) }
let(:jwt_token) { JWT.encode({ user_id: user.id }, 'mocked_secret_key', 'HS256') }

it 'returns the sleep records' do
  get '/users/1/followed_sleep_records', headers: { 'Authorization' => "Bearer #{jwt_token}" }

  # Rest of the test assertions
end
```

By including the mock JWT token in the request headers, you can simulate authenticated requests without the need for user registration.

Note: In a real production environment, proper user authentication and token generation would be implemented. The mock JWT token is provided solely for testing purposes.

## Serialization

The application utilizes serializers to format API responses. The sleep records and other data are serialized using JSONAPI rules to provide a consistent and standardized response format.

1. Successful Sleep Record Creation Response:

    ```ruby
    {
        "data": {
            "id": "1",
            "type": "sleep_records",
            "attributes": {
            "start_time": "2023-06-10T22:00:00Z",
            "end_time": "2023-06-11T06:00:00Z"
            },
            "relationships": {
            "user": {
                "data": {
                "id": "1",
                "type": "users"
                }
            }
            }
        }
    }
    ```

2. Get All Sleep Records Response:

    ```ruby
    {
        "data": [
            {
            "id": "1",
            "type": "sleep_records",
            "attributes": {
                "start_time": "2023-06-10T22:00:00Z",
                "end_time": "2023-06-11T06:00:00Z"
            },
            "relationships": {
                "user": {
                "data": {
                    "id": "1",
                    "type": "users"
                }
                }
            }
            },
            {
            "id": "2",
            "type": "sleep_records",
            "attributes": {
                "start_time": "2023-06-11T23:30:00Z",
                "end_time": "2023-06-12T07:30:00Z"
            },
            "relationships": {
                "user": {
                "data": {
                    "id": "1",
                    "type": "users"
                }
                }
            }
            }
        ]
    }
    ```

3. Follow/Unfollow User Success Response:

    ```ruby
    {
        "data": {
            "status": "success",
            "message": "User followed" # User unfollowed
        }
    }
    ```

4. Example Error Response:

    ```ruby
    {
        "errors": [
            {
            "status": "401",
            "title": "Unauthorized",
            "detail": "Invalid authentication token"
            }
        ]
    }
    ```


## Testing

The project includes a comprehensive suite of RSpec tests to ensure the correctness of the implemented functionality. You can run the tests using the following command:

```ruby
bundle exec rspec
```

## Postman Collection

A Postman collection is available for easy testing and exploration of the API endpoints. You can import the provided Postman collection file (good-night-postman-collection.zip) into your Postman application to access the pre-configured requests.

You will need to have some initial data for testing and demonstration purposes, You can run the seed task using the following command:

```ruby
rails db:seed
```

## Commit History

The development of the Good Night App is documented through a series of commits in the GitHub repository. Each commit represents a specific change or feature implementation.
