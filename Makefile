TEMPLATE_FILES := $(wildcard *.json)
GUEST := $(TEMPLATE_FILES:.json=)

OVF_FILES := $(foreach ovf_filename, $(GUEST), output/$(ovf_filename).ovf)
PWD := `pwd`

.PHONY: clean update

all: $(OVF_FILES)

#following code allow update 02 vm
update_vm := 02-win2012r2-standard-win_updates-wmf5
update_files := $(foreach vm, $(update_vm), $(wildcard output/$(vm).*))
update_ovf := $(foreach vm, $(update_vm), output/$(vm).ovf)
update_tmp := output/temp

update: $(update_ovf)
	@echo $@
	@echo $<
	@echo $^
	@echo mkdir -p $(update_tmp)
	@echo mv output/$(update_files) $(update_tmp)
	@$(foreach vm,$^, @echo packer build -color=false -only=virtualbox -var 'headless=false' -var 'source_path=$(update_tmp)/$(vm).ovf' -var 'vm_name=$(vm)' $(vm).json ;)
	@echo rm -fr $(update_tmp)

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
	@echo ovf_files $(OVF_FILES)
	@echo update_files $(update_list)
