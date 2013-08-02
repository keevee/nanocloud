FactoryGirl.define do
  to_create do |instance|
    unless instance.save
      raise "Invalid record: " + instance.errors.full_messages.join(", ")
    end
  end

  factory :website do |w|
  end

  factory :user do |u|
  end
end
