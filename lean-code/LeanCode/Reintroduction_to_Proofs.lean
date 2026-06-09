example {A : Type} (a : A) : A := by
    assumption
    -- assumption works by matching the goal with an existing hypothesis.
    -- This examples defines a term of type A given a hypotheses
    -- a : A

example {P : Prop} (p : P) : P := by
    assumption
    -- This examples defines a proof of P given p : P

example {A B : Type} (x : A) (y z : B) := by
    exact y
    -- exact gives a term that matches the goal exactly
    -- The linter warns about unused variables x and z;
    -- This is an exercise to show how to define an element of type B

example : Unit := by
    exact ⟨⟩
    -- Has exactly one term ⟨⟩.


example (P Q : Prop) (p : Prop) : Prop := by
    exact Q
    -- p : P is a proposition, Prop is a type of proposition
    -- where p : Prop is a proposition
    -- exact Q correctly returns a term of type Prop as expected.

example : Type := by
    exact Unit
    -- Type is the built in type of types, to avoid contradictions
    -- The Type is a synonym for Type 0, the type Unit is a element of
    -- Type hence whe can solve by using exact Unit.

example (P Q R : Prop) (q : Q) (r : R) : Type := by
    exact Prop
    -- Which such example we can also use Prop that is an
    -- element of Type.

-- The above code concludes all the seven levels of type world.
-- Bellow is the function world.
