class Vector2D
  attr_accessor :x, :y

  def self.e
    Vector2D.new(1, 0)
  end

  def self.j
    Vector2D.new(0, 1)
  end

  def initialize(x, y)
    @x, @y = x, y
  end

  def length
    Math::sqrt(@x ** 2 + @y ** 2)
  end

  alias magnitude length

  def normalize
    return @x / length, @y / length
  end

  def ==(vector_or_scalar)
    case vector_or_scalar
      when Numeric then length == vector_or_scalar
      when Vector2D
        vector_or_scalar.x == @x and vector_or_scalar.y == @y ? true : false
    end
  end

  def +(vector_or_scalar)
    case vector_or_scalar
      when Fixnum   then Vector2D.new @x + vector_or_scalar, @y + vector_or_scalar
      when Vector2D then Vector2D.new(Math::sqrt((@x + vector_or_scalar.x)**2), Math::sqrt((@y + vector_or_scalar.y)**2))
    end
  end

  def -(vector_or_scalar)
    case vector_or_scalar
      when Fixnum   then Vector2D.new @x - vector_or_scalar, @y - vector_or_scalar
      when Vector2D then Vector2D.new Math::sqrt((@x - vector_or_scalar.x)**2), Math::sqrt((@y - vector_or_scalar.y)**2)
    end
  end

  def to_s
    'x: ' + @x.to_s + '; y: ' + @y.to_s + ';'
  end

  def inspect
    puts to_s
    to_s
  end

  def *(scalar)
    Vector2D.new @x * scalar, @y * scalar
  end

  def /(scalar)
    Vector2D.new @x.to_f / scalar, @y.to_f / scalar
  end

  def +@
    Vector2D.new(@x, @y)
  end

  def -@
    Vector2D.new(-@x, -@y)
  end
end


class Vector
  def initialize(*components)
    @coordinates = []
    components.flatten.each { |argument| @coordinates << argument }
  end

  def dimension
    @coordinates.size
  end

  def length
    Math::sqrt(@coordinates.map { |coordinate| coordinate ** 2 }.reduce(:+))
  end

  alias magnitude length

  def normalize
    @coordinates.map { |coordinate| coordinate / length }
  end

  def [](index)
    @coordinates[index - 1]
    self
  end

  def []=(index, element)
    @coordinates[index - 1] = element
    self
  end

  def ==(other)
    @coordinates == other.coordinates
  end

  def +(vector_of_same_dimension_or_scalar)
    shorter_name = vector_of_same_dimension_or_scalar.length
    if shorter_name.is_a? Vector and length == shorter_name.length
      new_vector_array = []
      0.upto(@coordinates.size - 1) do |index|
        new_vector_array << @coordinates[index] + shorter_name[index]
      end
    elsif shorter_name.is_a Numeric
      @coordinates.map { |coordinate| coordinate + shorter_name }
    end
  end

  def -(vector_of_same_dimension_or_scalar)
    shorter_name = vector_of_same_dimension_or_scalar.length
    if shorter_name.is_a? Vector and length == shorter_name.length
      new_vector_array = []
      0.upto(@coordinates.size - 1) do |index| 
        new_vector_array << @coordinates[index] - shorter_name[index]
      end
    elsif shorter_name.is_a Numeric
      @coordinates.map { |coordinate| coordinate - shorter_name }
    end
  end

  def *(scalar)
    @coordinates.map { |coordinate| coordinate * scalar }
  end

  def /(scalar)
    @coordinates.map { |coordinate| coordinate.to_f / scalar }
  end

  def to_s
    vectors_to_string = []
    str =    0.upto(@coordinates.size - 1) do |index|
      vectors_to_string << ' x' + (index + 1).to_s + ': ' + @coordinates[index].to_s + ';'
    end
    vectors_to_string.reduce(:+).strip
  end

  def inspect
    puts to_s
    to_s
  end
end

class Vector3D < Vector

  def initialize(x, y, z)
    super(x, y, z)
  end
end
