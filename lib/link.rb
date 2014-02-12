# This class coresponds to a table in the data base
# We can use it to manipulate data

class Link

  # this makes the instances of this class Datamapper resources
  include DataMapper::Resource

  has n, :tags, :through => Resource
  # This block decribes what resorces our mdoel will have
  property :id,    Serial # Searial means that it will be auto-incremented for every record
  property :title, String
  property :url,   String

  def add_link(url, title, tags = [])
    within('#new-link') do
      fill_in 'url', :with => url
      fill_in 'title', :with => title
      # our tags will be space separated
      fill_in 'tags', :with => tags.join(' ')
      click_button 'Add link'
    end
  end

end

class Tag

  include DataMapper::Resource

  has n, :links, :through => Resource

  property :id, Serial
  property :text, String

end
