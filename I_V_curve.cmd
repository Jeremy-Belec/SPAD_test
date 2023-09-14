File {
Grid = "@tdr@"
Parameter = "mos"
  Plot = "@tdrdat@"
Current = "@plot@"
Output = "@log@"
}

Electrode {
{ Name="source" Voltage=0.0 }
{ Name="drain" Voltage=0.0 }
{ Name="gate" Voltage=0.0 Barrier=-0.55 }
{ Name="substrate" Voltage=0.0 }
}
Physics {
AreaFactor=0.4
Hydrodynamic( eTemperature )
Mobility ( DopingDependence Enormal
eHighFieldsat(CarrierTempDrive)
hHighFieldsat(GradQuasiFermi) )
Recombination( SRH(DopingDependence)
eAvalanche(CarrierTempDrive)
hAvalanche(Eparallel) )
EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
}

#Add germanium and silicium traps

Plot {
eDensity hDensity eCurrent hCurrent
equasiFermi hquasiFermi
eTemperature
ElectricField eEparallel hEparallel
Potential SpaceCharge
SRHRecombination Auger AvalancheGeneration
eMobility hMobility eVelocity hVelocity
Doping DonorConcentration AcceptorConcentration
}
CurrentPlot {
Potential ((0.1 0.05) (0.582 0.009) (0.5 0.5))
eTemperature ((0.1 0.05) (0.582 0.009) (0.5 0.5))
}


Math {
Extrapolate
RelErrControl
Iterations=20
BreakCriteria {Current(Contact="drain" Absval=3e-4)
}
}


Solve {
# initial gate voltage Vgs=0.0V
Poisson
Coupled { Poisson Electron }
Coupled { Poisson Electron Hole eTemperature }
Save (FilePrefix="vg0")

# first curve
Load(FilePrefix="vg0")
NewCurrentPrefix="vg0_"
Quasistationary
(InitialStep=0.01 Maxstep=0.1 MinStep=0.0001
Goal{ name="drain" voltage=10.0 }
)
{ Coupled {Poisson Electron Hole eTemperature}
CurrentPlot (time=
(range = (0 0.2) intervals=20;
range = (0.2 1.0)))}
