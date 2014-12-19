# -*- coding: utf-8 -*-
require './gilded_rose.rb'
require './gilded_rose_spec_helper.rb'

require "rspec"

describe GildedRose do
  let(:gilded_rose) { GildedRose.new(item) }
  let(:zero_quality) { 0 }
  let(:max_quality) { 50 }
  let(:zero_sell_in) { 0 }

  describe "Updating Normal Items" do
    describe "while in date" do
      let(:sell_in) { 10 }
      let(:quality) { 1 }
      let(:item) { Item.new("Normal Item", sell_in, quality) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          to(sell_in - 1)
      end

      it "should decrease the quality" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(zero_quality)
      end

      context "with zero quality items" do
        let(:sell_in) { 10 }
        let(:quality) { 0 }
        let(:item) { Item.new("Normal Item", sell_in, quality) }

        it "should not decrease the quality below zero" do
          expect{ gilded_rose.update_quality}.
            not_to change{ item.quality }
        end
      end
    end

    describe "when sell in hits zero" do
      let(:sell_in) { 1 }
      let(:quality) { 10 }
      let(:item) { Item.new("Normal Item", sell_in, quality) }

      it "should have a zero sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          to(zero_sell_in)
      end

      it "should have decreased quality by 1" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(quality - 1)
      end
    end

    describe "when sell in passes zero" do
      let(:sell_in) { 0 }
      let(:quality) { 10 }
      let(:item) { Item.new("Normal Item", sell_in, quality) }

      it "should have a negative sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          to(zero_sell_in - 1)
      end

      it "should have decreased quality by 2" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(quality - 2)
      end
    end
  end

  describe "for legendary items" do
    let(:sell_in) { 0 }
    let(:quality) { 80 }
    let(:item) { Item.new("Sulfuras, Hand of Ragnaros", sell_in, quality) }

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
      let(:sell_in) { 2 }
      let(:quality) { zero_quality }
      let(:item) { Item.new("Aged Brie", sell_in, quality) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          to(sell_in - 1)
      end

      it "should increase in quality" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(quality + 1)
      end

      it "should not increase beyond 50" do
        expect{
          52.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          to(max_quality)
      end
    end

    describe "approaching sell in" do
      let(:sell_in) { zero_sell_in + 1 }
      let(:quality) { zero_quality }
      let(:item) { Item.new("Aged Brie", sell_in, quality) }

      it "should have zero sell in date" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          to(zero_sell_in)
      end

      it "increases in age when older" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(quality + 1) # does this represent age??
      end
    end

    describe "after sell in" do
      let(:sell_in) { -5 }
      let(:quality) { 0 }
      let(:item) { Item.new("Aged Brie", sell_in, quality) }

      it "should decrease the sell in" do
        expect{ gilded_rose.update_quality }.
          to change{ item.sell_in }.
          to(sell_in - 1)
      end

      it "increases in age when older" do
        expect{ gilded_rose.update_quality }.
          to change{ item.quality }.
          to(quality + 2)
      end
    end

    describe "with maximum quality" do
      let(:sell_in) { 10 }
      let(:quality) { max_quality }
      let(:item) { Item.new("Aged Brie", sell_in, quality) }

      it "should not increase quality beyond 50" do
        expect{ gilded_rose.update_quality }.
          not_to change{ item.quality }
      end
    end
  end

  describe "for Backstage Passes" do
    let(:sell_in) { 15 }
    let(:quality) { 20 }
    let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality) }

    it "should decrease sell in" do
      expect{ gilded_rose.update_quality }.
        to change{ item.sell_in }.
        to(sell_in - 1)
    end

    describe "increases in quality" do
      it "should be by 1 when sell_in is 15-10" do
        expect{
          5.times { gilded_rose.update_quality }
        }.to change{ item.quality}.
          to(quality + 5)
      end

      it "should be by 2 when sell_in < 10" do
        expect{
          5.times { gilded_rose.update_quality }
          1.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          from(quality).to(quality + (5*1) + (1*2))
      end

      it "should be by 3 when sell_in < 5" do
        expect{
          5.times { gilded_rose.update_quality } # 10 days
          5.times { gilded_rose.update_quality } # 5 days
          1.times { gilded_rose.update_quality } # 4 days + 3
        }.to change{ item.quality }.
          to(quality + (5*1) + (5*2) + (1*3))
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
      let(:sell_in) { 15 }
      let(:quality) { 49 }
      let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", sell_in, quality) }

      it "should not get higher than 50 quality" do
        expect{
          11.times { gilded_rose.update_quality }
        }.to change{ item.quality }.
          to(max_quality)
      end
    end
  end
end
