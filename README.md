# AugmentedRealityProject
This is a pilot study using augmented reality goggles to simulate monocular suppression while watching a movie. It omits any identifiable datasets 
The pilot study was terminated in March of 2020 due to COVID and was adapted to a remote study
The code that manipulated the goggles was written in MATLAB
All statistical analyses of participants data was conducted in R 

# Interocular Suppression Increases Over Five Days’ Exposure to Incompatible Natural Images![image](https://user-images.githubusercontent.com/52045042/152890537-d21050c0-aa2c-4950-bc5f-1dda66eba640.png)

**Project Status: Early-termination**

## Table of Contents
- [Project Objective](##Project-Objective)
- [Methods Used](##Methods-Used)
- [Technologies Used](##Technologies-Used)

## Project Objective
- When information reaching the two eyes is incompatible, observers may experience double vision. Alternatively, information from one eye may be suppressed, allowing an easier, single interpretation of the scene. Can experience increase the amount of such suppression in natural images? To answer this question, we exposed participants to incongruent video images over 5 days and measured suppression each day. Participants watched grayscale natural videos (movies and TV shows) made incompatible by left-right flipping the video images presented to one of the eyes. To increase the likelihood of perceptual suppression, the flipped video was moderately blurred (Gaussian, sd=0.27deg). Participants viewed the videos for 120 min each day for five consecutive days. 
To measure suppression during video watching, participants were asked to detect a circular (17 deg), brief contrast decrement (temporal Gaussian, sd = 233ms) in the video images. Decrements were presented at random intervals (every 10-15 sec). Independent staircases adjusted the size of the contrast decrement to measure a detection threshold in each eye. If the visual system is suppressing one eye, that eye’s decrement should be harder to detect. Hence, we calculated a suppression index by taking the difference between the two eyes’ thresholds. We then measured changes in suppression by estimating the slope of a line fit to the index across days. Finally, we estimated the reliability of these changes with a bootstrapping procedure. All participants suppressed the blurry eye, as it required larger contrast decrements for detection even on the first day. For three participants, suppression reliably increased across days, with their suppression index rising by about 0.13 over the 5 days (average across subjects). A fourth participant showed a small but reliable decrease in suppression (of 0.03 across the 5 days). We conclude that interocular suppression in adult observers can increase with experience.


## Methods Used
- Visual Stimuli Presentation
- Augmented Reality 
- Data Visualization
- Linear Regression
- Bootstrapping
- Staircase method of adjustment

## Technologies Used
- MATLAB 
- PsychToolBox
- R 

