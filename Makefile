ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

UNAME := $(shell uname)
LIBEXT := so

ifeq ($(UNAME), Darwin)
	CC := clang
	CFLAGS := -undefined dynamic_lookup -dynamiclib
endif

ifeq ($(UNAME), Linux)
	CC := gcc
	CFLAGS := -shared -fpic -D_POSIX_C_SOURCE=199309L
endif

ifeq ($(findstring MINGW,$(UNAME)),MINGW)
	CC := gcc
	CFLAGS := -shared -D_POSIX_C_SOURCE=199309L
	LIBEXT := dll
endif

all: priv/decoder.$(LIBEXT)

priv/decoder.$(LIBEXT): c_src/decoder_nif.c c_src/decoder.c
	mkdir -p priv
	$(CC) $(CFLAGS) -std=c99 -O3 -I$(ERL_INCLUDE_PATH) c_src/decoder*.c -o priv/decoder.$(LIBEXT)

clean:
	@rm -rf priv/decoder.$(LIBEXT)
