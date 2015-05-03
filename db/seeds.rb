Tag.destroy_all
File.read("#{Rails.root}/db/tags.txt").split("\n\n").each do |tag|
  name, explanation = tag.split(":")
  Tag.create!(name: name, explanation: explanation)
end

# user = User.last
# 
# 20.times do 
#   p 'DO something'
#   attrs = { 
#     title: Faker::Lorem.sentence, 
#     body: Faker::Lorem.sentence(5), 
#   }
#   question = user.questions.build(attrs)
#   question.save!
# end