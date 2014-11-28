require './item.rb'

class GildedRose

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def update_quality
    @items.each do |item|
      return if item.name == "Sulfuras, Hand of Ragnaros"

      decrease_sell_in(item)

      case item.name
      when "Aged Brie"
        increase_quality(item)
        increase_quality(item) if item.sell_in < 0
      when "Backstage passes to a TAFKAL80ETC concert"
        increase_quality(item)
        increase_quality(item) if item.sell_in < 10
        increase_quality(item) if item.sell_in < 5

        item.quality = 0       if item.sell_in < 0
      else
        decrease_quality(item)
        decrease_quality(item) if item.sell_in < 0
      end
    end
  end

  private

  def decrease_sell_in(item)
    item.sell_in -= 1
  end

  def increase_quality(item)
    item.quality += 1 if item.quality < 50
  end

  def decrease_quality(item)
    item.quality -= 1 if item.quality > 0
  end
end
