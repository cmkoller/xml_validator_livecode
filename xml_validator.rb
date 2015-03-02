require 'pry'

def validate_xml(filename)
  text = File.read(filename)

  xml_elements = text.scan(/<[^<>]+>/)
  puts match_elements(xml_elements, nil)
end

def match_elements(items, parent_element)
  answer = nil
  # Go through each of the items.
  # For each one...
  while items.length > 0
    # Grab the first item off the front of the list
    cur = items.shift
    # Self-closing tag -- do nothing with it
    if cur =~ /<!.*>/ || cur =~ /<\?xml.*\?>/ || cur =~ /<.*\/>/
      next
    # Closing tag -- make sure it matches opening tag
    elsif cur.start_with?("</")
      # First extract the juicy part from the string, ignoring the </ and >
      closing_tag = cur[2..-2]
      opening_tag = parent_element[1,closing_tag.length]
      # Compare closing tag to the current "parent" opening tag
      if closing_tag == opening_tag
        return "VALID" # yay, it's a match! Element closed!
      else
        return "INVALID"
      end
    # Opening tag -- make sure its children are valid
    elsif cur.start_with?("<")
      # If we're at the top, but already processed a root element...
      if parent_element == nil && answer != nil
        return "INVALID" # since we can't have two root elements!
      end
      # Check the xml inside this element's tags to see if it's valid.
      answer = match_elements(items, cur)
      # If it's invalid, we should break immediately.
      if answer == "INVALID"
        return answer
      end
      #Otherwise, we should keep going in the loop and see what happens!
    end
  end

  # If we're done and and there are no unclosed tags, it's valid!
  if answer == "VALID" and !parent_element
    return "VALID"
  else # Otherwise, it was invalid.
    return "INVALID"
  end

end


validate_xml(ARGV[0])
