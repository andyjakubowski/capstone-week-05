class Space < ApplicationRecord
  has_many :lists, dependent: :destroy

  before_create :set_slug
  after_create :create_sample_lists

  def to_param
    slug
  end

  private

    def generate_slug
      array = []

      3.times { array << Faker::Creature::Animal.unique.name.parameterize }
      Faker::UniqueGenerator.clear

      array.join('-')
    end

    def set_slug
      loop do
        self.slug = generate_slug
        break unless Space.where(slug: slug).exists?
      end
    end

    def create_sample_lists
      create_list('light')
      create_list('dark')
      create_list('advanced')
    end

    def create_list(complexity)
      list = self.lists.new(name: "#{complexity.capitalize} Theme")
      tokens = YAML::load_file("db/seeds/tokens/#{complexity}.yml")
      tokens = tokens.each do |token|
        category = Category.find_by(name: token['category'])

        if category
          token['category_id'] = category.id
        end

        token.delete 'category'
      end
      list.tokens.new(tokens)
      list.save
      list.generate_css
    end
end
