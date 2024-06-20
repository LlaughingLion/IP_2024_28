# IP_2024_28

This repository contains all the code used by group 28 (Liam Ligthart and Coen Mingelen) for the course SC42035 - Integration Project Systems and Control.

Every designed controller has its own Simulink and workspace initialization file. The idea is to run the workspace initialization file (name ending in _init) before starting the Simulink simulation.

## LQR controller

Initialization file: `3 - LQR/LQR_init.m`

Simulink file: `3 - LQR/LQR_controller.slx`


## MPC controller

Initialization file: `4 - MPC/mpc_init.m`

Simulink file: `4 - MPC/MPC_controller.slx`


## Nonlinear MPC controller

Initialization file: `7 - Non-Linear Model/nonlinear_mpc_init.m`

Simulink file: `7 - Non-Linear Model/NL_MPC_controller.slx`


## Swingup MPC controller

Initialization file: `8 - Swing-up/swingup_mpc_init.m`

Simulink file: `8 - Swing-up/swingup_MPC_controller.slx`


## Datafiles

The data for the system identification can be found under:

`0 - Data/cut_data_cal/` (data for simple pendulum and flywheel test)

`0 - Data/sysid_data_cal/` (data for full greybox estimation)


The data for the controller plots can be found under:

`0 - Data/control_data/` (LQR and MPC)

`0 - Data/NLMPC/` (Nonlinear MPC)

`0 - Data/Swingup/` (Swingup MPC)