require 'spec_helper'
describe ParallelTsort::Sorter do
  let(:sorter) { ParallelTsort::Sorter.new }

  context "happy path" do
    before do
      sorter.add_dependency :web, [:database, :redis]
      sorter.add_dependency :queue, [:database, :redis]
      sorter.add_dependency :database
      sorter.add_dependency :redis
    end

    it "should sort in serial" do
      sorter.run.should == [:database, :redis, :web, :queue]
    end

    it "should sort in parallel" do
      sorter.run(true).should == [[:database, :redis], [:web, :queue]]
    end
  end

  context "with deps in reverse" do
    before do
      sorter.add_dependency :redis
      sorter.add_dependency :database
      sorter.add_dependency :web, [:database, :redis]
      sorter.add_dependency :queue, [:database, :redis]
    end

    it "should sort in serial" do
      sorter.run.should == [:redis, :database, :web, :queue]
    end

    it "should sort in parallel" do
      sorter.run(true).should == [[:redis, :database], [:web, :queue]]
    end
  end

  context "with only one item" do
    before do
      sorter.add_dependency :redis
    end

    it "should sort in serial" do
      sorter.run.should == [:redis]
    end

    it "should sort in parallel" do
      sorter.run(true).should == [[:redis]]
    end
  end

  context "with nothing added" do
    it "should sort in serial" do
      sorter.run.should == []
    end

    it "should sort in parallel" do
      sorter.run(true).should == []
    end
  end

  context "with a dependency that does not exist" do
    before do
      sorter.add_dependency :queue, [:redis]
    end

    it "should sort in serial" do
      expect {
        sorter.run
      }.to raise_error(ParallelTsort::MissingNode)
    end

    it "should sort in parallel" do
      expect {
        sorter.run(true)
      }.to raise_error(ParallelTsort::MissingNode)
    end
  end

  context "with cycle" do
    before do
      sorter.add_dependency :queue, [:redis]
      sorter.add_dependency :redis, [:queue]
    end

    it "should sort in serial" do
      expect {
        sorter.run
      }.to raise_error(TSort::Cyclic)
    end

    it "should sort in parallel" do
      expect {
        sorter.run(true)
      }.to raise_error(TSort::Cyclic)
    end
  end

  context "with node depending on itself" do
    it "should raise an error" do
      expect {
        sorter.add_dependency :queue, [:queue]
      }.to raise_error(ParallelTsort::SelfDependentNode)
    end
  end

  context "non parallel dependencies" do
    before do
      sorter.add_dependency :web, [:queue]
      sorter.add_dependency :queue, [:database]
      sorter.add_dependency :database, [:redis]
      sorter.add_dependency :redis
    end

    it "should sort in serial" do
      sorter.run.should == [:redis, :database, :queue, :web]
    end

    it "should sort in parallel" do
      sorter.run(true).should == [[:redis], [:database], [:queue], [:web]]
    end
  end
end
