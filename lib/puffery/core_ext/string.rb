String.class_eval do
  def capitalize_words
    gsub(/\b(?<!\.)('?[a-z])/) { $1.capitalize }
  end
end
