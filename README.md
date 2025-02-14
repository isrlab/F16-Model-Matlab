# F16-Model-Matlab
This is a Matlab/Simulink implementation of a full nonlinear F16 aircraft model. The aerodynamics included in this model come from the NASA Technical Report 1538, Simulator Study of Stall/Post-Stall Characteristics of a Fighter Airplane with Relaxed Longitudinal Static Stability, by Nguyen, Ogburn, Gilbert, Kibler, Brown, and Deal, Dec 1979. 

The model is based on Aircraft Control and Simulations, by Brian Stevens and Frank Lewis, Wiley Inter-Science, New York, 1992. 

This is a revised implementation of the older implementation available at  [MATLAB/Simulink package](https://dept.aem.umn.edu/~balas/darpa_sec/SEC.Software.html).


## Trim and Linearization
* Please see trim_and_linearize.m
* Trim and linearization is done using [Simulink's Control System Design and Analysis Apps](https://www.mathworks.com/products/simcontrol.html). The script file Trim16.m, exported by Simulink, is for steady-level flight. This is called by trim_and_linearize.m.


