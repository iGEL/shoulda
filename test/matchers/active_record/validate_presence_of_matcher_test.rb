require File.join(File.dirname(__FILE__), '..', '..', 'test_helper')

class ValidatePresenceOfMatcherTest < ActiveSupport::TestCase # :nodoc:

  context "a required attribute" do
    setup do
      define_model :example, :attr => :string do
        validates_presence_of :attr
      end
      @model = Example.new
    end

    should "require a value" do
      assert_accepts validate_presence_of(:attr), @model
    end

    should "not override the default message with a blank" do
      assert_accepts validate_presence_of(:attr).with_message(nil), @model
    end
  end

  context "an optional attribute" do
    setup do
      @model = define_model(:example, :attr => :string).new
    end

    should "not require a value" do
      assert_rejects validate_presence_of(:attr), @model
    end
  end

  context "a required has_many association" do
    setup do
      define_model :child
      @model = define_model :parent do
        has_many :children
        validates_presence_of :children
      end.new
    end

    should "require the attribute to be set" do
      assert_accepts validate_presence_of(:children), @model
    end
  end

  context "an optional has_many association" do
    setup do
      define_model :child
      @model = define_model :parent do
        has_many :children
      end.new
    end

    should "not require the attribute to be set" do
      assert_rejects validate_presence_of(:children), @model
    end
  end

  context "a required has_and_belongs_to_many association" do
    setup do
      define_model :child
      @model = define_model :parent do
        has_and_belongs_to_many :children
        validates_presence_of :children
      end.new
    end

    should "require the attribute to be set" do
      assert_accepts validate_presence_of(:children), @model
    end
  end

  context "an optional has_and_belongs_to_many association" do
    setup do
      define_model :child
      @model = define_model :parent do
        has_and_belongs_to_many :children
      end.new
    end

    should "not require the attribute to be set" do
      assert_rejects validate_presence_of(:children), @model
    end
  end

  context "raise no error with i18n messages using {{attribute}}" do
    setup do
      I18n.backend.send :merge_translations, :en, {"activerecord" => {"errors" => {"messages" => {
              "blank" => "{{attribute}} can't be blank"
            }}}}
      define_model :example, :attr => :string do
        validates_format_of :attr, :with => /abc/
      end
      @model = Example.new
    end

    teardown do
      I18n.backend.send :merge_translations, :en, {"activerecord" => {"errors" => {"messages" => {
              "blank" => "can't be blank"
            }}}}
    end

    should "not raise any error" do
      assert_nothing_raised do
        assert_rejects validate_presence_of(:attr), @model
      end
    end
  end

  context "raise no error with i18n messages using {{value}}" do
    setup do
      I18n.backend.send :merge_translations, :en, {"activerecord" => {"errors" => {"messages" => {
              "blank" => "{{value}} is blank"
            }}}}
      define_model :example, :attr => :string do
        validates_format_of :attr, :with => /abc/
      end
      @model = Example.new
    end

    teardown do
      I18n.backend.send :merge_translations, :en, {"activerecord" => {"errors" => {"messages" => {
              "blank" => "can't be blank"
            }}}}
    end

    should "not raise any error" do
      assert_nothing_raised do
        assert_rejects validate_presence_of(:attr), @model
      end
    end
  end

  context "raise no error with i18n messages using {{model}}" do
    setup do
      I18n.backend.send :merge_translations, :en, {"activerecord" => {"errors" => {"messages" => {
              "blank" => "{{model}} doesn't allow this field to be blank"
            }}}}
      define_model :example, :attr => :string do
        validates_format_of :attr, :with => /abc/
      end
      @model = Example.new
    end

    teardown do
      I18n.backend.send :merge_translations, :en, {"activerecord" => {"errors" => {"messages" => {
              "blank" => "can't be blank"
            }}}}
    end

    should "not raise any error" do
      assert_nothing_raised do
        assert_rejects validate_presence_of(:attr), @model
      end
    end
  end
end
