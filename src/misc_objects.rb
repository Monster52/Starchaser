class Meteor < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection, :effect, :velocity, :timer 
  attr_reader :radius

  def initialize(options={})
    super
    @image = Image["meteor_rw.png"]  
    @radius = 15
    self.zorder = 100
    self.x =rand * 1000
    self.y = 0 
    cache_bounding_circle
  end

  def update
    @image


    @x %= $window.width
    @y %= $window.height
  end

end

class Star < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection
  attr_reader :radius

  def initialize(options={})
    super
    @image = Image["star_rw.png"]  
    @radius = 10 
    self.zorder = 100
    self.x =rand * 1000
    self.y =rand * 800 
    cache_bounding_circle
  end

  def update
    @image
  end
end

class PowerUp < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection
  attr_reader :radius, :type
  
  def initialize(options={})
    super
    @type = options[:type] || 2
    @image = Image["pu_single.png"] if @type == 1
    @image = Image["pu_doubs.png"] if @type == 2
    @image = Image["pu_trips.png"] if @type == 3
    @radius = 10
  end
end
