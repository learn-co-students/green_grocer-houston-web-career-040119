require 'pry'

def consolidate_cart(cart)
  # group together similar array elements and include a new count key within the new object
  new_cart = {}
  cart.uniq.each do |item|
    new_cart[item.keys[0]] = item.values[0]
    new_cart.values[-1][:count] = cart.count{|x| x == item}
  end
  new_cart
end

def apply_coupons(cart,coupons)
  new_cart = {}
  cart.each do |key,value|
    if coupons.any?{|coupon| key == coupon[:item]}
      coupon = coupons.find{|coupon|coupon[:item] == key}
      coupons.count(coupon).times do
        if new_cart[key] == nil
          num_applied = cart[key][:count] - coupon[:num] >= 0 ? coupon[:num] : 0
        else
          num_applied = new_cart[key][:count] - coupon[:num] >= 0 ? coupon[:num] : 0
        end
        new_cart[key] = {
          price: cart[key][:price],
          count: new_cart[key] == nil ? cart[key][:count] - num_applied : new_cart[key][:count] - num_applied,
          clearance: cart[key][:clearance]
        }
        if num_applied != 0
          new_cart["#{key} W/COUPON"] = {
            price: coupon[:cost],
            count: (new_cart["#{key} W/COUPON"] == nil ? 1 : new_cart["#{key} W/COUPON"][:count] +1),
            clearance: cart[key][:clearance]
          }
        end
      end
    else
      new_cart[key] = cart[key]
    end
  end
  new_cart
end


def apply_clearance(cart)
  # code here
  cart.each do |item,values|
    values[:clearance] == true ? values[:price] = (values[:price]*0.80).round(2) : values[:price]
  end
end

def checkout(cart, coupons)
  # code here
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart,coupons)
  cart = apply_clearance(cart)
  total = 0
  cart.each do |key, value|
    total = value[:price] * value[:count] + total
  end
  total > 100 ? (total * 0.9).round(2) : total
end
