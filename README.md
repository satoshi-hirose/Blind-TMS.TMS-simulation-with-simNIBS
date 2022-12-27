# Blind-TMS-simulation-w-simNIBS
These codes perform TMS simulation analysis 
reported in Supplementary Material in Ikegami et al., 2023.

We simulated the two trials for TMS stimulation to 2.5cm above the Inion (putative V1/V2).
This set of codes can replicate our simulation.
For detail of the experiment, please see the Supplementary Material of Ikegami et al., 2023.


To replicate the analysis, 
(Tested Environment OS: MacOS, MATLAB: r2018b)
1, Prepare the dataset in "Rawdata" directory and codes in "Script" directory as follows.

Note: If you have .nii or .nii.gz rawdata files, or will use T2w images,
      modify the corresponding line (around Line 13) in headreco_script.sh.

   (experimental directory) --- Script  --- headreco_script.sh
                             |           |- mother_script.m
                             |           |- group_analysis.m
                             |           |- extract_simNIBS_results.m
                             |           |- get_TMS_pos.m
                             |
                             |- Rawdata ---(subject1 ID) --- T1.hdr
                                        |                 |- T1.img
                                         |
                                         |-(subject2 ID) --- T1.hdr
                                         |                |- T1.img
                                         |
                                         |-(subject3 ID) --- T1.hdr
                                                          |- T1.img
                                                  .
                                                  .
                                                  .

2, Install simNIBS (https://simnibs.github.io/simnibs/build/html/installation/simnibs_installer.html) 
   Add the SimNIBS MATLAB directory to the MATLAB path (e.g. addpath ~/Applications/SimNIBS-3.2/matlab/)

3, Go to the Script directory and run shell script "headreco_script.sh" in Terminal
(~2 hours /participant with iMacPro 3Gz 10 Core Intel Processor, 64 GB 2666MHz Memory)
Note: headreco_script.sh do headreco all for all the data in Rawdata directory. If you want to specify the subject to be analyzed, explicitly define it in the script (Lines 4 - 9)

4. Edit the parameters for the simulation listed in "mother_script.m" (Around Lines between 6-30)

5, run "mother_script.m"
Note: "run_simnibs" takes ~5 min./participant (for two simulations/participant)
Note: "extract_simNIBS_results" combines the results from all participants and makes a large .mat file (~560MB with 15 participants with 2 simulations)

6, Check whether the simulation for each participant is completed without error, and then run "group_analysis.m"
