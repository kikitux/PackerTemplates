TEMPLATE_FILES := $(wildcard *.json)
GUEST := $(TEMPLATE_FILES:.json=)

OVF_FILES := $(foreach vm, $(GUEST), output/$(vm)/$(vm).ovf)
PWD := `pwd`

.PHONY: clean update

all: $(OVF_FILES)

#following code allow update 02 vm
base_vm := output/01-win2012r2-standard-base/01-win2012r2-standard-base.ovf
update_vm := 02-win2012r2-standard-win_updates-wmf5
update_tmp := tmp

update: $(base_vm) output/$(update_vm)/$(update_vm).ovf
	@mkdir -p $(update_tmp)/
	@mv output/$(update_vm) $(update_tmp)/
	@packer build -color=false -only=virtualbox -var 'headless=false' -var "source_path=$(update_tmp)/$(update_vm)/$(update_vm).ovf" -var "vm_name=$(update_vm)" $(update_vm).json 
	@rm -fr $(update_tmp)/

#main logic for all vms from json file
output/%.ovf: %.json
	@echo 1 $< 
	@echo 1 $@ 
	@echo 2 $(@D)
	@echo 4 $(@F)
	@echo 5 $(subst .ovf,,$(@F))
	@-rm -fr $(@D)/$(subst .ovf,,$(@F))*
	@packer build -color=false -only=virtualbox -var 'headless=false' -var 'vm_name=$(subst .ovf,,$(@F))'  $<

clean:
	-rm -fr output*/ packer_cache/

list:
	@echo ovf_files $(OVF_FILES)
