# ------------------------------------------------------------------------------
# Copyright (c) 2017 SUSE LLC, All Rights Reserved.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
# ------------------------------------------------------------------------------

require "yaml"
require_relative "test_helper"

require "y2packager/product_reader"

describe Y2Packager::ProductReader do
  subject { Y2Packager::ProductReader }

  describe "#available_base_products" do
    before do
      # TODO: proper mocking of pkg methods
      allow(subject).to receive(:installation_package_mapping).and_return("SLES" => "skelcd-SLES")
    end

    it "returns empty list if there is no product" do
      expect(Yast::Pkg).to receive(:ResolvableProperties).with("", :product, "")
        .and_return([])
      expect(subject.available_base_products).to eq([])
    end

    xit "returns Installation::Product objects" do
      products = YAML.load(load_fixture("products", "sles15.yml"))
      expect(Yast::Pkg).to receive(:ResolvableProperties).with("", :product, "")
        .and_return(products)
      expect(subject.available_base_products.first).to be_a(Y2Packager::Product)
    end

    xit "returns the correct product properties" do
      products = YAML.load(load_fixture("products", "sles15.yml"))
      expect(Yast::Pkg).to receive(:ResolvableProperties).with("", :product, "")
        .and_return(products)
      ret = subject.available_base_products.first
      expect(ret.name).to eq("SLES")
      expect(ret.label).to eq("SUSE Linux Enterprise Server 15 Alpha1")
    end

    xit "returns only the products from the initial repository" do
      sp3 = YAML.load(load_fixture("products", "sles15.yml")).first
      addon1 = sp3.dup
      addon1["source"] = 1
      addon2 = sp3.dup
      addon2["source"] = 2

      expect(Yast::Pkg).to receive(:ResolvableProperties).with("", :product, "")
        .and_return([addon2, addon1, sp3])

      expect(subject.available_base_products.size).to eq(1)
    end
  end
end
