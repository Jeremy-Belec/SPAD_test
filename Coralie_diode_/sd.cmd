#setdep @node|sde@

File {
*-Input		
	Grid = "n1_msh.tdr"
	Parameter= "models.par"
*-Output	
	Current=   "p1e17_n1e17_des.plt"
	Plot=      "p1e17_n1e17_des.tdr"
	Output=    "p1e17_n1e17_des.log"
}



Electrode {
	{ Name= "n_contact"  Voltage= 0 }
	{ Name= "p_contact"  Voltage= 0 }


}


RayTraceBC {
		{ Name= "p_contact"
			Reflectivity= 0
			Transmittivity = 1
		}
		{ Name= "n_contact"
			Reflectivity= 0.5
			Transmittivity = 0.5
		}		
	}

Physics ( region="Oxide_layer" ) { Optics ( -OpticalGeneration ) }
Physics ( region="Si_layer" ) { Optics ( -OpticalGeneration ) }
Physics ( region="P_cont_layer" ) { Optics ( -OpticalGeneration ) }
Physics ( region="N_cont_layer" ) { Optics ( -OpticalGeneration ) }
Physics (MaterialInterface = "Oxide/Silicon"){
   GateCurrent(DirectTunneling GateName="top")
}
Physics	{		
	Temperature= 273
	Fermi
	RecGenHeat
	HeteroInterfaces
	Mobility(HighFieldSaturation DopingDependance Enormal)
	EffectiveIntrinsicDensity(BandGapNarrowing(OldSlotboom)) 
	Recombination(
		*Radiative
		SRH(Tunneling) 
		*Auger
		Avalanche(ElectricField)
	)	
	
	
}	

Plot {    
*- Doping and mole fraction profiles	
	*Doping DonorConcentration AcceptorConcentration	
	*xMoleFraction
*- Band structure
	*BandGap BandGapNarrowing ElectronAffinity
	ConductionBandEnergy ValenceBandEnergy
	eQuasiFermiEnergy hQuasiFermiEnergy		
*- Carrier Densities:
  	*eDensity hDensity
	*EffectiveIntrinsicDensity IntrinsicDensity
	*eEquilibriumDensity hEquilibriumDensity
*- Fields, Potentials and Charge distributions
	ElectricField/Vector
	*Potential
	*SpaceCharge	
*- Currents	
	*Current/Vector eCurrent/Vector  hCurrent/Vector
  	*CurrentPotential	* visualizing current lines
  	*eMobility hMobility
	*eVelocity hVelocity
*- Generation/Recombination	
  	*srhRecombination AugerRecombination TotalRecombination SurfaceRecombination Band2Band RadiativeRecombination
  	*eLifeTime hLifeTime

*- Optical Generation	
    *ComplexRefractiveIndex QuantumYield
	*OpticalIntensity AbsorbedPhotonDensity OpticalGeneration
* Visualizing raytracing. Can be time consuming to plot.  
* RayTree cannot be  plotted CompactMemoryOption is specified in Physics section. 	
*RayTrees

}	

Math {	ExcludeTouchingContactParts
	Derivatives
  	Avalderivatives
	AvalPostProcessing
	Extrapolate
	RelErrcontrol
	Digits= 5
	Notdamped= 20
	Iterations= 100
	ElementEdgeCurrent
	eMobilityAveraging=ElementEdge       
	hMobilityAveraging=ElementEdge       
	ParallelToInterfaceInBoundaryLayer(-ExternalBoundary)
	-ExitOnUnknownParameterRegion
  	Transient=BE
	RefDens_eGradQuasiFermi_ElectricField_HFS= 1e7
	RefDens_hGradQuasiFermi_ElectricField_HFS= 1e7
	ErrRef(electron)= 1e9
	ErrRef(hole)= 1e9
	ExtendedPrecision
	CNormPrint			   
}

Solve {
	NewCurrentPrefix= "tmp_"
	Optics
	Poisson
	NewCurrentPrefix= ""
	Coupled (Iterations= 20){ Poisson Electron Hole }	
  	Plot (FilePrefix= "n@node@_photo")

			
	*ramp voltage at anode from 0V to -40 V	
	Quasistationary ( 
		InitialStep= 1e-3 Increment= 1.41 Decrement= 2
		MinStep= 1e-8     MaxStep= 0.001	
		Goal { Name="n_contact" Voltage= 3}
	){ Coupled { Poisson Electron Hole } }


}
