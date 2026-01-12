.PHONY: sim_pwm sim_sd synth_check

sim_pwm:
	chmod +x scripts/simulate_pwm.sh
	./scripts/simulate_pwm.sh

sim_sd:
	chmod +x scripts/simulate_sigma.sh
	./scripts/simulate_sigma.sh

synth_check:
	chmod +x scripts/synth_check.sh
	./scripts/synth_check.sh
