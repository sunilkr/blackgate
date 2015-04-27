# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    sha1 "MyString"
    title "MyString"
    createdOn "2014-11-05"
    updatedOn "2014-11-05"
    type ""
    mimeType "MyString"
    size 1
    file "MyString"
  end
end
