require 'spec_helper'

describe Indicators::Psar do
  context "should calculate correctly" do
    it "should contain correct data format" do
      input_format = {date:[],open:[],high:[],low:[],close:[],volume:[],adj_close:[]}
      output_format = [:dates,:high,:low,:close,:psar,:psarbear,:psarbull]
      res = Indicators::Psar.calculate(input_format, [0.02, 0.2])
      (res.keys & output_format).size.should be output_format.size
    end
    it "should be error because of the input amount" do
      data = {date:["2017-07-05", "2017-07-06"],open:[10,12],high:[12,13],low:[9,10],close:[10,12],volume:[100,120],adj_close:[10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should be_nil
      res[:psarbull].last.should be_nil
      res[:psarbear].size.should be data[:date].size
      res[:psarbear].first.should be_nil
      res[:psarbear].last.should be_nil
    end
    it "should be monotonically bull" do
      data = {date:["2017-07-05", "2017-07-06","2017-07-07"],open:[10,12,14],high:[12,13,14],low:[9,10,12],close:[10,12,14],volume:[100,120,90],adj_close:[10,10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should be_nil
      res[:psarbull].last.should_not be_nil
      res[:psarbear].size.should be data[:date].size
      res[:psarbear].first.should be_nil
      res[:psarbear].last.should be_nil
    end
    it "should be monotonically bear" do
      data = {date:["2017-07-05", "2017-07-06","2017-07-07","2017-07-08","2017-07-09"],open:[10,20,30,40,50],high:[12,22,32,42,52],low:[8,18,28,38,48],close:[10,20,30,40,50],volume:[100,120,90,100,100],adj_close:[10,10,10,10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should be_nil
      res[:psarbull].last.should_not be_nil
      res[:psarbull][2].should be > res[:psarbull][1]
      res[:psarbull][3].should be > res[:psarbull][2]
      res[:psarbull][4].should be > res[:psarbull][3]
      res[:psarbull][5].should be > res[:psarbull][4]
      res[:psarbear].size.should be data[:date].size
      res[:psarbear].first.should be_nil
      res[:psarbear].last.should be_nil
    end
    it "should start with bull and end with bear" do
    end
    it "should start with bear and end with bull" do
    end
    it "should be all bull except the last bear" do
    end
    it "should be all bear except the last bull" do
    end
  end
end
