require './item.rb'
require './updater.rb'

class GildedRose
  UPDATERS = { "Aged Brie" => ImprovingUpdate,
               "Sulfuras, Hand of Ragnaros" => LegendaryUpdate,
               "Backstage passes to a TAFKAL80ETC concert" => TicketsUpdate }

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)

    extend_items
  end

  def update_quality
    @items.each do |item|
      item.update
    end
  end

  private

  def extend_items
    @items.each do |item|
      item.extend( UPDATERS[item.name] || NormalUpdate)
    end
  end
end
