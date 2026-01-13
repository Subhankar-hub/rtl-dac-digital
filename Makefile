.PHONY: sim_pwm sim_sd synth_check gds clean_gds

sim_pwm:
	chmod +x scripts/simulate_pwm.sh
	./scripts/simulate_pwm.sh

sim_sd:
	chmod +x scripts/simulate_sigma.sh
	./scripts/simulate_sigma.sh

synth_check:
	chmod +x scripts/synth_check.sh
	./scripts/synth_check.sh

# RTL-to-GDS using OpenLane 2 (requires: pip install openlane volare)
gds:
	chmod +x scripts/run_openlane.sh
	./scripts/run_openlane.sh

clean_gds:
	rm -rf runs/ gds_output/
