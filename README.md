# Network Effects of Tariffs

This repository contains the Julia implementation required to replicate Examples 1, 2, and 3 discussed in the paper "Network Effects of Tariffs".

## Modeling and Solver

To solve the model, we used the **PATH solver**, configured via a license string in the environment variables, which is ideal for tackling Mixed Complementarity Problems (MCP).

For the model development, we relied on two main Julia packages:

- **JuMP**: Used for the initialization of the mathematical model, defining continuous variables, and building algebraic expressions.
    
- **Complementarity**: Essential for defining the complementarity conditions (e.g., between profit margins and exported quantities) and for interfacing directly with the MCP solver.
    

## Description of the Examples

### Example 1

For the first example, we simply called the solver on the base model. Given the linear nature of the supply and demand functions (based on the parameters $a, s$ for supply and $b, d$ for demand), the main welfare metrics for Country 2 can be calculated analytically.

Because the curves are linear, the Consumer Surplus and Producer Surplus correspond geometrically to the areas of triangles, leading to the following simplified mathematical formulas:

- **Consumer Surplus (CS):** $CS = \frac{1}{2} d \cdot Q_D^2$
    
- **Producer Surplus (PS):** $PS = \frac{1}{2} s \cdot Q_S^2$

### Example 2

In this example, we initialized the solver by defining two different initial conditions within the model variables. This method was used to evaluate the respective multiple equilibrium flux matrices calculated by the solver depending on the starting values.

### Example 3

To reproduce the third example, we initialized the initial tariff matrix by imposing a 10% fixed tariff from countries 3 and 4 towards all possible destinations. Following this setup phase, we introduced a random perturbation into the system to prevent the formation of structural cycles within the bipartite graph of the trade network.

