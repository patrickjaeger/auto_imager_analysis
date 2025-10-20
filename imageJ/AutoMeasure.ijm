/* Created by:
 * Patrick Jaeger; patrick.jaeger@hest.ethz.ch
 * Laboratory for Orthopaedic Biomechanics, ETH Zurich, Switzerland
 * Fiji/ImageJ 2.14.0/1.54f; Java 1.8.0_322 [64-bit]
 * July 2024
 * 
 * Description:
 * This macro measures the distance between two post in images
 * generated with the AutoImager.
 * 
 * Use:
 * Run in Batch mode, select files, save Distance table.
 */

DEBUG = 0;
scale = 0.141;  // px/micron
#@ File (label="Select file", style = "file") file
clear_everything();
run("Set Measurements...", "area centroid shape display redirect=None decimal=3");

// Manage file and output directory
open(file);
img_title = getTitle();
img_name = File.nameWithoutExtension;
tags = split(img_name, "_");

// Segment image
run("Duplicate...", "title=mask");
run("8-bit");
run("Gaussian Blur...", "sigma=3");
run("Maximum...", "radius=20");
setThreshold(130, 255);
setOption("BlackBackground", true);
run("Convert to Mask");

run("Analyze Particles...", "size=5000-16000 circularity=0.70-1.00 display exclude add");
//for (i = 0; i < roiManager("count"); i++) {
//  roiManager("select", i);
//  run("Fill Holes");
//}
//roiManager("reset");
//run("Analyze Particles...", "size=5000-15000 circularity=0.70-1.00 display exclude add");
close("mask");


if (nResults != 2) {
  run("Clear Results");
  makeOval(185, 248, 206, 206);
  waitForUser("Place circle, then press OK");
  if (selectionType() == 1) {run("Measure");}
  makeOval(1159, 264, 206, 206);
  waitForUser("Place circle, then press OK");
  if (selectionType() == 1) {run("Measure");}
  run("Select None");
}

n_blobs = nResults;
if (n_blobs == 2) {
  x1 = getResult("X", 0);
  y1 = getResult("Y", 0);
  x2 = getResult("X", 1);
  y2 = getResult("Y", 1);
} 

close("Results");

// Create distance table and/or table entry
colnames = newArray("experiment", "chamber", "k", "donor", "passage", 
                    "condition", "post", "day", "distance_um");

table_name = tags[0] + "_distances";
if (!isOpen(table_name)) {
  Table.create(table_name);
  selectWindow(table_name);
  for (i=0; i<colnames.length; i++) {
    Table.setColumn(colnames[i], newArray());
  }
}

selectWindow(table_name);

current_row = Table.size;
for (i=0; i<colnames.length-1; i++) {
  Table.set(colnames[i], current_row, tags[i]);
}
string_day = Table.getString("day", current_row);
numeric_day = parse_digits(string_day);
Table.set("day", current_row, numeric_day);

// Calculate distance and write to table
if (n_blobs == 2) {
  distance = calculate_distance(x1, y1, x2, y2);
  distance = distance/scale;
} else {
  distance = "NA";
}

Table.set("distance_um", current_row, distance);
Table.update;

// Draw circles on source image
if (n_blobs == 2) {
  selectWindow(img_title);
  draw_circle(x1, y1);
  draw_circle(x2, y2);
}

// Save marked image
dir = File.directory;
out_dir = dir + File.separator + "marked";
if (!File.isDirectory(out_dir)) {
  File.makeDirectory(out_dir);
}
save_marked_image(img_name, out_dir);

// Tidy up
clear_everything();


// FUNCTIONS -----------------------------------
function clear_everything() { 
  close("*");
  run("Clear Results");
  if (roiManager("count") > 0) { 
    roiManager("Delete");
  }
}

function calculate_distance(_x1, _y1, _x2, _y2) { 
// Calculate distance from values in Results table
  dx = _x2 - _x1;
  dy = _y2 - _y1;
  distance = sqrt(dx * dx + dy * dy);
  return distance;
}

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

function draw_circle(_x, _y) { 
  r = 110;

  run("Line Width...", "line=5");
  setForegroundColor(51, 255, 255);
  drawOval(_x-r, _y-r, 2*r, 2*r);
  drawLine(_x-20, _y, _x+20, _y);
  drawLine(_x, _y-20, _x, _y+20);
}

function save_marked_image(_img_name, _out_dir) { 
// Resize and save image as jpg.
  getDimensions(width, height, channels, slices, frames);
  new_width = round(width*0.33);
  run("Size...", "width=" + new_width + 
      " depth=1 constrain average interpolation=Bilinear");
      
  new_img_name = _img_name + "_fit.jpg";
  saveAs("Jpeg", _out_dir + File.separator + new_img_name);
}