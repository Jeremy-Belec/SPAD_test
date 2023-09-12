Title "Untitled"

Controls {
}

IOControls {
	outputFile = "n1"
	EnableSections
}

Definitions {
	Constant "Const.Substrate" {
		Species = "PhosphorusActiveConcentration"
		Value = 5e+19
	}
	Constant "Const.Multiplication" {
		Species = "PhosphorusActiveConcentration"
		Value = 1e+15
	}
	Constant "Const.Charge_Sheet" {
		Species = "BoronActiveConcentration"
		Value = 1e+17
	}
	Constant "Const.Absorber" {
		Species = "VacancyConcentration"
		Value = 3e+15
	}
	Constant "Const.TopGe" {
		Species = "BoronActiveConcentration"
		Value = 5e+19
	}
	Refinement "RefinementDefinition.Substrate" {
		MaxElementSize = ( 6.5 0.05 )
		MinElementSize = ( 0.65 0.005 )
	}
	Refinement "RefinementDefinition.Multiplication" {
		MaxElementSize = ( 6.5 0.14 )
		MinElementSize = ( 0.65 0.014 )
	}
	Refinement "RefinementDefinition.Charge_Sheet" {
		MaxElementSize = ( 2.5 0.01 )
		MinElementSize = ( 0.25 0.001 )
	}
	Refinement "RefinementDefinition.Absorber" {
		MaxElementSize = ( 2.5 0.1 )
		MinElementSize = ( 0.25 0.01 )
	}
	Refinement "RefinementDefinition.TopGe" {
		MaxElementSize = ( 2.5 0.005 )
		MinElementSize = ( 0.25 0.0005 )
	}
}

Placements {
	Constant "PlaceCD.Substrate" {
		Reference = "Const.Substrate"
		EvaluateWindow {
			Element = region ["Substrate"]
		}
	}
	Constant "PlaceCD.Multiplication" {
		Reference = "Const.Multiplication"
		EvaluateWindow {
			Element = region ["Multiplication"]
		}
	}
	Constant "PlaceCD.Charge_Sheet" {
		Reference = "Const.Charge_Sheet"
		EvaluateWindow {
			Element = region ["Charge_Sheet"]
		}
	}
	Constant "PlaceCD.Absorber" {
		Reference = "Const.Absorber"
		EvaluateWindow {
			Element = region ["Absorber"]
		}
	}
	Constant "PlaceCD.TopGe" {
		Reference = "Const.TopGe"
		EvaluateWindow {
			Element = region ["TopGe"]
		}
	}
	Refinement "RefinementPlacement.Substrate" {
		Reference = "RefinementDefinition.Substrate"
		RefineWindow = Rectangle [(0 0) (65 0.5)]
	}
	Refinement "RefinementPlacement.Multiplication" {
		Reference = "RefinementDefinition.Multiplication"
		RefineWindow = Rectangle [(0 0.5) (65 1.9)]
	}
	Refinement "RefinementPlacement.Charge_Sheet" {
		Reference = "RefinementDefinition.Charge_Sheet"
		RefineWindow = Rectangle [(20 1.9) (45 2)]
	}
	Refinement "RefinementPlacement.Absorber" {
		Reference = "RefinementDefinition.Absorber"
		RefineWindow = Rectangle [(20 2) (45 3)]
	}
	Refinement "RefinementPlacement.TopGe" {
		Reference = "RefinementDefinition.TopGe"
		RefineWindow = Rectangle [(20 3) (45 3.05)]
	}
}

