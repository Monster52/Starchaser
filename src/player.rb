class Player < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection, :effect, :velocity
  def initialize(options = {})
    super(options)
    @image = Image["ship.png"]

    self.max_velocity = 15 

    self.input = { [:holding_a, :holding_left]  => :turn_left,
                      [:holding_d, :holding_right] => :turn_right,
                      [:holding_w, :holding_up]    => :accelerate,
                      [:holding_s, :holding_down]  => :deccelerate,
                      [:space, :return] => :fire
                    }
  end

  def accelerate
    self.velocity_x = Gosu::offset_x(self.angle, 0.5)*self.max_velocity_x
    self.velocity_y = Gosu::offset_y(self.angle, 0.5)*self.max_velocity_y
  end

  def deccelerate
    self.velocity_x = Gosu::offset_x(self.angle, -0.5)*self.max_velocity_x
    self.velocity_y = Gosu::offset_y(self.angle, -0.5)*self.max_velocity_y
  end

  def turn_right
    # The same can be achieved without trait 'effect' as: self.angle += 4.5
    rotate(5.0)
  end

  def turn_left
    # The same can be achieved without trait 'effect' as: self.angle -= 4.5
    rotate(-5.0)
  end

  def update
    self.velocity_x *= 0.95
    self.velocity_y *= 0.95

    @x %= $window.width #wrap around the screen
    @y %= $window.height
  end

  def fire


    if $window.firepower == 1
      Bullet.create(:x => @x, :y => @y, :angle => @angle)
      Sound["Laser_08.wav"].play
    elsif $window.firepower == 2
      Bullet.create(:x => @x, :y => @y, :angle => @angle)
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, 25), :y => @y + Gosu::offset_y(@angle+90, 25), :angle => @angle)
      Sound["Laser_08.wav"].play
    elsif $window.firepower == 3
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, -25), :y => @y + Gosu::offset_y(@angle+90, -25), :angle => @angle)
      Bullet.create(:x => @x, :y => @y, :angle => @angle)
      Bullet.create(:x => @x + Gosu::offset_x(@angle+90, 25), :y => @y + Gosu::offset_y(@angle+90, 25), :angle => @angle)
      Sound["Laser_08.wav"].play
    end
  end

  
end

class Bullet < Chingu::GameObject
  trait :bounding_circle
  traits :collision_detection
  attr_reader :radius

  def initialize(options={})
    super(options.merge(:image => Image["bullet_rw.png"]))
    @speed = 15 
    @radius = 10 
    @velocity_x = Gosu::offset_x(@angle, @speed)
    @velocity_y = Gosu::offset_y(@angle, @speed)
  end

  # Move bullet forward
  def update
    @y += @velocity_y
    @x += @velocity_x
  end
end


