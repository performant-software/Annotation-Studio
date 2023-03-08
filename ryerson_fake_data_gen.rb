x = 0
while x < 100 do
  User.create(
    firstname: 'Testy',
    lastname: 'Mc' + x.to_s + 'face',
    email: ((0...8).map { (65 + rand(26)).chr }.join) + '@ryerson.edu',
    agreement: true,
    password: 'very secure'
end