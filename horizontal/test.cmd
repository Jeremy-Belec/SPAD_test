Definitions {
  Refinement "global" {
    MaxElementSize = (0.01 0.01)
    MinElementSize = (0.001 0.001)
    RefineFunction = MaxLenInt(Interface("Silicon","SiO2"), 
             value=0.01, factor=2, DoubleSide)
    RefineFunction = MaxLenInt(Interface("Germanium","SiO2"), 
             value=0.01, factor=2, DoubleSide)
  }
}
