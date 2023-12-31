*---------------File---------------*

File {
*--Input--*
*parameter = "pp2_des.par"
Grid = "n1_msh.tdr"
*--Output--*
Plot= "n2_des.tdr"
Output = "n2_des.log"
Parameters = "models.par"
}

*---------------Electrode---------------*

Electrode{
{name="p_contact" voltage=0.0}
{name="n_contact" voltage=0.0}
}


*---------------Physics---------------*

 Physics (material="Silicon") { 

 	Mobility( 
		DopingDep(Unibo)
            	HighFieldsat(GradQuasiFermi)
 	  	)
  	Recombination( 
		 SRH(DopingDep TempDep)
		 Band2Band Auger
  		##hAvalanche(UniBo) eAvalanche(UniBo)  		
  		hAvalanche eAvalanche 		
		)
  	EffectiveIntrinsicDensity(OldSlotboom)
	eMobility(DopingDependance HighFieldSaturation Enormal)
	hMobility(DopingDependance HighFieldSaturation Enormal)


}


*---------------Plot---------------*

Plot {
	
        Current/Vector	
	eCurrent/Vector
	hCurrent/Vector
	eDensity
	hDensity
	ElectricField/Vector
	Potential
	CurrentPotential
  	DopingConcentration	
	eMobility
	hMobility
	DonorConcentration
	AcceptorConcentration
 	AvalancheGeneration
 	
 	eAvalanche hAvalanche
 	eLifeTime hLifeTime
	ConductionBand
	ValenceBand


}

*---------------Math---------------*


Math {

	##CDensityMin=1e-100
	Extrapolate
    Derivatives
  Avalderivatives
  Digits=7
  Notdamped=1000
  Iterations=15
  RelerrControl
  ErrRef(electron)=1e6
  ErrRef(hole)=1e6
  RhsMin=1e-15
  
    eMobilityAveraging=ElementEdge       
  hMobilityAveraging=ElementEdge       
  ParallelToInterfaceInBoundaryLayer(-ExternalBoundary)

}


*---------------Solve---------------*
	

Solve {
*- Buildup of initial solution:
   Coupled(Iterations=100){ Poisson }
   Coupled{ Poisson Electron Hole }
*- Bias on bottom contact
   Quasistationary(
     InitialStep=2.5e-3 MinStep=1e-5 MaxStep=0.1
     Goal{ Name="p_contact" Voltage = -40 }
   ){ Coupled{ Poisson Electron Hole } }
}
 * Quasistationary(
  *   InitialStep=0.001 MinStep=1e-5 Increment=1.3 Decrement=2 MaxStep=0.01
   *  Goal{ Name="n_contact" Voltage= 5 }
   *){ Coupled{ Poisson Electron Hole } }
