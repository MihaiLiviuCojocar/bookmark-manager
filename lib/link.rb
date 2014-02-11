# This class coresponds to a table in the data base
# We can use it to manipulate data

class Link

  # this makes the instances of this class Datamapper resources
  include DataMapper::Resource

  # This block decribes what resorces our mdoel will have
  property :id,    Serial # Searial means that it will be auto-incremented for every record
  property :title, String
  property :url,   String

end