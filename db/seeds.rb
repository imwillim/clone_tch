# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

vietnam_coffee = Product.create(
  name: "Cà phê Việt Nam",
  description: "Cà phê xuất xứ từ Việt Nam",
  price: 39000,
  thumbnail: "ca_phe_viet_nam1.png",
  image_urls: %w[ca_phe_viet_nam1.png ca_phe_viet_nam2.png])

latte_tea = Product.create(
  name: "Trà xanh Latte",
  description: "Trà được làm từ bột latte",
  price: 49000,
  thumbnail: "tra_xanh_latte.png",
  image_urls: %w[tra_xanh_latte1.png tra_xanh_latte2.png])

blao_milktea = Product.create(
  name: "Trà sữa ô long Blao",
  description: "Trà sữa đậm vị",
  price: 55000,
  thumbnail: "tra_sua_blao.png",
  image_urls: %w[tra_sua_blao2.png tra_sua_blao3.png])
