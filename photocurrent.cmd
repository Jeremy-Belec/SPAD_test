#setdep @node|sde@

File {
*-Input		
	Grid = "n1_msh.tdr"
	Parameter= "models.par"
*-Output	
	Current=   "n4_current_des.tdr"
	Plot=      "n4_des.tdr"
	Output=    "n4_des.log"
}

Electrode {
	{ Name= "n_contact"  Voltage= 0 }
	{ Name= "p_contact"  Voltage= 0 }
}


RayTraceBC {
		{ Name= "p_contact"
			Reflectivity= 1.0
		}
		{ Name= "n_contact"
			Reflectivity= 1.0
		}		
	}


Physics	{		
	Temperature= 77	
	Thermionic
	HeteroInterfaces	 
	Mobility(HighFieldSaturation)
	EffectiveIntrinsicDensity(NoFermi) 
	Recombination(
		SRH 
		Auger
	)	
	
	Optics (
    	ComplexRefractiveIndex (WavelengthDep(Real Imag))
		OpticalGeneration (
			QuantumYield (StepFunction (EffectiveBandgap)) 
			ComputeFromMonochromaticSource
		) 
		Excitation (
			Wavelength= 2  				* Incident light wavelength [um]
			Intensity= 1  				* Incident light intensity [W/cm2]	
			Polarization= 0.5				* Unpolarized light
			Theta= 0						* Normal incidence,	in -ve x direction
			Window(
				[(0 -15 0) (0 15 0)]
			)			
		) * end Excitation
		OpticalSolver (
      		RayTracing (	        		
				RayDistribution(
					Mode= AutoPopulate
					NumberOfRays= 300				* Number of rays in the illumination window
				)
				CompactMemoryOption
				DepthLimit= 1000 					* Stop tracing a ray after passing through more than x material boundaries
				MinIntensity= 1e-5					* Stop tracing a ray when its intensity becomes less than x times the original intensity			
			) * end RayTracing
		)	* end OpticalSolver		
	) * end Optics
}	

Plot {    
*- Doping and mole fraction profiles	
	Doping DonorConcentration AcceptorConcentration	
	xMoleFraction
*- Band structure
	BandGap BandGapNarrowing ElectronAffinity
	ConductionBandEnergy ValenceBandEnergy
	eQuasiFermiEnergy hQuasiFermiEnergy		
*- Carrier Densities:
  	eDensity hDensity
	EffectiveIntrinsicDensity IntrinsicDensity
	eEquilibriumDensity hEquilibriumDensity
*- Fields, Potentials and Charge distributions
	ElectricField/Vector
	Potential
	SpaceCharge	
*- Currents	
	Current/Vector eCurrent/Vector  hCurrent/Vector
  	CurrentPotential	* visualizing current lines
  	eMobility hMobility
	eVelocity hVelocity
*- Generation/Recombination	
  	srhRecombination AugerRecombination TotalRecombination SurfaceRecombination Band2Band RadiativeRecombination
  	eLifeTime hLifeTime

*- Optical Generation	
    ComplexRefractiveIndex QuantumYield
	OpticalIntensity AbsorbedPhotonDensity OpticalGeneration
* Visualizing raytracing. Can be time consuming to plot.  
* RayTree cannot be  plotted CompactMemoryOption is specified in Physics section. 	
*  	RayTrees

}	

Math {
	Extrapolate
	RelErrcontrol
	Digits= 5
	Notdamped= 20
	Iterations= 12
	ElementEdgeCurrent
	ErrRef(electron)= 1e3
	ErrRef(hole)= 1e3				   
}

Solve {
	NewCurrentPrefix= "tmp_"
	Poisson
	NewCurrentPrefix= ""
	Coupled (Iterations= 100){ Poisson Electron Hole }	
  	Plot (FilePrefix= "n@node@_photo")

			
	*ramp voltage at anode from 0V to -0.3 V	
	Quasistationary ( 
		InitialStep= 1e-2 Increment= 1.4
		MinStep= 1e-6     MaxStep= 0.01	
		Goal { Name="p_contact" Voltage= -10 }
	){ Coupled { Poisson Electron Hole } }

	System("rm -f tmp*") *remove the plot we don't need anymore.	
}
