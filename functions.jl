function solve_trade_model(t_matrix, a, s, b, d)
    N = length(a) 

    m = MCPModel()
    @variable(m, q[1:N, 1:N] >= 0)

    @expression(m, Q_prod[j=1:N], sum(q[j, i] for i in 1:N))
    @expression(m, Q_cons[i=1:N], sum(q[j, i] for j in 1:N))

    @expression(m, MC[j=1:N], a[j] + s[j] * Q_prod[j])
    @expression(m, P[i=1:N],  b[i] - d[i] * Q_cons[i])

    @mapping(m, margine[j=1:N, i=1:N], MC[j] * (1 + t_matrix[j, i]) - P[i])
    @complementarity(m, margine, q)

    solveMCP(m, silent = true)
    
    q_val = result_value.(q)
    Q_prod_val = vec(sum(q_val, dims=2)) 
    Q_cons_val = vec(sum(q_val, dims=1))
    MC_val = a .+ s .* Q_prod_val
    
    return q_val, MC_val, Q_prod_val, Q_cons_val
end

function solve_trade_model_initial_condition(start_matrix, t_matrix, a, s, b, d)
    N = length(a) 

    m = MCPModel()
    @variable(m, q[1:N, 1:N] >= 0)

    @expression(m, Q_prod[j=1:N], sum(q[j, i] for i in 1:N))
    @expression(m, Q_cons[i=1:N], sum(q[j, i] for j in 1:N))

    @expression(m, MC[j=1:N], a[j] + s[j] * Q_prod[j])
    @expression(m, P[i=1:N],  b[i] - d[i] * Q_cons[i])

    @mapping(m, margine[j=1:N, i=1:N], MC[j] * (1 + t_matrix[j, i]) - P[i])
    @complementarity(m, margine, q)
    set_start_value.(q, start_matrix)

    solveMCP(m, silent = true)
    
    q_val = result_value.(q)
    Q_prod_val = vec(sum(q_val, dims=2))
    Q_cons_val = vec(sum(q_val, dims=1))

    MC_val = a .+ s .* Q_prod_val
    P_val  = b .- d .* Q_cons_val

    # Consumer surplus del paese 2
    CS2 = 0.5 * d[2] * Q_cons_val[2]^2

    # Producer surplus del paese 2
    PS2 = 0.5 * s[2] * Q_prod_val[2]^2

    # Tariff revenue del paese 2
    TR2 = sum(
        t_matrix[j, 2] * MC_val[j] * q_val[j, 2]
        for j in 1:N if j != 2
    )

    # Welfare del paese 2
    W2 = CS2 + PS2 + TR2

    return q_val, P_val, MC_val, TR2, W2
end

