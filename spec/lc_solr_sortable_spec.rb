# frozen_string_literal: true

RSpec.describe LcSolrSortable do
  it "has a version number" do
    expect(LcSolrSortable::VERSION).not_to be nil
  end

  it "converts a call number to a string of letters" do
    expect(LcSolrSortable.convert("QA71.5.B5")).to match(/^[a-z]+$/i)
  end

  it "sorts call numbers correctly" do
    numbers = %w[QA71.E359 QA71.E359.E3 QA71.E359.E35 QA71.1.E35]
    sorted_numbers = numbers.shuffle.sort_by { |num| LcSolrSortable.convert(num) }
    expect(sorted_numbers).to eq numbers
  end

  it "sorts these call numbers correctly" do
    numbers = ["M357 .K86 op.86 1900z",
               "M357.M9 L3 1986",
               "M357.M85 D5 1942",
               "M357.M417 C7 1963",
               "M357.M565 S8",
               "M357.Q46 S663 1961"]
    sorted_numbers = numbers.sort_by { |num| LcSolrSortable.convert(num) }
    expect(sorted_numbers).to eq ["M357 .K86 op.86 1900z",
                                  "M357.M417 C7 1963",
                                  "M357.M565 S8",
                                  "M357.M85 D5 1942",
                                  "M357.M9 L3 1986",
                                  "M357.Q46 S663 1961"]
  end

  it "sorts numbers differently before the decimal" do
    numbers = ["M20.B121",
               "M20.B21",
               "M120.B121",
               "M120.B21"]
    sorted_numbers = numbers.reverse.sort_by { |num| LcSolrSortable.convert(num) }
    expect(sorted_numbers).to eq numbers
  end
end
