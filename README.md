# Auto Imager Analysis

**In imageJ:**

1. Run **AutoCrop.ijm** (in Batch Mode) on your images
2. Move all cropped images into one folder
3. Run **AutoRename.py** (in Normal Mode) on the folder containing the cropped images
4. (Semi-optional) Check the marked images for mistakes
5. Run **AutoMeasure.ijm** (in Batch Mode) on all the renamed, cropped images
6. Save Results table as CSV-file, e.g. in auto_imager_analysis/data

**In R:**

7. Run **calculate_forces.R** and process your results file
    - This will create two files with forces calculated for each post, or averaged per donor/chamber


