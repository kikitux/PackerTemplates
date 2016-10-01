BUILDER_TYPES = virtualbox
TEMPLATE_FILES := $(wildcard *.json)
BOX_FILENAMES := $(TEMPLATE_FILES:.json=.box)
BOX_FILES := $(foreach builder, $(BUILDER_TYPES), $(foreach box_filename, $(BOX_FILENAMES), $(builder)/$(box_filename)))

PWD := `pwd`

.PHONY: all clean

all:

virtualbox/%.box: %.json
	-rm -fr $@ output-$(subst .json,,$<)/
	@-mkdir -p $(@D)
	packer build -color=false -only=$(@D) -var 'headless=false' -var 'vm_name=$(subst .json,,$<)' $<

clean:
	-rm -fr $(BOX_FILES)

cleanall: clean
	-rm -fr output-*/ packer_cache/

list:
	@echo $(BOX_FILES)
