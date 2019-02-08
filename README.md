# Fault Detection with LTL Example: UAV Consensus
This repo contains the files necessary to reproduce the polt in paper under review titiled: Fault Detectability Analysis of Switched Ane
Systems with Linear Temporal Logic Constraints

# Requirements
- Matlab (2016b or newer recommended)
- Yalmip is required for MILP formulation, tested version R20180612.
- gurobi, tested with version gurobi751.

# usage
- ```sim_consensus_healthy.m``` simulates the consensus UAV swarm with unbroken comunication networks (Fig. 3 in the paper, to plot of the right half side). 

- ```detection_sim_consensus_faulty.m``` simulates the consensus UAV swarm with unbroken comunication networks. 

- ```detectability_analysis_consensus.m```




