require "rails_helper"

RSpec.describe Site::ConfigurationsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/site/configurations").to route_to("site/configurations#index")
    end

    it "routes to #new" do
      expect(:get => "/site/configurations/new").to route_to("site/configurations#new")
    end

    it "routes to #show" do
      expect(:get => "/site/configurations/1").to route_to("site/configurations#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/site/configurations/1/edit").to route_to("site/configurations#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/site/configurations").to route_to("site/configurations#create")
    end

    it "routes to #update" do
      expect(:put => "/site/configurations/1").to route_to("site/configurations#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/site/configurations/1").to route_to("site/configurations#destroy", :id => "1")
    end

  end
end
