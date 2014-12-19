# -*- coding: utf-8 -*-
require './gilded_rose.rb'
require './gilded_rose_spec_helper.rb'

require "rspec"

describe GildedRose do
  let(:gilded_rose) { GildedRose.new(item) }
  let(:zero_quality) { 0 }
  let(:max_quality) { 50 }
  let(:quality) { 1 }

  let(:zero_sell_in) { 0 }
  let(:sell_in) { 1 }
  let(:negative_sell_in) { 0 - sell_in }

  describe "Updating Normal Items" do
    describe "while in date" do
      let(:item) { Item.new("Normal Item", sell_in, quality) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          by(-1)
      end

      it "should decrease the quality" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          by(-1)
      end

      context "with zero quality items" do
        let(:item) { Item.new("Normal Item", sell_in, zero_quality) }

        it "should not decrease the quality below zero" do
          expect{ gilded_rose.update_quality }.
            not_to change{ item.quality }
        end
      end
    end

    describe "when sell in hits zero" do
      let(:item) { Item.new("Normal Item", sell_in, quality) }

      it "should have decreased sell in by 1" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          by(-1)
      end

      it "should have decreased quality by 1" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(quality - 1)
      end
    end

    describe "when sell in passes zero" do
      let(:quality) { 2 }
      let(:item) { Item.new("Normal Item", zero_sell_in, quality) }

      it "should have a negative sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          by(-1)
      end

      it "should have decreased quality by 2" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          by(-2)
      end
    end
  end

  describe "for legendary items" do
    let(:item) { Item.new("Sulfuras, Hand of Ragnaros", zero_sell_in, quality) }

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
      let(:item) { Item.new("Aged Brie", sell_in, zero_quality) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          by(-1)
      end

      it "should increase in quality" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          by(1)
      end

      it "should not increase beyond max quality (50)" do
        expect{
          (max_quality + 1).times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          to(max_quality)
      end
    end

    describe "approaching sell in" do
      let(:item) { Item.new("Aged Brie", sell_in, zero_quality) }

      it "should have zero sell in date" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          by(-1)
      end

      it "increases in age when older" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          by(1)
      end
    end

    describe "after sell in" do
      let(:item) { Item.new("Aged Brie", negative_sell_in, zero_quality) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          by(-1)
      end

      it "increases in age when older" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          by(2)
      end
    end

    describe "with maximum quality" do
      let(:item) { Item.new("Aged Brie", sell_in, max_quality) }

      it "should not increase quality beyond 50" do
        expect{ gilded_rose.update_quality }.
          not_to change{ item.quality }
      end
    end
  end

  describe "for Backstage Passes" do
    let(:set_sell_in) { 15 }
    let(:set_quality) { 20 }
    let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", set_sell_in, set_quality) }

    it "should decrease sell in" do
      expect{ gilded_rose.update_quality }.
        to change{ item.sell_in }.
        by(-1)
    end

    describe "increases in quality" do
      it "should be by 1 when sell_in is 15-10" do
        expect{
          5.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          by(5)
      end

      it "should be by 2 when sell_in < 10" do
        expect{
          5.times { gilded_rose.update_quality }
          1.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          by(7)
      end

      it "should be by 3 when sell_in < 5" do
        expect{
          5.times { gilded_rose.update_quality } # 10 days
          5.times { gilded_rose.update_quality } # 5 days
          1.times { gilded_rose.update_quality } # 4 days + 3
        }.to change{ item.quality }.
          by(18)
      end
    end

    describe "after sell it" do
      it "should go to 0" do
        expect{
          item.sell_in.times { gilded_rose.update_quality }
          gilded_rose.update_quality
        }.to change{ item.quality }.
          to(zero_quality)
      end
    end

    describe "with maximum quality" do
      let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, max_quality) }

      it "should not get higher than max quality (50)" do
        expect{
          gilded_rose.update_quality
        }.not_to change{ item.quality }
      end
    end
  end
end
