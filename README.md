# Trace Analysis Ini Files - Instructions and guidelines

## First Stage

In the first stage of cleaning the idea is to clean up the data so we can keep only the best measured values (data points) for each sensor. No interpolation is done at this stage so any removed points will not be gap-filled. If the researcher is looking for the best measurements from a particular sensor, this is the data that they want.

The first stage cleaning provides the following features:

1. Selects traces that are needed for future data analysis. Not all the measured variables from a site need to be here - only the ones that will be used in future analysis or that’s needed to improve cleaning.
2. File names from the database can be renamed here. The trace name does not have to be the same as the file name from the database.
3. The original values can be altered (calibrations can be applied, units can be changed).
4. Basic filtering can be done: 
  * Values can be removed if they exceed minMax thresholds. 
  * Values can be clamped to the thresholds if they exceed clampedMinMax values. 
7. This stage creates dependencies between different traces. If one trace gets some points removed here, all its dependent traces will have those points removed too. 

Introduction:
All traces must be enclosed in [Trace] and [End] blocks.
All assignments can be on multiple lines, but should be enclosed in single quotes.
Comments must begin with a percentage sign,%.
The partial path must be included with the inputFileName, when you locate the raw data trace in the database. (Using biomet_path only returns the path: 'year/site/measType/')
Necessary fields are: variableName, inputFileName, measurementType, units, title, and minMax.
All fields must be in Matlab format
All assignments must be to strings in single quotes, or numeric expressions (ex: threshold_const = 6, threshold_const = [6],variableName = 'Some Name')	

<img src="images/Screen Shot 2022-10-21 at 4.25.36 PM.png">

Grayed out parameters are legacy properties that should not be used in the new ini files. They can be left in or removed from the old ones.

### Properties

| Field      | Description |
| ----------- | ----------- |
| Header/Comments      | “%” character indicates the beginning of a comment. Program will not process any characters that follow “%”. Use comments to add information and to better document the site. Each line of the ini file can be followed by a comment. Comments were removed from the above example to improve readability of this document. Refer to the example ini file at the end of this document. (link here FirstStage.ini file from DSM site)       |
| Site_name   | Name of the site. Any text can go here.        |
| SiteID      | This is the name attributed to the site in the database (e.g., DSM or BB1). |
| Difference_GMT_to_local_time | Time difference between GMT time, that database is kept in, and the standard time at the site location (for PST this is +8). |
|[Trace] | Marks the beginning of a new variable. The section has to end with the keyword <[END]>.|
| variableName | Name of variable for first stage. The variable with this name created here will show up in the sub-folder “Clean” under the same folder where the original database file came from. In the Micromet Lab, these should follow the AmeriFlux naming convention. |
| title | Descriptive title for plots/visualization.|
| originalVariable| This is an example of adding an optional field to a trace that can be used by an advanced user. Here it’s set to be the same as the variableName. Currently, this particular field is not used for generic processing. |
|inputFileName |{‘file name’} - The name of the database file that contains data for this trace. The brackets are mandatory.<br /> The file name can include folder(s): ‘Met/Tair’. The folder paths are relative to the main site path (‘./database/yyyy/siteID’) so the above example translates into this path:   ‘./database/yyyy/siteID/Met/Tair’<br />Over the lifetime of a site, the data logger programs sometimes change and a sensor measurement that was assigned to a variable may change. To allow for different variable names over the site history the inputFileName can be given as: {‘fileName1’,’fileName2’}. In that case the parameter inputFileName_dates also needs to be present in the [Trace]...[END] structure.<br /> Advanced: If there is a need to load up a data file from another site, the path can be constructed in this way: ‘../../siteID2/dataFolder’. The ‘../../’ moves the path pointer up to ‘/database/yyyy’ and from there ‘siteID2/dataFolder’ takes the program to that folder.|
|inputFileName_dates |[ datenum_start1 datenum_end1; datenum_start2 datenum_end2] - starts and ends of data periods for each of the inputFileNames. <br />If there are multiple inputFileNames ( {‘fileName1’, ‘fileName2} ) then the program needs to know the time periods where the data assigned to the variableName should come from ‘fileName1’ and when from ‘fileName2’. In that case, this field is mandatory.<br /> If inputFileName contains only one file name, this parameter is optional. It is still a good practice to use it anyway.<br /> The last ‘datenum_end’ is usually set far into the future: datenum(2999,1,1).|
|||
|||


