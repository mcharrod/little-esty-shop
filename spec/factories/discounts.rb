FactoryBot.define do
  factory :discount do
    min_quantity { 1 }
    percent { 1 }
    merchant { nil }
  end
end
