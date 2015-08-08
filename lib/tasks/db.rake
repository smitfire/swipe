require 'json'

namespace :db do
  desc "TODO"
  task dump_books: :environment do
      myh=[]
      
      Book.all.each do |bk|
        bh = bk.attributes
        bh.delete("id")
        myh<< bh
      end
      
      ap(myh.count)
      myh.uniq!
      ap(myh.count)

      File.open("db/bh_valid.json","w") do |f|
        f.write(myh.to_json)
      end
  end  
  
  desc "TODO"
  # task :seed_votes, [:num] do |t, args|
  task seed_votes: :environment do
  end

  desc "TODO"
  task seed_books: :environment do
    Book.destroy_all
    dh = JSON.parse(File.read("db/bh_valid.json"))
    
    dh.each do |bkrow|
        u = User.all.sample
        b = u.owned_books.new(bkrow)
        b.save ? "#{b.title} has been saved to #{u.name}" : b.errors
    end

  end

  desc "TODO"
  task :generate_book_infos, [:num, :word_type] do |t, args|

    client = Goodreads.new(:api_key => 'yfVhRfSgGgmiNRxsUE1Yg',:api_secret => ' JC79w77TvDyN7fj1LaPjZZ1Ia6ESiwzxZs8JaC358')

    dh = JSON.parse(File.read("db/bh_valid.json"))
        
    ci = 0

    args[:num].to_i.times do
        
        term = Faker::Hacker.send(args[:word_type])
        ap(term)
        
        search = client.search_books(term)
        works = search.results.work

        if works.count>0
            works.each do |book|
              if dh.count{ |rowh| rowh["image_url"][book.best_book.image_url] } == 0

                b = client.book(book.best_book.id)
                
                ba = b.to_a[1..-7]
                ba.delete_at(-9)

                bh = ba.to_h
                bh["author"]=book.best_book.author.name

                if bh["description"].present? and bh["work"].nil?
                  ci+=1
                  
                  bh["description"] = ActionView::Base.full_sanitizer.sanitize(bh["description"])
                  
                  dh<<bh
                  ap("#{b.title} has been saved to hash")
                end  
              end
            end
         end
    end

    File.open("db/bh_valid.json","w") do |f|
      f.write(dh.to_json)
    end
    
    ap("#{ci} books added to file")

  end

end
