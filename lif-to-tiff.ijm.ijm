// This macro batch converts .lif files in a folder to .tiff
// It preserves spatial scaling and metadata automatically.

run("Bio-Formats Macro Extensions"); 
setBatchMode(true); // Runs in the background to save time

input = getDirectory("folder location containing .lif files");
output = getDirectory("destination folder to store .tiff");

list = getFileList(input);

for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".lif")) {
        processFile(input, output, list[i]);
    }
}
setBatchMode(false);
print("I have completed converting all .lif files to .tiff");

function processFile(input, output, file) {
    path = input + file;
    Ext.setId(path);
    Ext.getSeriesCount(seriesCount); // .lif files often contain many image series
    
    for (s = 0; s < seriesCount; s++) {
        // Open each series individually
        run("Bio-Formats Importer", "open=[" + path + "] color_mode=Default view=[Standard ImageJ] stack_order=XYZCT series_" + (s+1));
        
        title = getTitle();
         // --- FIX: CLEAN THE FILENAME ---
        // Remove spaces and slashes which cause IOErrors
        cleanTitle = replace(title, " ", "_");
        cleanTitle = replace(cleanTitle, "/", "-"); 
        
        saveAs("Tiff", output + cleanTitle + ".tif");
        close();
    }
}


