                  package.path = "./?.lua;./lua/config/?.lua;" .. package.path
                  -- Mock nix-env per il development locale se necessario, 
                  -- o usa quello generato dal wrapper (ma qui è più semplice puntare al locale)
                  require("init")
