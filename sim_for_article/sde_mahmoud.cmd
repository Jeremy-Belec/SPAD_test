
#setdep @node|sde@

File {
*-Input		
	Grid = "n1_msh.tdr"
	Parameter= "models.par"
*-Output	
	Current=   "x_y_flipped_des.plt"
	Plot=      "x_y_flipped_des.tdr"
	Output=    "x_y_flipped_des.log"
}



Electrode {
	{ Name= "n_contact_left"  Voltage= 0 }
	{ Name= "n_contact_right"  Voltage= 0 }
	{ Name= "p_contact_center"  Voltage= 0 }
	*{ Name= "g_contact"  Voltage= 0 }
}


RayTraceBC {
		{ Name= "n_contact_left"
			Reflectivity= 0
			Transmittivity = 1
		}
		{ Name= "n_contact_right"
			Reflectivity= 0
			Transmittivity = 1
		}
		{ Name= "p_contact_center"
			Reflectivity= 0.5
			Transmittivity = 0.5
		}		
	}

Physics ( region="n_contact" ) { Optics ( -OpticalGeneration ) }
Physics ( region="Si_layer" ) { Optics ( -OpticalGeneration ) }
Physics ( region="P_cont_layer_left" ) { Optics ( -OpticalGeneration ) }
Physics ( region="P_cont_layer_right" ) { Optics ( -OpticalGeneration ) }

Physics	{		
	Temperature= 273
	Fermi
	RecGenHeat
	HeteroInterfaces
	Mobility(HighFieldSaturation DopingDependance Enormal)
	EffectiveIntrinsicDensity(BandGapNarrowing(OldSlotboom)) 
	Recombination(
		*Radiative
		*SRH(Tunneling)
		SRH( DopingDep )
		*Auger
		Band2Band(E2)
		Avalanche( Eparallel )
	)	
	
	
}	

Plot {    
*- Doping and mole fraction profiles	
	Doping DonorConcentration AcceptorConcentration	
	*xMoleFraction
*- Band structure
	*BandGap BandGapNarrowing ElectronAffinity
	ConductionBandEnergy ValenceBandEnergy
	eQuasiFermiEnergy hQuasiFermiEnergy
	eGradQuasiFermi/Vector
	hGradQuasiFermi/Vector	
*- Carrier Densities:
  	*eDensity hDensity
	*EffectiveIntrinsicDensity IntrinsicDensity
	*eEquilibriumDensity hEquilibriumDensity
*- Fields, Potentials and Charge distributions
	ElectricField/Vector
	*Potential
	*SpaceCharge	
*- Currents	
	Current/Vector eCurrent/Vector  hCurrent/Vector
  	CurrentPotential	* visualizing current lines
  	eMobility hMobility
	eVelocity hVelocity
*- Generation/Recombination	
  	*srhRecombination AugerRecombination TotalRecombination SurfaceRecombination Band2Band RadiativeRecombination
  	*eLifeTime hLifeTime

*- Optical Generation	
    *ComplexRefractiveIndex QuantumYield
	*OpticalIntensity AbsorbedPhotonDensity OpticalGeneration
* Visualizing raytracing. Can be time consuming to plot.  
* RayTree cannot be  plotted CompactMemoryOption is specified in Physics section. 	
*RayTrees
	*Avalanche integrals
	eIonIntegral hIonIntegral MeanIonIntegral eAlphaAvalanche hAlphaAvalanche
}

CurrentPlot {
  AvalancheGeneration (Integrate(Semiconductor))
}	

Math {
	Derivatives
  	Avalderivatives
	ComputeIonizationIntegrals
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
		Goal { Name="p_contact_center" Voltage= -45 }
		 Plot {Range = (0 1) Intervals=46}
	){ Coupled { Poisson Electron Hole } }


}
