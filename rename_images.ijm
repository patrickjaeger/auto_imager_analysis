#@ File (label="Select file", style = "file") file


path = File.getDirectory(file);
tags = split(file, "_");

tags[7] = parse_digits(tags[7]);
print(tags[7]);
if (lengthOf(tags[7]) < 2) {
  tags[7] = "day" + addLeadingZero(tags[7]);
    print(tags[7]);
  new_name = String.join(tags, "_");
  new_file = path + File.separator + "test" + new_name;
  print(new_file);
  File.rename(file, new_file);
}


// FUNCTIONS --------------------------------------------
function parse_digits(_str) { 
// Extracts all digits in a string.
  digits = "";
  for (i = 0; i < lengthOf(_str); i++) {
    substr = substring(_str, i, i+1);
    if (matches(substr, "\\d")) {
      digits = digits + substr;
    }
  }
  return digits;
}

function addLeadingZero(_day) {
  if (lengthOf(_day) == 1) {_day = "0" + _day;}
  return _day;
}