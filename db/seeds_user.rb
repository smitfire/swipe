require 'json'

User.destroy_all

coords = File.readlines("db/latlon.txt")[0][2..-1].split("], [").map{ |ln| ln.split(", ")  }

ips = File.readlines("db/swissips.txt").map{|l| l[0..15]}

ap(ips.count)

cp2 = coords.zip(ips).map{ |row| {longitude: row[0][0] , latitude: row[0][1], ip_address: row[1][0..-5] } }

ems=[]
names = []
avs = []
bios = []
pnums = []
user_hash = []


1000.times do
  ems << FFaker::Internet.safe_email
  ems << FFaker::Internet.free_email
  ems << FFaker::Internet.disposable_email
  ems << FFaker::InternetSE.email
  names << FFaker::Name.name
  avs << FFaker::Avatar.image
  bios << FFaker::BaconIpsum.paragraph
  pnums << FFaker::PhoneNumber.phone_number
  
end

ems.uniq!
names.uniq!
avs.uniq!
bios.uniq!
pnums.uniq!


usratr = User.attribute_names.values_at(23,22,21, 1,2,3,4,5,6,14,15)+["password", "password_confirmation"]
usatr = usratr.map{ |row| row.to_sym }
vals = cp2[0].values.map.with_index{ |num,index| index == 2 ? num : num.to_f }
mevs = vals + ["nick", FFaker::DizzleIpsum.paragraph, rand(20..40), ["Female", "Male"].sample, pnums.pop, "n@n.com", rand(1..50), "http://static.comicvine.com/uploads/original/11111/111112793/3058421-nealadamsbatman.jpg","nickpass", "nickpass"]

u = User.new(usatr.zip(mevs).to_h)

ap(u.save)

500.times do |i|
  uh = { 
    email: ems[i],
    name: names[i],
    avrl: avs[i],
    bio: bios[i],
    phone_number: pnums[i],
    password: "nickpass",
    password_confirmation: "nickpass",
    sex: ["Female", "Male"].sample,
    range: rand(10..40),
    age: rand(18..50)
  }
  user_hash << uh
end

File.open("db/user_vals.json","w") do |f|
  f.write(user_hash.to_json)
end



ips[1..500].each_with_index do |ipadr, index|  
  
  vals = cp2[index].values.map.with_index{ |num, i| i == 2 ? num : num.to_f }  
  mevs = vals + [ names.pop, bios.pop, rand(20..50), ["Female", "Male"].sample, pnums.pop, ems.pop, rand(1..50), avs.pop, "nickpass", "nickpass"]

  u=User.new(usatr.zip(mevs).to_h)
  ap(u.save)

end

