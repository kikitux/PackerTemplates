TEMPLATE_FILES := $(wildcard *.json)
GUEST := $(TEMPLATE_FILES:.json=)

OVF_DIR := $(foreach ovf_filename, $(GUEST), output-$(ovf_filename))
#SHELL := $(shell make -p $(OVF_DIR))

OVF_FILES := $(foreach ovf_filename, $(GUEST), output-$(ovf_filename)/$(ovf_filename).ovf)
PWD := `pwd`

.PHONY: clean

all: $(OVF_FILES)

$(OVF_FILES):  
	@#echo 1 $@ 
	@#echo 2 $(@D)
	@#echo 4 $(@F)
	@#echo 4 $(subst .ovf,.json,$(@F))
	@#echo 5 $(subst .ovf,,$(@F))
	@-rm -fr $(@D)
	packer build -color=false -only=virtualbox -var 'headless=false' -var 'vm_name=$(subst .ovf,,$(@F))'  $(subst .ovf,.json,$(@F))

clean:
	-rm -fr $(BOX_FILES)

cleanall: clean
	-rm -fr output-*/ packer_cache/

list:
	@echo $(OVF_DIR)
	@echo $(OVF_FILES)
