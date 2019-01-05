User.create(
  email: 'admin@example.com',
  password: 'adminadmin',
  admin: true
)

Asset.create(
  name: 'GOLD',
  price: Money.from_amount(10, "USD")
)
