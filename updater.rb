module Update
  def update
    update_sell_in
    update_quality
  end

  private

  def update_sell_in
    self.sell_in -= 1
  end

  def update_quality
    increment
    increment if self.sell_in < 0
  end

  def increment
  end
end

module LegendaryUpdate
  include Update

  def update
  end
end

module NormalUpdate
  include Update

  def increment
    self.quality += -1 if self.quality != 0
  end
end

module ImprovingUpdate
  include Update

  def increment
    self.quality += 1 if self.quality != 50
  end
end

module TicketsUpdate
  include ImprovingUpdate

  def update_quality
    increment
    increment if self.sell_in < 10
    increment if self.sell_in < 5

    self.quality = 0 if self.sell_in < 0
  end
end
