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

TP_HCM = City.create(
  name: 'Thành phố Hồ Chí Minh',
  code: 'HCM'
)

Hanoi = City.create(
  name: 'Hà Nội',
  code: 'HN'
)

Danang = City.create(
  name: 'Đà Nẵng',
  code: 'DAN'
)

Ap_Bac = Store.create(
  name: 'Ấp Bắc',
  description: 'Nhà cà phê toạ lạc tại Ấp Bắc',
  image_urls: ['Ap_Bac_1.png', 'Ap_Bac_2.png']
)

Le_Van_Sy = Store.create(
  name: 'Lê Văn Sỹ',
  description: 'Nhà cà phê toạ lạc tại Lê Văn Sỹ',
  image_urls: ['Le_Van_Sy_1.png', 'Le_Van_Sy_2.png']
)

Hong_Ha = Store.create(
  name: 'Hồng Hà',
  description: 'Nhà cà phê toạ lạc tại Hồng Hà',
  image_urls: ['Hong_Ha_1.png', 'Hong_Ha_2.png']
)

Hoang_Viet = Store.create(
  name: 'Hoàng Việt',
  description: 'Nhà cà phê toạ lạc tại Hoàng Việt',
  image_urls: ['Hoang_Viet_1.png', 'Hoang_Viet_2.png']
)

Hong_Lac = Store.create(
  name: 'Hồng Lạc',
  description: 'Nhà cà phê toạ lạc tại Hồng Lạc',
  image_urls: ['Hong_Lac_1.png', 'Hong_Lac_2.png']
)

Nguyen_Xi = Store.create(
  name: 'Nguyễn Xí',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Xí',
  image_urls: ['Nguyen_Xi_1.png', 'Nguyen_Xi_2.png']
)

Phan_Van_Tri = Store.create(
  name: 'Phan Văn Trị',
  description: 'Nhà cà phê toạ lạc tại Phan Văn Trị',
  image_urls: ['Phan_Van_Tri_1.png', 'Phan_Van_Tri_2.png']
)

Bui_Huu_Nghia = Store.create(
  name: 'Bùi Hữu Nghĩa',
  description: 'Nhà cà phê toạ lạc tại Bùi Hữu Nghĩa',
  image_urls: ['Bui_Huu_Nghia_1.png', 'Bui_Huu_Nghia_2.png']
)

Ngo_Tat_To = Store.create(
  name: 'Ngô Tất Tố',
  description: 'Nhà cà phê toạ lạc tại Ngô Tất Tố',
  image_urls: ['Ngo_Tat_To_1.png', 'Ngo_Tat_To_2.png']
)

Nguyen_Van_Thuong = Store.create(
  name: 'Nguyễn Văn Thương',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Văn Thương',
  image_urls: ['Nguyen_Van_Thuong_1.png', 'Nguyen_Van_Thuong_2.png']
)

Dien_Bien_Phu = Store.create(
  name: 'Điện Biên Phủ',
  description: 'Nhà cà phê toạ lạc tại Điện Biên Phủ',
  image_urls: ['Dien_Bien_Phu_1.png', 'Dien_Bien_Phu_2.png']
)

The_Grace_Tower = Store.create(
  name: 'The Grace Tower',
  description: 'Nhà cà phê toạ lạc tại The Grace Tower',
  image_urls: ['The_Grace_Tower_1.png', 'The_Grace_Tower_2.png']
)

Nguyen_Thi_Thap = Store.create(
  name: 'Nguyễn Thị Thập',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Thị Thập',
  image_urls: ['Nguyen_Thi_Thap_1.png', 'Nguyen_Thi_Thap_2.png']
)

Huynh_Tan_Phat = Store.create(
  name: 'Huỳnh Tấn Phát',
  description: 'Nhà cà phê toạ lạc tại Huỳnh Tấn Phát',
  image_urls: ['Huynh_Tan_Phat_1.png', 'Huynh_Tan_Phat_2.png']
)

Nguyen_Thi_Thap_2 = Store.create(
  name: 'Nguyễn Thị Thập 2',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Thị Thập 2',
  image_urls: ['Nguyen_Thi_Thap_2_1.png', 'Nguyen_Thi_Thap_2_2.png']
)

Sky_Garden = Store.create(
  name: 'Sky Garden',
  description: 'Nhà cà phê toạ lạc tại Sky Garden',
  image_urls: ['Sky_Garden_1.png', 'Sky_Garden_2.png']
)

Victoria_Van_Phu = Store.create(
  name: 'Victoria Văn Phú',
  description: 'Nhà cà phê toạ lạc tại Victoria Văn Phú',
  image_urls: ['Victoria_Van_Phu_1.png', 'Victoria_Van_Phu_2.png']
)

Van_Khe = Store.create(
  name: 'Văn Khê',
  description: 'Nhà cà phê toạ lạc tại Văn Khê',
  image_urls: ['Van_Khe_1.png', 'Van_Khe_2.png']
)

Vu_Tong_Phan = Store.create(
  name: 'Vũ Tông Phan',
  description: 'Nhà cà phê toạ lạc tại Vũ Tông Phan',
  image_urls: ['Vu_Tong_Phan_1.png', 'Vu_Tong_Phan_2.png']
)

Aeon_Mall_Ha_Dong = Store.create(
  name: 'Aeon Mall Hà Đông',
  description: 'Nhà cà phê toạ lạc tại Aeon Mall Hà Đông',
  image_urls: ['Aeon_Mall_Ha_Dong_1.png', 'Aeon_Mall_Ha_Dong_2.png']
)

Nguyen_Van_Loc = Store.create(
  name: 'Nguyễn Văn Lộc',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Văn Lộc',
  image_urls: ['Nguyen_Van_Loc_1.png', 'Nguyen_Van_Loc_2.png']
)

The_Park_Home = Store.create(
  name: 'The Park Home',
  description: 'Nhà cà phê toạ lạc tại The Park Home',
  image_urls: ['The_Park_Home_1.png', 'The_Park_Home_2.png']
)

Hoang_Dao_Thuy_2 = Store.create(
  name: 'Hoàng Đạo Thúy 2',
  description: 'Nhà cà phê toạ lạc tại Hoàng Đạo Thúy 2',
  image_urls: ['Hoang_Dao_Thuy_2_1.png', 'Hoang_Dao_Thuy_2_2.png']
)

Nguyen_Khanh_Toan = Store.create(
  name: 'Nguyễn Khánh Toàn',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Khánh Toàn',
  image_urls: ['Nguyen_Khanh_Toan_1.png', 'Nguyen_Khanh_Toan_2.png']
)

Ho_Tung_Mau = Store.create(
  name: 'Hồ Tùng Mậu',
  description: 'Nhà cà phê toạ lạc tại Hồ Tùng Mậu',
  image_urls: ['Ho_Tung_Mau_1.png', 'Ho_Tung_Mau_2.png']
)

Vu_Pham_Ham = Store.create(
  name: 'Vũ Phạm Hàm',
  description: 'Nhà cà phê toạ lạc tại Vũ Phạm Hàm',
  image_urls: ['Vu_Pham_Ham_1.png', 'Vu_Pham_Ham_2.png']
)

Discovery = Store.create(
  name: 'Discovery',
  description: 'Nhà cà phê toạ lạc tại Discovery',
  image_urls: ['Discovery_1.png', 'Discovery_2.png']
)

Nguyen_Van_Linh = Store.create(
  name: 'Nguyễn Văn Linh',
  description: 'Nhà cà phê toạ lạc tại Nguyễn Văn Linh',
  image_urls: ['Nguyen_Van_Linh_1.png', 'Nguyen_Van_Linh_2.png']
)

Nui_Thanh = Store.create(
  name: 'Núi Thành',
  description: 'Nhà cà phê toạ lạc tại Núi Thành',
  image_urls: ['Nui_Thanh_1.png', 'Nui_Thanh_2.png']
)

Address.create(house_number: '4 - 6', street: 'Ấp Bắc', ward: 'Phường 13', district: 'Q. Tân Bình',
               latitude: 106.6690, longitude: 10.7905,
               city: TP_HCM, store: Ap_Bac)

Address.create(house_number: '281', street: 'Lê Văn Sỹ', ward: 'Phường 2', district: 'Q. Tân Bình',
               latitude: 10.7943273, longitude: 106.667901,
               city: TP_HCM, store: Le_Van_Sy)

Address.create(house_number: '18', street: 'Hồng Hà', ward: 'Phường 2', district: 'Q. Tân Bình',
               latitude: 10.7714, longitude: 106.6483,
               city: TP_HCM, store: Hong_Ha)

Address.create(house_number: '17', street: 'Út Tịch', ward: 'Phường 4', district: 'Q. Tân Bình',
               latitude: 10.7742, longitude: 106.6551,
               city: TP_HCM, store: Hoang_Viet)

Address.create(house_number: '291', street: 'Hồng Lạc', ward: 'Phường 10', district: 'Q. Tân Bình',
               latitude: 10.7807, longitude: 106.6654,
               city: TP_HCM, store: Hong_Lac)

Address.create(house_number: '184', street: 'Nguyễn Xí', ward: 'Phường 26', district: 'Bình Thạnh',
               latitude: 10.7859, longitude: 106.6889,
               city: TP_HCM, store: Nguyen_Xi)

Address.create(house_number: '190', street: 'Phan Văn Trị', ward: 'Phường 11', district: 'Bình Thạnh',
               latitude: 10.7743, longitude: 106.6937,
               city: TP_HCM, store: Phan_Van_Tri)

Address.create(house_number: '70', street: 'Bùi Hữu Nghĩa', ward: 'Phường 2', district: 'Bình Thạnh',
               latitude: 10.7718, longitude: 106.6892,
               city: TP_HCM, store: Bui_Huu_Nghia)

Address.create(house_number: '14B1', street: 'Đường Ngô Tất Tố', ward: 'Phường 19', district: 'Bình Thạnh',
               latitude: 10.7801, longitude: 106.6798,
               city: TP_HCM, store: Ngo_Tat_To)

Address.create(house_number: '75', street: 'Nguyễn Văn Thương', ward: 'Phường 25', district: 'Bình Thạnh',
               latitude: 10.7773, longitude: 106.6840,
               city: TP_HCM, store: Nguyen_Van_Thuong)

Address.create(house_number: '469', street: 'Điện Biên Phủ', ward: 'Phường 25', district: 'Bình Thạnh',
               latitude: 10.7805, longitude: 106.6791,
               city: TP_HCM, store: Dien_Bien_Phu)

Address.create(house_number: '71', street: 'Hoàng Văn Thái', ward: 'Tân Phú', district: 'Quận 7',
               latitude: 10.7413, longitude: 106.6890,
               city: TP_HCM, store: The_Grace_Tower)

Address.create(house_number: '313', street: 'Nguyễn Thị Thập', ward: 'Tân Phú', district: 'Quận 7',
               latitude: 10.7356, longitude: 106.6881,
               city: TP_HCM, store: Nguyen_Thi_Thap)

Address.create(house_number: '400A', street: 'Huỳnh Tấn Phát', ward: 'Tân Thuận Đông', district: 'Quận 7',
               latitude: 10.7347, longitude: 106.6935,
               city: TP_HCM, store: Huynh_Tan_Phat)

Address.create(house_number: '490-492', street: 'Nguyễn Thị Thập', ward: 'Tân Phú', district: 'Quận 7',
               latitude: 10.7365, longitude: 106.6888,
               city: TP_HCM, store: Nguyen_Thi_Thap_2)

Address.create(house_number: 'R1-72', street: 'Khu R20 Sky Garden', ward: 'Tân Phong', district: 'Quận 7',
               latitude: 10.7341, longitude: 106.6864,
               city: TP_HCM, store: Sky_Garden)

Address.create(house_number: 'V3-Văn Phú Victoria-CT9', street: 'P.Văn Khê', ward: 'Văn Khê', district: 'Hà Đông',
               latitude: 20.9934, longitude: 105.5253,
               city: Hanoi, store: Victoria_Van_Phu)

Address.create(house_number: 'CT5A', street: 'Khu đô thị Văn Khê', ward: 'P. Tố Hữu', district: 'Hà Đông',
               latitude: 20.9917, longitude: 105.5276,
               city: Hanoi, store: Van_Khe)

Address.create(house_number: '349', street: 'P. Vũ Tông Phan', ward: 'Khương Đình', district: 'Hà Đông',
               latitude: 20.9945, longitude: 105.5289,
               city: Hanoi, store: Vu_Tong_Phan)

Address.create(house_number: 'AEON Mall Hà Đông', street: 'Đ Nội', ward: 'Dương Nội', district: 'Hà Đông',
               latitude: 20.9952, longitude: 105.5268,
               city: Hanoi, store: Aeon_Mall_Ha_Dong)

Address.create(house_number: 'BT16B5 Lô 6', street: 'Nguyễn Văn Lộc', ward: 'Làng Việt kiều Châu Âu',
               district: 'Hà Đông', latitude: 20.9911, longitude: 105.5224,
               city: Hanoi, store: Nguyen_Van_Loc)

Address.create(house_number: 'Lô D12', street: 'KĐT, Thành Thái', ward: 'Dịch Vọng', district: 'Cầu Giấy',
               latitude: 21.0295, longitude: 105.7895,
               city: Hanoi, store: The_Park_Home)

Address.create(house_number: '17T3', street: 'Hoàng Đạo Thúy', ward: 'Trung Hòa Nhân Chính', district: 'Cầu Giấy',
               latitude: 21.0274, longitude: 105.7876,
               city: Hanoi, store: Hoang_Dao_Thuy_2)

Address.create(house_number: '160', street: 'Nguyễn Khánh Toàn', ward: 'Quan Hoa', district: 'Cầu Giấy',
               latitude: 21.0311, longitude: 105.7888,
               city: Hanoi, store: Nguyen_Khanh_Toan)

Address.create(house_number: '2', street: 'Hồ Tùng Mậu', ward: 'Mai Dịch', district: 'Cầu Giấy',
               latitude: 21.0287, longitude: 105.7893,
               city: Hanoi, store: Ho_Tung_Mau)

Address.create(house_number: '60', street: 'Vũ Phạm Hàm', ward: 'Yên Hoà', district: 'Cầu Giấy',
               latitude: 21.0269, longitude: 105.7900,
               city: Hanoi, store: Vu_Pham_Ham)

Address.create(house_number: 'G10&10A Discovery Complex 302', street: '2', ward: 'Dịch Vọng',
               district: 'Cầu Giấy', latitude: 21.0301, longitude: 105.7912,
               city: Hanoi, store: Discovery)

Address.create(house_number: 'Lô A4 - 2', street: 'Nguyễn Văn Linh', ward: 'Bình Hiên', district: 'Hải Châu',
               city: Danang, store: Nguyen_Van_Linh)

Address.create(house_number: '01', street: 'Núi Thành', ward: '3', district: 'Hải Châu',
               city: Danang, store: Nui_Thanh)

facilities = [
  Facility.create(name: 'Mua mang đi'),
  Facility.create(name: 'Phục vụ tại chỗ'),
  Facility.create(name: 'Có chỗ đỗ xe hơi'),
  Facility.create(name: 'Thân thiện với gia đình')
]

stores = [
  Ap_Bac, Le_Van_Sy, Hong_Ha, Hoang_Viet, Hong_Lac, Nguyen_Xi, Phan_Van_Tri,
  Bui_Huu_Nghia, Ngo_Tat_To, Nguyen_Van_Thuong, Dien_Bien_Phu, The_Grace_Tower,
  Nguyen_Thi_Thap, Huynh_Tan_Phat, Nguyen_Thi_Thap_2, Sky_Garden, Victoria_Van_Phu,
  Van_Khe, Vu_Tong_Phan, Aeon_Mall_Ha_Dong, Nguyen_Van_Loc, The_Park_Home, Hoang_Dao_Thuy_2,
  Nguyen_Khanh_Toan, Ho_Tung_Mau, Vu_Pham_Ham, Discovery, Nguyen_Van_Linh, Nui_Thanh
]

stores.each do |store|
  store_facilities = facilities.sample(rand(3..4)) # Randomly select 3 to 4 facilities
  store.facilities.append(*store_facilities)       # Append them to the store
end

weekend1 = WorkingHour.create(open_hour: '6:00', close_hour: '20:30')
day1 = WorkingHour.create(open_hour: '7:00', close_hour: '21:30')

weekend2 = WorkingHour.create(open_hour: '6:30', close_hour: '21:00')
day2 = WorkingHour.create(open_hour: '7:30', close_hour: '22:00')

weekend3 = WorkingHour.create(open_hour: '6:00', close_hour: '21:30')
day3 = WorkingHour.create(open_hour: '7:00', close_hour: '22:30')

weekend4 = WorkingHour.create(open_hour: '6:30', close_hour: '19:30')
day4 = WorkingHour.create(open_hour: '7:30', close_hour: '20:30')

working_hour_pairs = [
  { weekend: weekend1, day: day1 },
  { weekend: weekend2, day: day2 },
  { weekend: weekend3, day: day3 },
  { weekend: weekend4, day: day4 }
]

days_of_week = %w[Monday Tuesday Wednesday Thursday Friday]

stores.each do |store|
  selected_pair = working_hour_pairs.sample

  store.stores_working_hours.create(day: 'Saturday', working_hour: selected_pair[:weekend])
  store.stores_working_hours.create(day: 'Sunday', working_hour: selected_pair[:weekend])

  days_of_week.each do |day|
    store.stores_working_hours.create(day:, working_hour: selected_pair[:day])
  end
end
