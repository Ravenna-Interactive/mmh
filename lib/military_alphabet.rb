class MilitaryAlphabet
  
  ALPHABET = [['A', 'Alpha'],
  ['B', 'Bravo'],
  ['C', 'Charlie'],
  ['D', 'Delta'],
  ['E', 'Echo'],
  ['F', 'Foxtrot'],
  ['G', 'Golf'],
  ['H', 'Hotel'],
  ['I', 'India'],
  ['J', 'Juliet'],
  ['K', 'Kilo'],
  ['L', 'Lima'],
  ['M', 'Mike'],
  ['N', 'November'],
  ['O', 'Oscar'],
  ['P', 'Papa'],
  ['Q', 'Quebec'],
  ['R', 'Romeo'],
  ['S', 'Sierra'],
  ['T', 'Tango'],
  ['U', 'Uniform'],
  ['V', 'Victor'],
  ['W', 'Whiskey'],
  ['X', 'X-Ray'],
  ['Y', 'Yankee'],
  ['Z', 'Zulu']]
  
  def initialize
    @alphabet = ALPHABET.collect{ |c| c.last }
  end
  
  def [](index)
    @alphabet[index%(@alphabet.count)]
  end
  
  
end