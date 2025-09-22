/* Created by:
 * Patrick Jaeger; patrick.jaeger@hest.ethz.ch
 * Laboratory for Orthopaedic Biomechanics, ETH Zurich, Switzerland
 * Fiji/ImageJ 2.14.0/1.54f; Java 1.8.0_322 [64-bit]
 * July 2024
 * 
 * Description:
 * This macro cropes and rotates the central well of images acquired with
 * the AutoImager and saves them in a new file.
 * 
 * Use:
 * Run in Batch mode, select files, profit.
 */

#@ File (label="Select file", style = "file") file

// Manage file and output directory
open(file);
img_title = getTitle();
img_name = File.nameWithoutExtension;
dir = File.directory;
if (!File.isDirectory(dir + File.separator + "processed")) {
  File.makeDirectory(dir + File.separator + "processed");
}

// Isolate central well
makeRectangle(1128, 552, 2124, 1542);
run("Crop");
run("Duplicate...", "title=mask");
run("8-bit");


// Threshold
run("Maximum...", "radius=5");
setAutoThreshold("Li");
run("Convert to Mask");
run("Fill Holes");

// Find well blob
run("Set Measurements...", "area centroid bounding fit shape display " + 
    "redirect=None decimal=3");
run("Analyze Particles...", "size=300000-1400000 display exclude clear add");

// Rotate image
if (roiManager("count") != 1) {  // Abort if no well is found
  close("*");
  open(file);
  
  // Rotate
  setTool("line");
  waitForUser("Mark long axis, then press OK");
  getLine(x1, y1, x2, y2, lineWidth);
  dx = x2 - x1;
  dy = y2 - y1;
  angle_radians = atan2(dy, dx);
  print(angle_radians);
  angle_degrees = angle_radians* (180.0 / PI);
  rotation_angle = 90-angle_degrees;
  run("Rotate... ", "angle=" + rotation_angle + " interpolation=None");
  run("Select None");
  
  // Crop
  setTool("rectangle");
  waitForUser("Create selection to crop,\nthen press OK");
  run("Crop");
} else {
  angle = getResult("Angle", 0);
  rotation_angle = angle;
  run("Rotate... ", "angle=" + rotation_angle);

  // Find rotated blob
  run("Analyze Particles...", "size=300000-1400000 display exclude add");

  // Process source image
  if (roiManager("count") != 2) {  // Abort if no well is found
    print("Error in:  " + img_title);
  } else {
    close("mask");
  
    // Rotate
    selectWindow(img_title);
    angle = getResult("Angle", 0);
    rotation_angle = angle;
    run("Rotate... ", "angle=" + rotation_angle);
  
    // Crop
    makeRectangle(
     getResult("BX", 1),
     getResult("BY", 1),
    getResult("Width", 1),
    getResult("Height", 1)
    );
  
    getSelectionBounds(x, y, width, height);
    if (width < 1000) {
      waitForUser("Adjust selection to crop,\nthen press OK");
      run("Crop");
    } else
      run("Crop");
    }
} 

// Save
saveAs("Jpeg", dir + File.separator + "processed" + File.separator + 
       img_name + "_crpd.jpg");

// Tidy up
close("*");
run("Clear Results");
if (roiManager("count") > 0) { 
  roiManager("Delete");
}

