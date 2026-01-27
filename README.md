# Auto Imager Analysis

**In imageJ:**

1.  Move all images into one folder
2.  Delete images in which there is no chamber
3.  Run **AutoCrop.ijm** (in Batch Mode) on your images
4.  (Semi-optional) Check the marked images for mistakes and delete images of torn gels
5.  Run **AutoMeasure.ijm** (in Batch Mode) on all the cropped images
6.  Save Results table as CSV-file, e.g. in auto_imager_analysis/data

**In R:**

8.  Run **calculate_forces.R** and process your results file
    -   This will create two files with forces calculated for each post, or averaged per donor/chamber

**Notes**

-   Do not use underscores (\_) in your supplementary file. It will break file handling further down. If you want to add separators inside tags (like subconditions), use hyphens (-).

-   CSV-files must be true CSV-files (**C**omma-**S**eparated **V**alues: value, value, value). Excel, specifically on Mac, likes to reformat CSV files with semi-colons (;) instead of commas. This will also break the file handling and the Auto Imager won't image. How Excel saves CSV files is a setting in some submenu that you can google yourself.

-   Make sure there's enough space on the USB stick you're using. Mac-specific: deleting files might not actually delete them, they'll just be hidden. If the imager does not work, i.e. stops after 1-2 images, with your empty USB-stick, google how to properly delete files.
