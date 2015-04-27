# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample_datum, :class => 'SampleData' do
    samples nil
    sha1 "MyString"
    md5 "MyString"
    ssdeep "MyString"
    type ""
    size 1
    key "MyString"
    file "MyString"
  end
end
