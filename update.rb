class Updater
  def update(item)
    update_class(item).new.update(item)
  end

  private

  def update_class(item)
    SPECIAL_UPDATER[item.name] || NORMAL_UPDATER
  end

  class ItemUpdater
    def update(item)
      update_sell_in(item)
      update_quality(item)
    end

    def update_sell_in(item)
      item.sell_in -= 1
    end

    def update_quality(item)
      increment(item)
      increment(item) if item.sell_in <0
    end

    def increment(item)
    end
  end

  class NormalUpdater < ItemUpdater
    def increment(item)
      item.quality -= 1 if item.quality != 0
    end
  end

  class ImprovingUpdater < ItemUpdater
    def increment(item)
      item.quality += 1 if item.quality != 50
    end
  end

  class LegendaryUpdater
    def update(item)
    end
  end

  class TicketUpdater < ImprovingUpdater
    def update_quality(item)
      increment(item)
      increment(item)  if item.sell_in < 10
      increment(item)  if item.sell_in < 5

      item.quality = 0 if item.sell_in < 0
    end
  end

  SPECIAL_UPDATER = {
    "Aged Brie"=> ImprovingUpdater,
    "Sulfuras, Hand of Ragnaros"=> LegendaryUpdater,
    "Backstage passes to a TAFKAL80ETC concert"=> TicketUpdater
  }
  NORMAL_UPDATER  = NormalUpdater
end
