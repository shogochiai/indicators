require 'spec_helper'

describe Indicators::Main do
  context "should raise an exception if" do
    it "there was no data to work on" do
      data = {date:[],open:[],high:[],low:[],close:[],volume:[],adj_close:[]}
      Array.new(100).each_with_index.map do |x,i|
          data[:date].push (Date.today+i).to_s
          data[:open].push (2000+rand(500)*(-1)**[0,1].sample)
          data[:high].push (2500+rand(500)*(-1)**[0,1].sample)
          data[:low].push (1500+rand(500)*(-1)**[0,1].sample)
          data[:close].push (2000+rand(500)*(-1)**[0,1].sample)
          data[:volume].push "9286500"
          data[:adj_close].push 2000+rand(500)*(-1)**[0,1].sample
      end
      expect (
        Indicators::Psar.calculate(data, [0.02, 0.2])
      ).to be true
    end
  end
end
