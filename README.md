# Demo
Demo is live here: https://gold-exchange.herokuapp.com/

# Setup
Bundle with `bundle install`
and then setup database with  `rake db:setup`

**By default app will provided**
  - Admin account with
    email: `admin@example.com`
    password: `adminadmin`
  - Asset names `GOLD` in price `10 USD`
  - Default currency is `USD` and now only support `USD` and `THB`, the exchange rate is  `1USD = 40THB`

# Api Routes
| Route | Method | Description | Authenticate |
| ------ | ------ | ------ | ------ |
| /api/register | POST | Register user | False |
| /api/token | POST | Get authenticate token | False |
| /api/balances | GET | List balance of user| True |
| /api/transactions | GET | List all transaction of user | True |
| /api/transactions/buy | POST | Buy asset | True |
| /api/transactions/sell | POST | Sell asset | True |
| /api/transactions/top_up | POST | Top up request (wait for admin to approve) | True |
| /api/transactions/withdraw | POST | Withdraw request (wait for admin to approve) | True |

# Web Client Routes
| Route | Description |
| ------ | ------ |
| /users/sign_in | Sign in |
| /admin/transactions | Admin manage transactions |

## Request parameter format on each routes
**/api/register**

Request format :
```
{
    "user": {
        "email": "test@example.com",
        "password": "12345678"
    }
}
```
Output format :
```
{
    "id": 2,
    "email": "test@example.com",
    "admin": false
}
```
----
**/api/token**

Request format :
```
{
    "email": "test@example.com",
    "password": "12345678",
    "grant_type": "password"
}
```
Output format :
```
{
    "access_token": "79d1a66b01e12aa4e76abc7300c97f8650fc36df8ef77c8935e79e8f51713241",
    "token_type": "Bearer",
    "expires_in": 432000,
    "created_at": 1545581626
}
```
----
## **Note**
On routes that require authenticate should add access token on header by using key `Authorization` with value in format :
```
Bearer 79d1a66b01e12aa4e76abc7300c97f8650fc36df8ef77c8935e79e8f51713241
```
----
**/api/transactions/buy**

Request format :
```
{ "asset_name": "GOLD" }
```
Output format :
```
{
    "id": 1,
    "name": "5T8G9teuYZRRDePS7KEYog",
    "type": "buy",
    "amount": "10.00",
    "created_at": "2018-12-23T16:20:06.339Z",
    "asset": "GOLD"
}
```
----
**/api/transactions/sell**

Request format :
```
{ "asset_name": "GOLD" }
```
Output format :
```
{
    "id": 1,
    "name": "LfPadFgqvZetU1QsoU6zkQ",
    "type": "sell",
    "amount": "10.00",
    "created_at": "2018-12-23T16:20:06.339Z",
    "asset": "GOLD"
}
```
----
**/api/transactions/top_up**

Request format :
```
{
    "amount": 1000,
    "currency": "THB"
}
```
Currency is optional, if not request with specific currecy will use default currency (USD).
```
{ "amount": 1000 }
```

Output format :
```
{
    "id": 2,
    "name": "LfPadFgqvZetU1QsoU6zkQ",
    "type": "top_up",
    "amount": "1,000.00",
    "created_at": "2018-12-23T16:29:35.153Z",
    "asset": "cash",
    "approved": false
}
```
----
**/api/transactions/withdraw**

Request format :
```
{
    "amount": 1000,
    "currency": "THB"
}
```
Currency is optional, if not request with specific currecy will use default currency (USD).
```
{ "amount": 1000 }
```

Output format :
```
{
    "id": 2,
    "name": "LfPadFgqvZetU1QsoU6zkQ",
    "type": "withdraw",
    "amount": "1,000.00",
    "created_at": "2018-12-23T16:29:35.153Z",
    "asset": "cash",
    "approved": false
}
```
