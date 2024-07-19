# Auto Imager Analysis

In imageJ:
1. Run AutoCrop.ijm on your images
2. Move all cropped images into one folder
3. Run AutoRename.py on all cropped images
4. Run AutoMeasure.ijm on all the renamed, cropped images
5. Save Results table as CSV-file, e.g. in auto_imager_analysis/data

In R:
6. Run calculate_forces.R and process your results file