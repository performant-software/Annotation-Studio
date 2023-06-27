module AnthologiesHelper

  # Generate a list that contains the name
  # of each folder in the given anthology  
  # and the number of documents within it.
  def get_folders(anthology)
    tags = ActsAsTaggableOn::Tagging.where(
      tagger_id: anthology.id,
      taggable_type: 'Document',
      tagger_type: 'Anthology',
      context: 'rep_folder'
    ).joins(:tag).select('tags.name')

    folders = []

    tags.each do |t|
      existing = folders.find { |f| f[:name] == t.name }
      if existing
        existing[:count] += 1
      else
        folders.push({
          name: t.name,
          count: 1
        })
      end
    end

    folders
  end
end
