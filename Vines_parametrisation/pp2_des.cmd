*---------------File---------------*

File {
*--Input--*
*parameter = "pp2_des.par"
Grid = "n1_msh.tdr"
*--Output--*
Plot= "n2_des.tdr"
Output = "n2_des.log"
}

*---------------Electrode---------------*

Electrode{
{name="Top" voltage=0.0}
{name="Bottom" voltage=0.0}
}


*---------------Physics---------------*

Physics{
	Fermi
EffectiveIntrinsicDensity( OldSlotboom)
Recombination(SRH)
}

*---------------Plot---------------*


*---------------Math---------------*

Math {
*-- Numeric/Solver Controls --*
  Extrapolate           * switches on solution extrapolation along a bias ramp
  Derivatives           * considers mobility derivatives in Jacobian
  Iterations=8          * maximum-allowed number of Newton iterations (3D)
*  RelErrControl         * switches on the relative error control for solution 
                        * variables (on by default)
*  Digits=5              * relative error control value. Iterations stop if 
                        * dx/x < 10^(-Digits)
  Method=ILS            * use the iterative linear solver with default parameter 
  NotDamped=100         * number of Newton iterations over which the RHS-norm 
                        * is allowed to increase
  Transient=BE          * switches on BE transient method
}

*---------------Solve---------------*
	

Solve {
*- Buildup of initial solution:
   Coupled(Iterations=100){ Poisson }
   Coupled{ Poisson Electron Hole }
*- Bias on bottom contact
   Quasistationary(
     InitialStep=2.5e-3 MinStep=1e-5 MaxStep=0.1
     Goal{ Name="Top" Voltage = 5 }
   ){ Coupled{ Poisson Electron Hole } }
}
 * Quasistationary(
  *   InitialStep=0.001 MinStep=1e-5 Increment=1.3 Decrement=2 MaxStep=0.01
   *  Goal{ Name="Bottom" Voltage= 5 }
   *){ Coupled{ Poisson Electron Hole } }





