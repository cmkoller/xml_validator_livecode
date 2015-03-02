def validate_xml(filename)
  text = File.read(filename)

  puts does_it_match(text)
end

def does_it_match()

  # Self-closing tags - ignore these

  # Opening tag - validate its contents

  # Closing tag - make sure it matches the opening tag


end


validate_xml(ARGV[0])
