require './gilded_rose.rb'
require './gilded_rose_spec_helper.rb'

require "rspec"

describe GildedRose do

  describe "Updating Normal Items" do
    describe "while in date" do
      before do
        @item = Item.new("Normal Item", 10, 1)
        @gildedrose = GildedRose.new(@item)
        @gildedrose.update_quality
      end

      it "should decrease the sell in" do
        expect(@item.sell_in).to eq(9)
      end

      it "should decrease the quality" do
        expect(@item.quality).to eq(0)
      end

      it "should not decrease the quality below zero" do
        @gildedrose.update_quality

        expect(@item.quality).to_not be < 0
      end
    end

    describe "when sell in hits zero" do
      before do
        @item = Item.new("Normal Item", 1, 10)
        @gildedrose = GildedRose.new(@item)
        @gildedrose.update_quality
      end

      it "should have a zero sell in" do
        expect(@item.sell_in).to eq(0)
      end

      it "should have decreased quality by 1" do
        expect(@item.quality).to eq(9)
      end
    end

    describe "when sell in passes zero" do
      before do
        @item = Item.new("Normal Item", 0, 10)
        @gildedrose = GildedRose.new(@item)
        @gildedrose.update_quality
      end

      it "should have a negative sell in" do
        expect(@item.sell_in).to eq(-1)
      end

      it "should have decreased quality by 2" do
        expect(@item.quality).to eq(8)
      end
    end
  end

  describe "for legendary items" do
    before do
      @item = Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
      @gildedrose = GildedRose.new(@item)

      @gildedrose.update_quality
    end

    it "should not change sell in" do
      expect(@item.sell_in).to eq(0)
    end

    it "should not change quality" do
      expect(@item.quality).to eq(80)
    end
  end

  describe "for Aged Brie" do
    describe "before sell in" do
      before do
        @item = Item.new("Aged Brie", 2, 0)
        @gildedrose = GildedRose.new(@item)

        @gildedrose.update_quality
      end

      it "should decrease the sell in" do
        expect(@item.sell_in).to eq(1)
      end

      it "should increase in quality" do
        expect(@item.quality).to eq(1)
      end

      it "should not increase beyond 50" do
        51.times { @gildedrose.update_quality }

        expect(@item.quality).to_not be > 50
      end
    end

    describe "approaching sell in" do
      before do
        @item = Item.new("Aged Brie", 1, 0)
        @gildedrose = GildedRose.new(@item)

        @gildedrose.update_quality
      end

      it "should have zero sell in date" do
        expect(@item.sell_in).to eq(0)
      end

      it "increases in age when older" do
        expect(@item.quality).to eq(1)
      end
    end

    describe "after sell in" do
      before do
        @item = Item.new("Aged Brie", -5, 0)
        @gildedrose = GildedRose.new(@item)

        @gildedrose.update_quality
      end

      it "should decrease the sell in" do
        expect(@item.sell_in).to eq(-6)
      end

      it "increases in age when older" do
        expect(@item.quality).to eq(2)
      end
    end

    describe "with maximum quality" do
      before do
        @item = Item.new("Aged Brie", 10, 50)
        @gildedrose = GildedRose.new(@item)

        @gildedrose.update_quality
      end

      it "should not increase quality beyond 50" do
        expect(@item.quality).to_not be > 50
      end
    end
  end

  describe "for Backstage Passes" do
    before do
      @item = Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
      @gildedrose = GildedRose.new(@item)
    end

    it "should decrease sell in" do
      @gildedrose.update_quality

      expect(@item.sell_in).to eq (14)
    end

    describe "increases in quality" do
      it "should be by 1 when sell_in is 15-10" do
        5.times { @gildedrose.update_quality }

        expect(@item.quality).to eq(20 + 5)
      end

      it "should be by 2 when sell_in < 10" do
        5.times { @gildedrose.update_quality }
        1.times { @gildedrose.update_quality }

        expect(@item.quality).to eq(20 + (5*1) + (1*2))
      end

      it "should be by 3 when sell_in < 5" do
        5.times { @gildedrose.update_quality } # 10 days
        5.times { @gildedrose.update_quality } # 5 days
        1.times { @gildedrose.update_quality } # 4 days + 3

        expect(@item.quality).to eq(20 + (5*1) + (5*2) + (1*3))
      end
    end

    describe "after sell it" do
      it "should go to 0" do
        @item.sell_in.times { @gildedrose.update_quality }
        @gildedrose.update_quality

        expect(@item.quality).to eq(0)
      end
    end

    describe "with maximum quality" do
      it "should not get higher than 50 quality" do
        @item = Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 49)
        @gildedrose = GildedRose.new(@item)
        11.times { @gildedrose.update_quality }

        expect(@item.quality).to_not be > 50
      end
    end
  end
end
