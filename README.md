# Auto Imager Analysis

**In imageJ:**

1. Move all images into one folder
2. Delete images in which there is no chamber
3. Run **AutoCrop.ijm** (in Batch Mode) on your images
4. (Semi-optional) Check the marked images for mistakes and delete images of torn gels
5. Run **AutoMeasure.ijm** (in Batch Mode) on all the cropped images
6. Save Results table as CSV-file, e.g. in auto_imager_analysis/data

**In R:**

8. Run **calculate_forces.R** and process your results file
    - This will create two files with forces calculated for each post, or averaged per donor/chamber


