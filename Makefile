.PHONY: clean all distclean

TOP = $(PWD)
SRC  = $(PWD)/src
EBIN = $(PWD)/ebin
DEMO = $(PWD)/demo/src
DOC = doc
ERLC = erlc

WARNS = +warn_exported_vars +warn_unused_import +warn_missing_spec
ERLC_FLAGS = +native +debug_info $(WARNS)

SRC_MODULES = \
	graph \
	graph_lib \
	dijkstra \
	bfs \
	dfs \
	kruskal \
	heap \
	union_find \
	edmonds_karp

DEMO_MODULES = \
	demo \

EDOC_MODULES = \
	doc \

TARGETS = \
	src_target \
	demo_target \
	edoc_target

ERL_DIRS = \
	$(SRC) \
	$(DEMO)

vpath %.erl $(ERL_DIRS)

default: src_target

all: $(TARGETS) dialyze

src_target: $(SRC_MODULES:%=$(EBIN)/%.beam)

demo_target: $(DEMO_MODULES:%=$(EBIN)/%.beam)

edoc_target: $(EDOC_MODULES:%=$(EBIN)/%.beam)

$(EBIN)/%.beam: %.erl
	$(ERLC) $(ERLC_FLAGS) -o $(EBIN) $<

edoc: $(TARGETS)
	@(./makedoc.rb)

demo: $(TARGETS)
	@(./rundemo.rb)

dialyze: $(TARGETS)
	dialyzer -n -Wunmatched_returns $(EBIN)/*.beam

clean:
	$(RM) $(EBIN)/*.beam

distclean: clean
	$(RM) $(DOC)/*.html $(DOC)/*.css $(DOC)/*.png $(DOC)/edoc-info
