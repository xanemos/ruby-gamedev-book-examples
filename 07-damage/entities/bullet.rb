class Bullet < GameObject
  attr_accessor :x, :y, :target_x, :target_y, :source, :speed, :fired_at

  def initialize(object_pool, source_x, source_y, target_x, target_y)
    super(object_pool)
    @x, @y = source_x, source_y
    @target_x, @target_y = target_x, target_y
    BulletPhysics.new(self, object_pool)
    BulletGraphics.new(self)
    BulletSounds.play
  end

  def box
    [x, y]
  end

  def explode
    Explosion.new(object_pool, @x, @y)
    object_pool.nearby(self, 100).each do |obj|
      if obj.class == Tank
        obj.health.inflict_damage(
          Math.sqrt(3 * Utils.distance_between(
              obj.x, obj.y, x, y)))
      end
    end
    mark_for_removal
  end

  def fire(source, speed)
    @source = source
    @speed = speed
    @fired_at = Gosu.milliseconds
  end
end