class FlickrUtil
  require 'flickraw-cached'

  FlickRaw.api_key = Lifelist::Application::FLICKR_KEY
  FlickRaw.shared_secret = Lifelist::Application::FLICKR_SECRET

  def self.test
    photo_id= "3839885270"
    info = flickr.photos.getInfo(:photo_id => photo_id)
    puts FlickRaw.url_photopage(info) # => "http://www.flickr.com/photos/41650587@N02/3839885270"
    sizes = flickr.photos.getSizes :photo_id => photo_id
    medium = sizes.find {|s| s.label == 'Medium 640' }  # => "http://farm3.staticflickr.com/2485/3839885270_6fb8b54e06_z.jpg"
    puts medium["source"]
  end
  
  # http://www.flickr.com/services/api/flickr.photos.search.html
  def self.search(text)
    flickr.photos.search(:text=>text)
  end

  def self.get_photo_url(id, size='Medium 640')
    sizes = flickr.photos.getSizes :photo_id => id
    medium = sizes.find {|s| s.label == 'Medium 640' } 
    medium["source"]
  end

  def self.search_and_return_photo_url(text, num=0)
    results = search(:text=>text)
    results.length > 0 ? get_photo_url(results.first["id"]) : nil
  end

end