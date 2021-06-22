# frozen_string_literal: true

require "assert"
require "rails-nm"

module RailsNm
  class SystemTests < Assert::Context
    desc "RailsNm"
    subject{ RailsNm }
  end

  class RenderTests < SystemTests
    desc "when rendering an Nm template in Rails"

    let(:user_class){ Struct.new(:id, :first_name, :last_name) }
    let(:users) do
      Array.new(Factory.integer(3)) do
        user_class.new(Factory.integer, Factory.string, Factory.string)
      end
    end

    let(:template_source) do
      <<~SOURCE
        map @users do |user|
          partial "users/user.json", :user => user
        end
      SOURCE
    end

    should "should render as expected" do
      exp =
        users.map do |user|
          {
            "id" => user.id,
            "firstName" => user.first_name,
            "lastName" => user.last_name,
          }
        end

      assert_that(render(template_source, users: users)).equals(exp)
    end
  end
end
