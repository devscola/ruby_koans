require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutEqualityObjects < Neo::Koan

  def test_equality_at_object_level_returns_true_only_if_are_the_same_object
    a = Object.new
    b = Object.new
    assert_equal __(false), a == b
    assert_equal __(true), a == a
    assert_equal __(false), a === b
    assert_equal __(false), a.equal?(b)
    assert_equal __(true), a.eql?(a)
  end

  def test_equality_method_is_overriden_in_descendant_classes_to_provide_class_specific_meaning
    assert_equal __(true), 16 == 16
    assert_equal __(true), "string" == "string"
    assert_equal __(true), "string" === "string"
    string = String.new("string")
    another_string = String.new("string")
    assert_equal __(true), string == another_string
  end

  # Note that the left side String is a different object than the right side String, 
  # but the result of comparing them it turns out true. Why is that? Because descendant
  # classes of BasicObject, like String class, override this methods (==, ===, eql?) to
  # provide class specific meaning. The same thing happens with Fixnum. 

  def test_eql_method_only_returns_true_if_objects_have_the_same_value
    hash1 = { :name => "Juan", :first_name => "Lopez" }
      hash2 = { :first_name => "Lopez", :name => "Juan" }
    assert_equal __(true), hash1.eql?(hash2)
    assert_equal __(true), "equality".eql?("equality")
  end

  # The eql? method returns true if one object and another object have the same value. 
  # This method is used by Hash to test members for equality neverminding order

  def test_equal_method_should_never_be_overriden_by_descendant_classes
    assert_equal __(false), "string".equal?("string") 
  end

  # Equality operators like (==) and (===) are overriden in the class String, and eql? method
  # test object values, but equal method is used to determine object identity, so "string".equal?("string")
  # will never be true

  class Car
  end

  def test_every_car_instance_should_be_different
    car = Car.new
    another_car = Car.new
    assert_equal __(false), car == another_car
  end

  class Car2
    attr_reader :model

    def initialize(model)
      @model = model
    end

    def ==(other)
      @model == other.model
    end
  end

  def test_overriding_equality_operators_in_subclasses
    car = Car2.new("coupe")
    another_car = Car2.new("coupe")
    another_one_more_car = Car2.new("off_road")
    assert_equal __(true), car == another_car
    assert_equal __(false), car == another_one_more_car
  end

  # What have we done here?? We have overriden equality in the class Car2 by defining 
  # our own method == 
end