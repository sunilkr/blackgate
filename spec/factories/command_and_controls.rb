# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :command_and_control do
    domain "MyString"
    ip "MyString"
    protocol "MyString"
    port 1
    first_access "2014-09-30"
    last_access "2014-09-30"
  end
end
