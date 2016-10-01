TEMPLATE_FILES := $(wildcard *.json)
GUEST := $(TEMPLATE_FILES:.json=)

OVF_FILES := $(foreach ovf_filename, $(GUEST), output/$(ovf_filename).ovf)
PWD := `pwd`

.PHONY: clean

all: $(OVF_FILES)

output/%.ovf: %.json
	@#echo 1 $< 
	@#echo 1 $@ 
	@#echo 2 $(@D)
	@#echo 4 $(@F)
	@#echo 5 $(subst .ovf,,$(@F))
	@-rm -f $(@D)/$(subst .ovf,,$(@F))*
	packer build -color=false -only=virtualbox -var 'headless=false' -var 'vm_name=$(subst .ovf,,$(@F))'  $<

clean:
	-rm -fr output*/ packer_cache/

list:
	@echo $(OVF_FILES)
