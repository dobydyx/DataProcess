# DataProcess_Main

## Version: 1.0
## Author: dyxdoby

This program is a MATLAB script designed to process and analyze five-phase current data. It reads data from a CSV file, plots the current waveforms, performs FFT analysis, and re-plots the FFT results. The script is designed to be used for data analysis in electrical engineering and related fields.

## License
This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

## Usage
1. **Data Acquisition**: The script reads a CSV file containing waveform data. The CSV file should be located in the `.\Demo\` directory and named `Tek000_ALL.csv`. The script adjusts the time base of the oscilloscope to 0 and extracts the columns of phase current data.

2. **Setting and Plotting Current Waveforms**: The script sets the start and end time for drawing the waveform and plots the five-phase current with annotation.

3. **FFT Analysis**: The script performs FFT analysis on the phase currents. The start and end time of the data to be analyzed by FFT can be set within the time range of the oscilloscope. The script calculates the FFT for phase currents and saves the analyzed data as a CSV file.

4. **Re-plotting FFT Data**: The script re-plots the FFT analysis results for clearer visualization.

5. **Printing the Drawn Image**: The script prints the drawn image and saves it as a TIFF file in the `.\Demo\` directory.

## Dependencies
This script requires MATLAB to run. It uses the following MATLAB functions: `csvread`, `floor`, `Plot_FivephaseCurrent`, `Add_Annotation_toPhasecurrent`, `PhaseCurrentFFT`, `RepoltFFT`, and `print`.

## Installation
To use this script, download it and place it in your MATLAB working directory. Ensure that your CSV data file is in the correct location (`.\Demo\Tek000_ALL.csv`).

## Running the Script
To run the script, open it in MATLAB and press the Run button, or type `DataProcess_Main` in the MATLAB command window.

## Contributing
Contributions are welcome. Please fork the repository and create a pull request with your changes.

## Contact
For any questions or concerns, please contact the author at dyxdoby@outlook.com.

## Acknowledgements
Thanks to all contributors and users of this script. Your feedback and suggestions are greatly appreciated.
