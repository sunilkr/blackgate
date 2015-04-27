# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incident do
    title "MyString"
    description "MyString"
    reportedOn "2014-09-18 09:56:43"
    reportedBy "MyString"
    status "MyString"
  end
end
