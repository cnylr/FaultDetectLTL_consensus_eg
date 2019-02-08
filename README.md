# Fault Detection with LTL Example: UAV Consensus
This repo contains the files necessary to reproduce the polt in paper under review titiled: Fault Detectability Analysis of Switched Affine
Systems with Linear Temporal Logic Constraints

# Requirements
- Matlab (2016b or newer recommended)
- Yalmip is required for MILP formulation, tested version R20180612.
- gurobi, tested with version gurobi751.

# usage
- ```detectability_analysis_consensus.m```

  - MILP-based detectability analysis of the considered UAV swarm system with fault (broken communication networks). 

  - The NFA associated with the considered LTL constraints are encoded with mixed integer linear constraints by hand (not automated). 

  - Note that the 

- ```sim_consensus_healthy.m``` 

   - simulates the UAV swarm system with unbroken comunication networks (Fig. 3 in the paper, top plot of the right half side). 

- ```detection_sim_consensus_faulty.m``` 

   - simulates the UAV swarm system with faults, i.e., with broken comunication networks (Fig. 3, middle plot of the right half side). 
The fault occurrence time is set at To = 8. The fault detection is done every 1/15 time step (i.e., fine resolution detection)
The fault detection time can be read from the simulation result by finding the first time instant that the detection LP being infeasible. 






