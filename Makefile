PATH := $(PWD)/node_modules/.bin:$(PATH)

COFFEE_COMPILE = coffee -cpb
YAML2JSON = traf -i yaml -o json
MKDIR = mkdir -p
RM = rm -rf
WATCH = watch

JS_TARGETS = $(shell find src -name '*.coffee'|sed -e 's/\.coffee/.js/' -e 's,^src/,,')
JSON_TARGETS = $(shell find src -name '*.yml'|sed -e 's/\.yml/.json/' -e 's,^src/,,')

.PHONY: all
all: $(JS_TARGETS) $(JSON_TARGETS)

$(JS_TARGETS) : %.js : src/%.coffee
	@$(MKDIR) $(dir $@)
	$(COFFEE_COMPILE) "$<" > "$@"

$(JSON_TARGETS) : %.json : src/%.yml
	@$(MKDIR) $(dir $@)
	$(YAML2JSON) "$<" "$@"

.PHONY: clean
clean:
	@$(RM) lib test schema

.PHONY: watch
watch:
	$(WATCH) "make --no-print-directory all" src --interval=1
