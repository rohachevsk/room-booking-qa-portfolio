# Postman API Tests

This directory contains the Postman collection used for REST API testing of the Room Booking Service.

## Coverage

The collection covers:

- Authentication and user registration
- Login and JWT authorization
- Role-based access control
- Room retrieval and filtering
- Room creation
- Booking creation
- Booking conflict validation
- Concurrent booking scenarios
- User booking retrieval
- Booking cancellation
- IDOR protection

## Environment Variables

The collection uses environment variables for dynamic test data:

- `{{baseUrl}}`
- `{{userToken}}`
- `{{adminToken}}`
- `{{bookingId}}`

JWT tokens are automatically captured from authentication responses and reused by subsequent requests.

## Usage

1. Start the Room Booking Service locally.
2. Import the Postman collection.
3. Configure the environment variables.
4. Run authentication requests to obtain JWT tokens.
5. Execute the API requests individually or using the Postman Collection Runner.
