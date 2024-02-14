# Template
# Author: bungleship
# Description: stuff

using Turing, CairoMakie

mutable struct Posterior
    model
    chains
    plot
    @model function observe(data, priors)

        # Define priors
        p ~ priors

        # Condition on data
        data ~ Binomial(100, p)
    end
    function graph(chain)
        # all values, parameter p, first chain
        density(chain[:, :p, 1])
    end
    function Posterior(data, priors=Beta(1,1))
        # fitting the model
        model = observe(data, priors)

        # sampling
        num_chains = 1
        chains = sample(model, MH(), MCMCThreads(), 40000, num_chains)

        # graphing
        function plot()
            # loop over parameters or chains here
            graph(chains)
        end
        new(model, chains, plot)
    end
end

# Usage
# observing 61 heads out of 100 with a uniform continuous prior for p
# post = Posterior(61, Beta(1,1))
# post.plot()
