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
      case item.name
      when "Sulfuras, Hand of Ragnaros"
        return
      end

      if (item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert")
        decrease_quality(item)
      else
        increase_quality(item)

        if (item.name == "Backstage passes to a TAFKAL80ETC concert")
          if (item.sell_in < 11)
            increase_quality(item)
          end
          if (item.sell_in < 6)
            increase_quality(item)
          end
        end
      end

      decrease_sell_in(item)

      if (item.sell_in < 0)
        if (item.name != "Aged Brie")
          if (item.name != "Backstage passes to a TAFKAL80ETC concert")
            decrease_quality(item)
          else
            item.quality = 0
          end
        else
          increase_quality(item)
        end
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
