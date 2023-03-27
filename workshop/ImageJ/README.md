---
title: Analyzing fluorescence microscopy images with ImageJ
author: Bin He
date: 2020-04-15
---

# PREPARATION
## Reference & Credit
This workshop is entirely based on <https://petebankhead.gitbooks.io/imagej-intro/content/>. This markdown file provides miscellaneous notes I made while working through the tutorial. You should follow the original and only use this file as a troubleshooting guide.

## Set up your computer
You need the ImageJ software and the data associated with this tutorial. You don't have to use the [FastX](fastx.divms.uiowa.edu) environment, although it does have ImageJ pre-installed. To work on your own computer, simply [download](https://imagej.net/Fiji/Downloads) and install FIJI (FIJI Is Just ImageJ), which is built on top of ImageJ to provide many plugins for biological image analysis.

- Download Fiji, install and get familiar with its graphic user interface.
- Create a folder on your computer, e.g. `~/Documents/ImageJ-workshop`, and [download the data](https://github.com/petebankhead/imagej-intro/raw/master/practicals/Analyzing_fluorescence_images_data.zip) for this workshop. Unzip the downloaded file into the folder you just created.

- tip: ImageJ has very limited "undo" functions.

# Part I - INTRODUCING IMAGES, IMAGEJ & FIJI
## Images & Pixels
- What is a "pixel"?
- What's the difference between "data" and "display"? Why?
- Why images that _look the same_ can contain _different_ pixel values, while images that _look different_ can contain _the same_ pixel values?
    - Look at Figure 3 -- use the pixel intensity distribution to pick out "which two figures are identical".
- If you want to tell whether two images are identical, is comparing their histograms always a reliable method?

### Mapping colors to pixels
- What is a "Look-Up Table"?
- Why use different LUTs?
- How to adjust the display range in ImageJ?
    - Do the "Practical" exercise with the `spooked.tif` image. What "hidden" image did you see?
    - What's your understanding of "the 'best' contrast setting really depends upon what it is you want to see"
- Understand how scientific image analysis is NOT photo editing.
    - be wary that if you edit your scientific images in your favorite photo editing app, even professional ones like Photoshop, you could have changed the raw data and therefore inadvertently "manipulated" your data.

### Properties and pixel size
> This chapter ends with the other important characteristic of pixels for analysis: their size, and therefore how measuring or counting them might be related back to identifying the sizes and positions of things in real life. Sizes also need to be correct for much analysis to be meaningful.
- What is pixel size and why it is always important to check the "properties..." of your image?

## Dimensions
- Dimensions: the number of dimensions is the number of pieces of information you need to know to identify individual pixels.
    - what does this mean?
- What are stacks and hyperstacks?
- **Exercise**: correcting dimensions
    - Open `lost_dimensions.tif` in Fiji/ImageJ. Identify the correct dimensions so it displays properly. What's your conclusion?
- Presenting dimensions
    - Make sure you try the "orthogonal views" and the "3D viewer"
- Z-projections
    - what is z-projection and what use does it have?
    - try "Z-project" on the "lost_dimensions.tif", which you have corrected its dimensions before
    - think through the question on how different projection methods (sum/max/min) performs under the two conditions, namely the image contains 4 additional, out-of-focus slices or there are several very bright, isolated, randomly distributed outlier pixels
    - what problem might there be if you use projections to determine the distance between two features?

## Types & bit-depths
- What is "bit-depths" and how does it affect what pixel values can be?
- What range of values does an 8-bit image have?
- How about 16-bit?
- Answer the question about the possible types of the images
    - -5:
    - 140:
    - -3.5
- What do "clipping" and "rounding" mean in the context of images?
- Clipping can occur both during image processing and image acquisition. How?
- When acquiring an 8-bit unsigned integer image, is it fair to say your data is fine so long as you do not store pixel values \< 0 or \> 255?
- How does the bit-depths of the camera (detector) and the types of the image (e.g. 8-bit, 16-bit) together determine the possible pixel value ranges?

## Channels & colors
- Understand that channels can be used to store the intensity at each pixel for different colors, if the colors are "intrinsic", such as two different fluorescent labels in the cell.
- Understand the different approaches taken by "composite images" vs RGB images to encode color
- **Exercise** open the "Fluorescent Cells" file from `open sample images` menu, then use the `image/color/channel-tools...` to play with different ways to look at individual colors. You can either change the "composite" to "color", which will only show one color at a time, or you can keep the top dropdown menu in "composite", and tick or untick the individual color channels.
    - how does the "more..." option in the "channel-tools" affect the display of the image? Recall that the color displayed is determined by the Look-Up Table (LUT), while the file itself only stores the intensity value at each pixel for each channel (thus you can make the red channel look purple or even rainbow!)
- What is the main benefit of using RGB format? And what is the downside?
- **Exercise**: open both `Cell_composite.tif` and `Cell_RGB.tif` from the dataset you downloaded and unzipped. use the `Image/Color/Split channels` on both images and observe the output. Why are they different?
- Understand that our monitors almost always work with RGB.
- Understand that there are other "color spaces", such as CMYK -- printers usually work with this color space -- if you have replaced toner cartridges in a color printer, you may have noticed that the cartridges are black, cyan, yellow and blue.

## File & file formats
- Understand that you should always keep the originally acquired files -- and refer to the original acquisition software to confirm the metadata.
- Know that the LOCI Bioformats plugin (installed by default in Fiji) is a powerful tool to extract the metadata, (sometimes it has to guess the file format, and thus mistakes can be made)
- Understand the two main ways of image compression.
    - be suspitious and cautious when you see an image whose size is too small to be true -- perhaps it has been compresses with Lossy algorithm, leading to irreversible loss of information.
    - **If in doubt, avoid compression -- and really avoid JPEG for fluorescence microscopy**
- What's the difference between "bitmaps" and "vector images"?
- If you are up to the challenge, try to do the `Besenfreunde.ids` practice. Quite fun!

# Part II - PROCESSING FUNDAMENTALS
- Image analysis usually consists of three stages, what are they and what do they mean?
    - what is "image pre-processing"? What are some examples?
    - what does "detection" mean? what are some examples?
    - what is an example of "measurement" in image analysis?
## Measurements & regions of interest (ROI)
- What might we want to measure? Number of features (e.g. cells or dots), intensity of features (how fluorescent is a cell), size of a feature (cell size) and distance between features (how far apart are two types of cells).
    - Note that we are only measuring pixels. The displayed size, volume, distance in absolute units are a result of conversion based on the pixel size of the picture. So, **make sure to check your images' properties before taking measurements.**
- Usually we want to measure something _within a particular region_ of an image and not the _whole thing_. Regions Of Interests (ROIs) can be used to define specific parts of an image.
    - you can draw shapes using the tool buttons on the app main panel.
    - tip: holding shift or control before releasing the mouse button will join the current shape with existing shapes.
    - use ROI managers to store, recall, combine ROIs.
- (Optional) Overlay
    - this can be used to annotate your image (arrows, text boxes, shapes etc.) but are not used for measurements
    - overlay is stored as a separate "layer" (borrowing the concept from Photoshop)
    - overlay shapes are created the same way as ROIs. to turn a shape into an overlay, press B or use "Images/Overlay/Add selection"
    - once added to overlay, the shape will appear to be "burned into the image", that is, you cannot manipulate it any more. However, you can "add overlay to ROI manager" and reactive the shape by selecting it in the ROI manager.
    - one can "flatten" the overlay by selecting that option in the ROI manager. this will actually merge the overlay shapes into the original image (altering the pixel values).
    - overlays that are not flattened ARE saved in the tif image, but such information is unlikely to be read correctly by other softwares.
## (Optional) Manipulating individual pixels
_Important points_

- point operations are mathematical operations applied to individual pixel values
- they can be applied using a single image, an image and a constant or two images **of the same size**
- some image operations improve image appearances by changing the relationships between pixel values

_Questions_

- What does manipulating individual pixels mean?

### Arithmatic
add, subtract, multiply, divide -- try these on an example image

### Image inversion
- be aware that inversion doesn't work the same way for 8-bit, 16-bit and 32-bit images!

### Nonlinear contrast enhancement
- All arithmatic operations are _linear_. Here we are going to deal with non-linear point operations.
- Nonlinear point operations are useful for displaying images with _high dynamic ranges_, that is, a large difference between the largest and the smallest pixel values.
- Can be achieved with the `Gamma...` or `Log...` commands within the `Process/Math` submenu.
- **Avoiding manipulation (important!)**
    > When creating figures for publication, changing the contrast in some linear manner – i.e. just by scaling using the `Brightness/Contrast...` – is normally considered fine (assuming that it has not been done mischievously to make some inconvenient, research-undermining details impossible to discern). _But if any nonlinear operations are used, these should always be noted in the figure legend!_ This is because, although nonlinear operations can be very helpful when used with care, they can also easily mislead – exaggerating or underplaying differences in brightness.

### Point operatiosn involving multiple images
- Two images _of the same size_ can be added, subtracted from one another, multiplied or divided. What happens under the hood is just a simple arithmatic operation applied to each pair of pixel values in the same position within the two images.
- Achieved using the `Process/Image calculator...` menu.
- Try the Practical challenge for identifying the image that is different from the other two


## Detection by thresholding
Often times the objective of our analysis is to measure the number and intensities of certain features, such as cells, colonies or some bright spots (corresponding to some molecules). The process of identifying these features _programmatically_ from the background is the topic of this section. Sometimes you will read the term "segmentation", as in "segment the cells from the image".

The basic idea of segmenting an image typically consists of pre-processing and thresholding. The former includes steps such as background subtraction and noise reduction. This is then followed by thresholding, a process in which a binary (0 or 1) image is created by comparing the value of each pixel with a threshold (same or changing based on the position in the image) and setting the new value to 0 or 1. The features can then be "labeled" so that they can be referred to individually.

    A word of caution about binary images in ImageJ: while it is intuitive to encode a binary image as a 1-bit image (since only one bit of information is required to store 0/1), it actually uses an 8-bit type, although it only uses 0 and 255. Making things more complex, ImageJ allows either 0 or 255 to represent the background. This is set in the `Process/Binary/Options...` menu. On top of it, one can have an "inverted LUT" that can make the display of the image different from the underlying values.

### Global thresholding
- Global thresholding refers to the application of a single threshold across the entire image.
- The alternative is local thresholding, where a threshold is chosen based on some local characteristics, e.g. different background noise in parts of the image.
- Thresholding can be implemented using the `Image/Adjust/Threshold...` command. When using this command, the same threshold are applied to every pixel in the image, hence _global thresholding_. In fact, you may have realized that thresholding is really a simple point operation, where the pixel value is compared to a constant, and the return value is 1 is the value exceeds the constant, 0 if it doesn't.
- Manually choosing the threshold is cubersome for large amounts of images and hinders reproducibility (how can you convey your subjective criteria for setting the threshold?). To overcome this problem, ImageJ offers several "auto-thresholding" method, i.e. these methods are programmatic and doesn't require the user's input. Access it with the menu `Image/Adjust/Auto Threshold`
- Determining thresholds from histograms
    The rationale for this approach is that during thresholding, one implicitly assumes that there are two classes of pixel in an image -- those that belong to interesting objects and those that do not -- and pixel values in each class have different intensity values. A histogram captures the distribution of the intensity values, regardless of their positions in an image. Thus, it can be used to determine the intensity threshold.

### Local thresholding
A common problem is that structures that should be detected appear on top of a background that itself varies in brightness. For example, in the red channel of `Hela cells` (`File/Open sample image`), there is no single global threshold capable of identifying and separating all the "spot-like" structures; any choice will miss many of the spots because a threshold high enough to avoid the background will also be too high to catch all the spots occurring in the darker regions.

## Filters
### Practice: count objects in "Hela-cells.tif"
1. Open the sample image "Hela cells"
1. Use "duplicate" to make a replicate of just channel 1 (slice 1), which is lysosomes represented in red. You can change the LUT to grey, but that is optional -- it doesn't change the underlying pixel values, just make it easier for you to pick out the spots.
1. We will first take the median filter approach. Make a duplicate of the replicate you just made, so now we have two identical copies of channel 1 open.
1. Make one of the two your focal image, then use "Process/filter/median filter ..." with a radius of 15. Other values would work, too. If you check the "preview" checkbox, you should aim at reproducing the background without showing any of the feature you want to count (we will subtract this background from the other copy soon).
1. Once you are happy about the background, choose apply.
1. Now you can subtract the background from the original. Use "Process/image calculator..." to do so. Select "create a new image". The other checkbox is optional (32-bit) -- with the default 8-bit, anywhere the subtracted value is negative will be clipped to 0.
1. Now the background should be much more homogeneous across the image.
1. The next few steps are more art than science. Play with "Process/binary/open, watershed" to see if you can make the features distinct and disconnected.
1. To actually isolate features, one strategy is to use "Edit/selection/create selection" and "Edit/selection/add selection to ROI manager". This will create a SINGLE ROI, which you can break it up by using "more/split" in the ROI manager.
1. If you want to see how well you did, you can select the original, unsubtracted image, and then switch to the ROI manager -- even though it looks like the "show all" checkbox is checked, click it again, you will get all the outlines superimposed on the image. You can now zoom in to see how well you have done.
1. If you are curious to explore the second approach, read about "analyze particles..." function in FIJI.

## Binary images & operations
- despite our best effort in filtering and thesholding, the resulting binary images often still contain inaccurate or undesirable regions.
- morphological operations can be used to refine or modify binary images. the commands are found in the `Process/Binary` menu
### Erosion and dilations
_erosion_ and _dilation_ are actually identical to minimum and maximum filtering respectively. These two names are used more often when speaking of binary images, but the operations are the same irrespective of the kind of image. In practice, these two operations are useful for separating or merging features.

### Opening and closeing
The fact that erosion and dilation alone affect sizes can be a problem. Combining both operations helps achieve this:

- _Opening_ consists of an erosion followed by a dilation. The effect is that, if erosion causes very small objects to completely disappear, clearly the dilation cannot make them reappear, hence the barely-connected objected could be separated by erosion and not reconnected by the dilation step.
- _Closing_ is the opposite of opening, and has the effect of merging nearby features.
- The `Erode`, `Dilate`, `Open` and `Close` commands uses a 3 x 3 neighborhood. To perform the operations with larger neighborhoods, one needs to use the `Maximum...` and `Minimum...` filters in combination.

### Outlines, Holes and Maximum

### Image transforms
An image transform converts an image into some other form, in which the pixel values can have a (sometimes very) different interpretation. Several transforms are relevant to refining image segmentation.

- The distance transform 
    replaces each pixel value with the distance to the nearest background pixel

