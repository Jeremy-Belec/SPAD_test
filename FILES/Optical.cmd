
File {
*--Input--*
*parameter = "pp2_des.par"
Grid = "n1_msh.tdr"
*--Output--*
Plot= "n4_des.tdr"
Output = "n4_des.log"
Parameters = "models.par"
}



Electrode {
	{name = "p_contact"   voltage = 0.0 }

	{name = "n_contact"   voltage = 0.0 }	
		
}


Physics { 

 	Mobility( 
		DopingDep(Unibo)
		Enormal
		hHighFieldsaturation(GradQuasiFermi)
		eHighFieldsaturation(GradQuasiFermi)
 	  	)
  	Recombination(
		 SRH(DopingDep TempDep)
		 Band2Band Auger(WithGeneration)
  		##hAvalanche(UniBo) eAvalanche(UniBo)  		
  		hAvalanche eAvalanche 		
		)
	eQCvanDort
  	EffectiveIntrinsicDensity(OldSlotboom)
	eMobility(DopingDependance HighFieldSaturation Enormal)
	hMobility(DopingDependance HighFieldSaturation Enormal)


}




Math {


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

  Transient=BE
  
    Method=Blocked
  SubMethod=ILS (set=1)
  ACMethod=Blocked 
  ACSubMethod=ILS (set=2)
 
  
  ILSrc = "
           set(1) { 
                iterative( gmres(100), tolrel=1e-8, tolunprec=1e-4, tolabs=0, maxit=200 ); 
                preconditioning( ilut(0.0001,-1), left ); 
                ordering( symmetric=nd, nonsymmetric=mpsilst ); 
                options( compact=yes, verbose=0, refineresidual=0 ); 
           };
           
           set(2) { 
                iterative( gmres(100), tolrel=1e-8, tolunprec=1e-4, tolabs=0, maxit=200 ); 
                preconditioning( ilut(1e-8,-1), left ); 
                ordering( symmetric=nd, nonsymmetric=mpsilst ); 
                options( compact=yes, verbose=0, refineresidual=0 ); 
           };

           
     "

  number_of_threads=4

 Extrapolate 
}


Solve {

  Poisson
  plugin { Poisson Electron Hole }
  Coupled { Poisson Electron Hole }

 NewCurrent="IRRA_"    
  
   Transient (  	initialtime=0 finaltime=100
   			MaxStep=10  MinStep=1e-8 InitialStep=0.1
			Increment=1.6 Decrement=4.0
                 		)
                  { Coupled {  Poisson Electron Hole } } 
                  
    Quasistationary (  		DoZero
   			MaxStep=0.02  MinStep=1e-8 InitialStep=1e-5
			Increment=1.6 Decrement=4.0
                  		Goal { Name="p_contact" Voltage=-40 } 
                  	BreakCriteria {Current (Contact = "p_contact" minval = -1e-5 )}
                 		)
                  { Coupled {  Poisson Electron Hole } } 

}
   

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
 	
 	
 	RadiationGeneration


}


