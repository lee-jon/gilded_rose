# -*- coding: utf-8 -*-
require './gilded_rose.rb'
require './gilded_rose_spec_helper.rb'

require "rspec"

describe GildedRose do
  let(:gilded_rose) { GildedRose.new(item) }

  describe "Updating Normal Items" do
    describe "while in date" do
      let(:item) { Item.new("Normal Item", 10, 1) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          from(10).to(9)
      end

      it "should decrease the quality" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          from(1).to(0)
      end

      context "with zero quality items" do
        let(:item) { Item.new("Normal Item", 10, 0) }

        it "should not decrease the quality below zero" do
          expect{ gilded_rose.update_quality}.
            not_to change{ item.quality }
        end
      end
    end

    describe "when sell in hits zero" do
      let(:item) { Item.new("Normal Item", 1, 10) }

      it "should have a zero sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          from(1).to(0)
      end

      it "should have decreased quality by 1" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          from(10).to(9)
      end
    end

    describe "when sell in passes zero" do
      let(:item) { Item.new("Normal Item", 0, 10) }

      it "should have a negative sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          from(0).to(-1)
      end

      it "should have decreased quality by 2" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          from(10).to(8)
      end
    end
  end

  describe "for legendary items" do
    let(:item) { Item.new("Sulfuras, Hand of Ragnaros", 0, 80) }

    it "should not change sell in" do
      expect{ gilded_rose.update_quality }.
        not_to change{ item.sell_in }
    end

    it "should not change quality" do
      expect{ gilded_rose.update_quality }.
        not_to change{ item.quality }
    end
  end

  describe "for Aged Brie" do
    describe "before sell in" do
      let(:item) { Item.new("Aged Brie", 2, 0) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          from(2).to(1)
      end

      it "should increase in quality" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          from(0).to(1)
      end

      it "should not increase beyond 50" do
        expect{
          52.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          from(0).to(50)
      end
    end

    describe "approaching sell in" do
      let(:item) { Item.new("Aged Brie", 1, 0) }

      it "should have zero sell in date" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          from(1).to(0)
      end

      it "increases in age when older" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          from(0).to(1)
      end
    end

    describe "after sell in" do
      let(:item) { Item.new("Aged Brie", -5, 0) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          from(-5).to(-6)
      end

      it "increases in age when older" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          from(0).to(2)
      end
    end

    describe "with maximum quality" do
      let(:item) { Item.new("Aged Brie", 10, 50) }

      it "should not increase quality beyond 50" do
        expect{ gilded_rose.update_quality }.
          not_to change{ item.quality }
      end
    end
  end

  describe "for Backstage Passes" do
    let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20) }

    it "should decrease sell in" do
      expect{ gilded_rose.update_quality }.
        to change{ item.sell_in }.
        from(15).to(14)
    end

    describe "increases in quality" do
      it "should be by 1 when sell_in is 15-10" do
        expect{
          5.times { gilded_rose.update_quality }
        }.to change{ item.quality}.
          from(20).to(25)
      end

      it "should be by 2 when sell_in < 10" do
        expect{
          5.times { gilded_rose.update_quality }
          1.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          from(20).to(20 + (5*1) + (1*2))
      end

      it "should be by 3 when sell_in < 5" do
        expect{
          5.times { gilded_rose.update_quality } # 10 days
          5.times { gilded_rose.update_quality } # 5 days
          1.times { gilded_rose.update_quality } # 4 days + 3
        }.to change{ item.quality }.
          from(20).to(20 + (5*1) + (5*2) + (1*3))
      end
    end

    describe "after sell it" do
      it "should go to 0" do
        expect{
          item.sell_in.times { gilded_rose.update_quality }
          gilded_rose.update_quality
        }.to change{ item.quality }.
          from(20).to(0)
      end
    end

    describe "with maximum quality" do
      let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 49) }
      it "should not get higher than 50 quality" do
        expect{
          11.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          from(49).to(50)
      end
    end
  end
end
