dconf.config: dump

.PHONY: dump
dump:
	dconf dump / > dconf.config

.PHONY: load
load:
	dconf load / < dconf.config
	
