module Vedeu
  module Repository
    def adaptor
      @adaptor ||= Storage.new
    end

    def adaptor=(adaptor)
      @adaptor = adaptor
    end

    def find(id)
      adaptor.find(self.klass, id)
    end

    def find_by_name(name)
      query(name)
    end

    def all
      adaptor.all(self.klass)
    end

    def save(model)
      return update(model) if model.id
      create(model)
    end

    def query(selector)
      adaptor.query(self.klass, selector)
    end

    def create(model)
      adaptor.create(model)
    end

    def update(model)
      adaptor.update(model)
    end

    def delete(model)
      adaptor.delete(model)
    end

    def reset
      adaptor.reset(self.klass)
    end
  end
end
