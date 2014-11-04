require 'yaml'

class HashWithIndifferentAccess < Hash
  def initialize(hash = {})
    hash.each_pair { |key, value| self[key] = value }
  end

  def []=(key, value)
    self.merge!({ key.to_s => value })
  end

  def [](key)
    if self.has_key? key then return self.to_h[key] else nil end
  end
end

class Hash
  def with_indifferent_access
    HashWithIndifferentAccess.new(self)
  end
end

class Track
  attr_accessor :artist, :name, :album, :genre
  def initialize(*track_info)
    track_info = track_info[0].with_indifferent_access
    if track_info.size == 4
      @artist = track_info['artist']
      @name   = track_info['name']
      @album  = track_info['album']
      @genre  = track_info['genre']
    elsif track_info.size == 1
      @artist = track_info.fetch('artist')
      @name   = track_info.fetch('name')
      @album  = track_info.fetch('album')
      @genre  = track_info.fetch('genre')
    else
      raise KeyError, track_info.size > 4 ? 'Too much arguments' : 'Too little arguments'
    end
  end

  def each(&block)
    [@artist, @name, @album, @genre].each(&block)
  end
end

class Playlist
  attr_accessor :tracks

  def self.from_yaml(path)
    file = YAML.load_file(path)
    yaml_tracks = []
    file.each { |track| yaml_tracks << Track.new(track) }
    Playlist.new yaml_tracks
  end

  def initialize(*tracks)
    @tracks = tracks.flatten
  end

  def each(&block)
    @tracks.each(&block)
  end

  def find(&block)
    Playlist.new @tracks.select { |track| yield track }
  end

  def find_by(*filters)
    filtered_tracks = filters.map { |filter| @tracks.select { |track| filter.call track } }
    Playlist.new filtered_tracks.reduce(&:&)
  end

  def find_by_name(name)
    Playlist.new @tracks.select { |track| track.name == name }
  end

  def find_by_artist(artist)
    Playlist.new @tracks.select { |track| track.artist == artist }
  end

  def find_by_album(album)
    Playlist.new @tracks.select { |track| track.album == album }
  end

  def find_by_genre(genre)
    Playlist.new @tracks.select { |track| track.genre == genre }
  end

  def shuffle
    @tracks.shuffle
  end

  def random
    @tracks.sample
  end

  def to_s
    @tracks.each do |track|
      track_data = track.each {}
      puts "\nArtist: #{track_data[0]}\nName: #{track_data[1]}\n" \
        "Album: #{track_data[2]}\nGenre: #{track_data[3]}\n\n"
      end
    nil
  end

  def &(playlist)
    Playlist.new @tracks and playlist.tracks
  end

  def |(playlist)
    Playlist.new @tracks or playlist.tracks
  end

  def -(playlist)
    Playlist.new @tracks - playlist.tracks
  end
end
