@testset "reigen norel" begin
    # Hydrogen-like atom
    Z = 92

    for perturb in [true, false]
        for n in 1:4, l in 0:n-1
            E_exact = -Z^2 / (2.0 * n^2)
            mesh = Mesh(1e-8, 50.0, 1e+7, 8000)
            V(r) = -Z / r
            E_window = [-5000.0, -0.0]
            E_init = -1000.0

            E, P, Q = solve_radial_eigenproblem(n, l, Z, V, mesh; tol=1e-9, max_iter=100, E_window=E_window, E_ini = E_init, rel = false, perturb = perturb)
            @test E ≈ E_exact atol = 1e-5

            # Test the wrappered solver from dftatom
            E_fpgen, P_fpgen, Q_fpgen = FPGEN.solve_radial_eigenproblem(n, l, Z, V, mesh; tol=1e-9, max_iter=100, E_window=E_window, E_ini = E_init, rel = false, perturb = perturb)
            @test E_fpgen ≈ E_exact atol = 1e-5

            # The wavefunction returned should also be very close approx
            for idx in [500, 1000]
                @test P[idx] ≈ P_fpgen[idx] atol = 1e-5
                @test Q[idx] ≈ Q_fpgen[idx] atol = 1e-5
            end
        end
    end
end