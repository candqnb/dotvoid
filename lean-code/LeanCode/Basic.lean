example {A : Type} (a : A) : A := by
    assumption
    -- This example defines an type A with a single hypothesized element, a
    -- assumption is a tatic, read more about it.

example {P : Prop} (p : P) : P := by
    assumption
    -- This examples defines a proposition P, with a single proof, p

-- Read about proposition's and type's in LEAN.
