# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

all_category = Category.create(
  name: 'Tất cả'
)

coffee_category = Category.create(
  name: 'Cà phê'
)

tea_category = Category.create(
  name: 'Trà'
)

milk_tea_category = Category.create(
  name: 'Trà sữa'
)

hi_tea_category = Category.create(
  name: 'Trà Hi-Tea'
)

all_category.children.append(coffee_category, tea_category)
tea_category.children.append(milk_tea_category, hi_tea_category)

vietnam_coffee = Product.create(
  name: 'Cà phê Việt Nam',
  description: 'Cà phê xuất xứ từ Việt Nam',
  price: 39_000,
  thumbnail: 'ca_phe_viet_nam1.png',
  image_urls: %w[ca_phe_viet_nam1.png ca_phe_viet_nam2.png],
  category: coffee_category
)

Product.create(
  name: 'Trà xanh Latte',
  description: 'Trà được làm từ bột latte',
  price: 49_000,
  thumbnail: 'tra_xanh_latte.png',
  image_urls: %w[tra_xanh_latte1.png tra_xanh_latte2.png],
  category: tea_category
)

Product.create(
  name: 'Trà sữa Trân châu',
  description: 'Trà sữa có topping trân châu',
  price: 55_000,
  thumbnail: 'tra_sua_tran_chau.png',
  image_urls: %w[tra_sua_tran_chau1.png tra_sua_tran_chau3.png],
  category: milk_tea_category
)

blao_milktea = Product.create(
  name: 'Trà sữa ô long Blao',
  description: 'Trà sữa đậm vị',
  price: 55_000,
  thumbnail: 'tra_sua_blao.png',
  image_urls: %w[tra_sua_blao2.png tra_sua_blao3.png],
  category: milk_tea_category
)

Product.create(
  name: 'Hi-Tea Đào Kombucha',
  description: 'Trà hoa Hibiscus',
  price: 55_000,
  thumbnail: 'dao_kombucha.png',
  image_urls: %w[dao_kombucha1.png dao_kombucha2.png],
  category: hi_tea_category
)

large_size = Size.create(
  name: 'Lớn',
  icon: 'size_lon.jpg',
  price: 10_000
)

small_size = Size.create(
  name: 'Nhỏ',
  icon: 'size_nho.jpg',
  price: 3000
)

medium_size = Size.create(
  name: 'Vừa',
  icon: 'size_vua.jpg',
  price: 5000
)

vietnam_coffee.sizes.append(small_size, medium_size)
blao_milktea.sizes.append(large_size)

jelly = Topping.create(
  name: 'Thạch',
  price: 2000
)

bubble = Topping.create(
  name: 'Trân châu',
  price: 5000
)

vietnam_coffee.toppings.append(jelly)
blao_milktea.toppings.append(bubble)

new_tag = Tag.create(
  name: 'Mới',
  color: 'white'
)

blao_milktea.tag = new_tag
