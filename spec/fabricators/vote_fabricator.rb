Fabricator(:vote) do
  user
  book
  liked { FFaker::Boolean.maybe }
  
end