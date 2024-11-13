# Knee-osteoarthrosis tele-rehabilitation system

## Table of contents:

- [Introduction](#introduction)
- [Overview](#Overview)
- [System features](#Sytemfeatures)
- [Project Structure](#project-structure)
- [Team](#team)

### Introduction
Knee osteoarthritis (KOA) is a common degenerative joint disease. Rehabilitation progression is dependent on disease severity. This study uses gait kinematics and kinetics related features as well as frequency domain features to detect the degree of KOA severity using low cost IMUs (MPU6050) system. Then, an exercise protocol is recommended accordingly
This system was develpoed as a gradution project at the Department of Systems & Biomedical Engineering, Cairo University.
### Overview
The system consist of 3 primary modules :
1. Hardware
2. Artificial intelligence
3. Mobile apllication
### System features
- Hardware module:
  - This module aims at measuring gait kinematic and kinetics related features.
  - Composed of imu Sensors to capture knee movement.
  - ESP microcontrollers for data transimission.
  - Hardware housing
- System  Verification :
  - The system was validated against the IMU suit and FAB Recorder Software by calculating RMSE between knee angles measured by the two systems during the time up and go task (TUG).
- Data and features:
  -Data collection:
    - A total number of 23 participants enrolled in data collection (18 patients with KOA and 5 controls).
  - Data Processing and feature extraction:
    - A second order law pass filter wa apllied.
    - Time domain features extracted
    - Frequency domain features extracted.
- Machine learning:
  - Severity classification by analyzing womaac score.
  - Features selection
  - Severity prediction Models
- Mobile application:
  - Patient Registration
  - Hardware Instruction Calibration
  - Statistical Analysis
  - Severity Prediction
  - Personalized Exercise Recommendations
  - Database Integration
### Project Structure
- Hardware Module built using:
  - C and arduin ide
  - Fusion 360 for housing design
- Data and machine learning model:
  -Python
  - Pandas
  - numpy
  - Scikit-learn
  - Tensor flow
- Mobile application:
  - Flutter
  
| Team Members' Names                                  | 
| ---------------------------------------------------- |
| Rahma Abdelkader      | 
| Sama Mostafa      |
|Misara Ahmed     |
| Yousef Essam       |           
| Yousr Ashraf        |   

### Suprivised by:
DR, Alyaa Rehan
    
