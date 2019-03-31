myuser = Jinda::User.last.id
1000000.times do |count|
  Todo.create(
    title: Faker::Verb.base,
    due: Faker::Date.forward(100),
    completed: Faker::Boolean.boolean,
    user_id: myuser
  )
  puts "Sample data created #{count} of 1,000,000 records"
end

