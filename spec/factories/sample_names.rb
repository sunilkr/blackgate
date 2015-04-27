# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample_name do
    samples nil
    incidents nil
    name "MyString"
    reportedOn "2014-09-22"
  end
end
