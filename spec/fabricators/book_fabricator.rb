Fabricator(:book) do
  user
  votes(count: 5)
  author {FFaker::Name.name}
  summary {FFaker::Lorem.paragraph }
  title {FFaker::Product.product_name }
  cover { FFaker.Avatar.image }
end