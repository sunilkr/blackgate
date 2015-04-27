# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cnc_traffic do
    sample nil
    command_and_control nil
    access_date "2014-09-30"
    url "MyString"
    data ""
  end
end
