module Fx
  module Math

    # detected point in polygon
    # x, y - numbers
    # polygon - array of [x,y] pairs. ([[1,2],[3,4],[5,6]])
    # algorithm was ported from http://ru.wikipedia.org/wiki/Алгоритм_точки_в_многоугольнике
    def point_in_polygon? x,y, polygon
      n = polygon.length
      c = false
      i = 0; j = n - 1
      while i < n do
        xi, yi = polygon[i]
        xj, yj = polygon[j]

        return true if xi == x && yi == y

        c = !c if yi < yj && yi <= y && y <= yj && (yj - yi) * (x - xi) > (xj - xi) * (y - yi) ||
                yi > yj && yj <= y && y <= yi && ((yj - yi) * (x - xi) < (xj - xi) * (y - yi))

        j = i; i+= 1
      end
      c
    end

    def polygons_for_point x, y, polygons
      polygons.inject([]) do |keys, key_and_polygon|
        key, polygon = key_and_polygon
        keys << key if point_in_polygon? x, y, polygon
        keys
      end
    end
  end
end