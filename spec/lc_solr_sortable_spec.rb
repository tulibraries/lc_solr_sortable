RSpec.describe LcSolrSortable do
  it "has a version number" do
    expect(LcSolrSortable::VERSION).not_to be nil
  end

  it "converts a call number to a string of letters" do
    expect(LcSolrSortable.convert("QA71.5.B5")).to match /^[a-z]+$/i
  end

  it "sorts call numbers correctly" do
    numbers = %w(QA71.E359 QA71.E359.E3 QA71.E359.E35 QA71.1.E35)
    sorted_numbers = numbers.shuffle.sort_by { |num| LcSolrSortable.convert(num) }
    expect(sorted_numbers).to eq numbers
  end
end
