example {A : Type} (a : A) : A := by
    assumption
    -- assumption works by matching the goal with an existing hypothesis.
    -- This examples defines a term of type A given a hypotheses
    -- a : A

example {P : Prop} (p : P) : P := by
    assumption
    -- This examples defines a proof of P given p : P

example {A B : Type} (x : A) (y z : B) := by
    -- exact gives a term that matches the goal exactly
    -- The linter warns about unused variables x and z;
    -- This is an exercise to show how to define an element of type B
    exact y

example : Unit := by
    -- Has exactly one term ⟨⟩.
    exact ⟨⟩

example (P Q : Prop) (p : Prop) : Prop := by
    exact Q
    -- p : P is a proposition, Prop is a type of proposition
    -- where p : Prop is a proposition
    -- exact Q correctly returns a term of type Prop as expected.

example : Type := by
    exact Unit
