require "ffaker"

# User.destroy_all
# Book.destroy_all
# Vote.destroy_all


# coords = File.readlines("db/latlon.txt")[0][2..-1].split("], [").map{ |ln| { longitude: ln.split(", ")[0], latitude: ln.split(", ")[1] } }
coords = File.readlines("db/latlon.txt")[0][2..-1].split("], [").map{ |ln| ln.split(", ")  }
ips = File.readlines("db/swissips.txt").map{|l| l[0..15]}

cp2= coords.zip(ips).map{ |row| {longitude: row[0][0] , latitude: row[0][1], ip_address: row[1][0..-5] } }


ems=[]
names = []

ips.count.times do
  ems << FFaker::Internet.safe_email
  ems << FFaker::Internet.free_email
  ems << FFaker::Internet.disposable_email
  ems << FFaker::InternetSE.email
  names << FFaker::Name.name
end

ems.uniq!
names.uniq!

usratr = User.attribute_names.values_at(15,14,13,10,11,1,2)+["password", "password_confirmation"]
usatr = usratr.map{ |row| row.to_sym }

# ["name", "email", "range", "avrl", "full_address", "ip_address", "latitude"]
# ["longitude", "latitude", "ip_address", "range", "avrl", "name", "email"]
vals = cp2[0].values.map{|num| num.to_f }

mevs = vals + [rand(1..50), "http://static.comicvine.com/uploads/original/11111/111112793/3058421-nealadamsbatman.jpg", "nick", "n@n.com", "nickpass", "nickpass"]

my_hash = usatr.zip(mevs).to_h

u=User.create!(my_hash)

rand(1..10).times do
  b = u.owned_books.create!(author: FFaker::Name.name, summary: FFaker::Lorem.paragraph, title: FFaker::Product.product_name, covrl: "http://michaelhyatt.com/images/book.cover.2D.006.png" )
  # b.cover = File.open("app/assets/images/bkcv.JPG")
  # b.save!
end

ips[1..-1].each_with_index do |ipadr, index|
  vals = cp2[index].values.map{|num| num.to_f }
  mevs = vals + [rand(1..50), "http://static.comicvine.com/uploads/original/11111/111112793/3058421-nealadamsbatman.jpg", names.pop, ems.pop, "nickpass", "nickpass"]
  my_hash = usatr.zip(mevs).to_h
  u=User.create!(my_hash)
  # u.update(cp2[index])
  # u.avatar = File.open("app/assets/images/p.jpg")
  # u.save!
  rand(1..10).times do
    b = u.owned_books.create(author: FFaker::Name.name, summary: FFaker::Lorem.paragraph, title: FFaker::Product.product_name, covrl: "http://michaelhyatt.com/images/book.cover.2D.006.png")
    # b.cover = File.open("app/assets/images/bkcv.JPG")
    # b.save!
  end
end



# # 10.times do
#   # u=User.create!(email: FFaker::Internet.safe_email, password: "nickpass", password_confirmation: "nickpass", full_address: FFaker::AddressFR.full_address, range: rand(1000..5000) )
#   # u.avatar = File.open("app/assets/images/p.jpg")
#   # u.save!
#   # 10.times do
#   #   b = u.owned_books.create(author: FFaker::Name.name, summary: FFaker::Lorem.paragraph, title: FFaker::Product.product_name )
#   #   b.cover = File.open("app/assets/images/bkcv.JPG")
#   #   b.save!
#   # end
# # end

# # yay = [true, false]

# # 15.times do
# #   u = User.all.sample
# #   bs = u.bookstack  
# #   if bs != nil
# #     10.times do
# #       b = bs.sample
# #       if b and !u.votes.exists?(book_id: b.id)
# #         v = u.votes.create(liked: yay.sample, book_id: b.id)
# #       end
# #     end
# #   end
# # end