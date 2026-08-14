Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495DE46C4A0;
	Fri, 14 Aug 2026 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786728071; cv=none; b=Ah3qJ/VjrJdqZd0SzsW7AChPZc5u6HzR5vUuEmB8RpgObX38ejtWKelvgdScyGuM9bJBYUdyDYfwGwMDPY1MRMF7FOci9eLMsZtdkZzrVZhMBVTEK36Ub8o1TZXQ5OXJBDyoOEul++XnS0HjMOM+8ZjTW45TgA2aCpwnR7dLH7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786728071; c=relaxed/simple;
	bh=NlaRhEj0QeROPl949pM7+Tsw0V5g8Y9QEoFbk6I9PvQ=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=gpVbfFRb/BY3S9FZgMwF9bt2bIGF5MmSDRXPmvgYcMMt2b0p9S36NyJqLKxBiqPyfJuhyV5KOUupmQBUeixF77azWv2PwNRxyzgm38ZLx7dj5uPO1DqSmQH9pzCnnHezxDy827nk+b51Y1vD/eHNCqdDVOoaRxc/9aJ+1Mrt8js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZi0XuuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZi0XuuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C4D1F000E9;
	Fri, 14 Aug 2026 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786728070;
	bh=a7Gn1L4Vt09NGwq/6A9esmcFIUrJ4Ih2A50WIYYLKts=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XZi0XuuDJtxpNuBeQBsOSEEnR0amsX6avrlyBrSl7F8xaUB7jvL8rzCwRR/yQJ+4I
	 Ise69z3gVTObogKGNdTPlKHOhJhNPjW2fqOLUBg816M5jqq9M6PUw5gPsotW25aa4q
	 6fFc8Gt/MojQTnCLceWvL9tzkfsHDAIXU/36JQJRXjWWKBuyxa5+Xp70U8HIS7s3pP
	 GtppXJuNQHb1caF1oERfuSvy3wzuIh2Yp2Rdb9Sl95e5D2Yw3iZOCDtOIWWfga3APQ
	 zyCFM3Iic71dLlqM/JvlfvCq48EnXU7Ocfcnc/b79Q/hLlXsi4mQJAZ/L0yGpc2CaQ
	 LJ3AXzdkTArwA==
Content-Type: multipart/mixed; boundary="===============4448923700193765925=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <0ab4b02e666d8964b30c09510e801fa83a3a9af11ee2233a69193934e62a24e8@mail.kernel.org>
In-Reply-To: <20260814075054.507089-2-ziyang.meme@gmail.com>
References: <20260814075054.507089-2-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 14 Aug 2026 17:21:08 +0000 (UTC)

--===============4448923700193765925==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
> new file mode 100644
> index 000000000000..433a26a36960
> --- /dev/null
> +++ b/tools/testing/selftests/lib.bpf.mk
> @@ -0,0 +1,296 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Build BPF programs and skeleton headers for selftests, then link them into
> +# test binaries.
> +#
> +# Use it from a test Makefile like this:
> +#
> +#     BPF_SRCS         := foo.bpf.c bar.bpf.c
> +#     TEST_GEN_PROGS   := foo_test
> +#     OVERRIDE_TARGETS := 1              # set before lib.mk
> +#     include ../lib.mk
> +#     include ../lib.bpf.mk
> +#
> +#     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS) $(BPFOBJ)
> +#         $(call bpf_link,$@,$<)
> +#
> +# Keep $(BPFOBJ) in the dependencies so make relinks the test when libbpf.a
> +# changes.
> +#
> +# Options to set before including lib.bpf.mk:
> +#   BPF_PROG_EXT     - source ending; default .bpf.c. Use .c for progs/foo.c.
> +#   BPF_EXTRA_HDRS   - more headers needed by the BPF objects.
> +#   BPF_EXTRA_CFLAGS - more flags for compiling BPF programs.
> +#   BPF_SKEL_EXT     - skeleton header ending; default .skel.h.
> +#   BPF_GEN_SUBSKEL  - also create a subskeleton header when set.
> +#   BPF_OBJ_DIR      - folder for BPF objects; default $(OUTPUT).
> +#   BPF_SKEL_DIR     - folder for skeleton headers; default $(OUTPUT).
> +#
> +# You may replace BPF_CFLAGS after including this file. Make reads it when each
> +# object is built. Sources may be in subfolders, but generated files use only
> +# the source filename and are placed directly in their output folder.
> +#
> +# Include lib.mk first. This file uses OUTPUT, top_srcdir, CC, CLANG, Q and msg.
> +# OVERRIDE_TARGETS stops lib.mk from adding its normal link rule. This file sets
> +# BPFOBJ, BPFTOOL, BPF_OBJS, BPF_SKELS and BPF_LDLIBS, and adds to CFLAGS and
> +# EXTRA_CLEAN.

The documented contract lists five variables that this file sets (BPFOBJ,
BPFTOOL, BPF_OBJS, BPF_SKELS, BPF_LDLIBS), but the fragment unconditionally
assigns about twenty more with ':=', several having generic names that an
existing test Makefile might already use: TOOLSDIR, LIBDIR, BPFDIR,
TOOLSINCDIR, BPFTOOLDIR, APIDIR, SCRATCH_DIR, BUILD_DIR, INCLUDE_DIR,
HOST_BUILD_DIR, HOST_SCRATCH_DIR, HOST_BPFOBJ, DEFAULT_BPFTOOL, MAKE_DIRS,
BPF_CFLAGS, CLANG_SYS_INCLUDES, IS_LITTLE_ENDIAN, MENDIAN, CLANG_BPF_CPU,
BPF_SUBSKEL_EXT, submake_extras.

It also defines rules for $(MAKE_DIRS), appends to the phony 'all', and via
'include $(top_srcdir)/tools/scripts/Makefile.arch' it sets ARCH (with the
'override' keyword when ARCH is empty), SRCARCH, HOSTARCH, LP64 and
IS_64_BIT.

The sched_ext conversion already had to rework its own INCLUDE_DIR,
OBJ_DIR, SCXOBJ_DIR and MAKE_DIRS precisely because the names collide.

There's also an asymmetry in assignment operators: BPF_PROG_EXT,
BPF_SKEL_EXT, BPF_OBJ_DIR, BPFTOOL and VMLINUX_BTF* use '?=' so a caller
can influence them, but SCRATCH_DIR, BUILD_DIR and INCLUDE_DIR use ':=', so
a caller cannot relocate the libbpf/bpftool scratch tree even though it
lands inside the test's own directory.

Could the 'This file sets ...' list be completed (and the collision risk
called out), or should the internal names be prefixed to reduce the
collision surface?

>
> +include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH / HOSTARCH

[ ... ]

> +# vmlinux.h can contain anonymous struct and union members. Clang needs
> +# -fms-extensions to accept them.
> +BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
> +	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(TOOLSINCDIR)		\
> +	     -std=gnu11							\
> +	     -fno-strict-aliasing					\
> +	     -fms-extensions -Wno-microsoft-anon-tag			\
> +	     -Wno-compare-distinct-pointer-types			\
> +	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)

A subsystem pattern flags this as potentially concerning: -I$(TOOLSINCDIR)
(tools/include) is added to the BPF-program include path. None of the three
Makefiles this fragment replaces do that, and selftests/bpf/Makefile
deliberately does not either.

It has -I$(TOOLSINCDIR) only in COMMON_CFLAGS for the userspace test
binaries, while its BPF_CFLAGS includes only -I$(INCLUDE_DIR) -I$(CURDIR)
-I$(APIDIR) with no tools/include.

tools/include/linux/ holds 81 host-tool shim headers (err.h, filter.h,
kernel.h, mm.h, module.h, mutex.h, atomic.h, compiler.h, bitops.h, list.h)
whose contents are meant for userspace tools and conflict with vmlinux.h.

Because $(CLANG_SYS_INCLUDES) uses -idirafter, these shims also sort ahead
of /usr/include, so a BPF program that includes any non-uapi <linux/...>
name silently picks up a host shim instead of failing or getting the real
header.

This is currently harmless for all three consumers: -I$(APIDIR) precedes
-I$(TOOLSINCDIR), and the only <linux/...> names actually reached today are
<linux/const.h> (hid/progs/hid_bpf_helpers.h, present in
tools/include/uapi/linux/) and <linux/errno.h> (tools/lib/bpf/*.bpf.h,
present in neither, so it resolves via -idirafter). sched_ext escapes
entirely because it replaces BPF_CFLAGS after the include.

So this is a latent hazard for future consumers rather than a current
breakage, but since no consumer needs it and it diverges from the file's
own stated model (selftests/bpf/Makefile), would dropping -I$(TOOLSINCDIR)
from BPF_CFLAGS be safer?

>
> +# $1 = source, $2 = object. -MMD -MP records every included header, including
> +# headers included by other headers.

[ ... ]

> +# ---- build vmlinux.h ------------------------------------------------------
> +# Replace vmlinux.h only when its contents change. A new timestamp alone would
> +# rebuild every BPF object and skeleton.
> +$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
> +ifeq ($(VMLINUX_H),)
> +	$(call msg,GEN,,$@)
> +	$(Q)test -n "$(VMLINUX_BTF)" || { \
> +		echo "lib.bpf.mk: no vmlinux with BTF at any of \"$(VMLINUX_BTF_PATHS)\"" >&2; \
> +		exit 1; }
> +	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@.tmp
> +else
> +	$(call msg,CP,,$@)
> +	$(Q)cp "$(VMLINUX_H)" $@.tmp
> +endif
> +	$(Q)cmp -s $@.tmp $@ || mv $@.tmp $@
> +	$(Q)rm -f $@.tmp

A subsystem pattern flags this as potentially concerning: when the dumped
BTF is byte-identical to the existing vmlinux.h, the recipe leaves $@
untouched so its mtime stays older than $(VMLINUX_BTF), and make re-runs
the whole recipe on every subsequent invocation.

'bpftool btf dump file <vmlinux> format c' on a full kernel is a
multi-second, ~100k-line dump, so once the BTF source is newer than the
generated header (after any kernel rebuild, or a fresh
/boot/vmlinux-$(uname -r)) every no-op 'make' in the test directory pays
that cost, permanently.

Both hid and sched_ext previously redirected straight into $@, so the dump
ran once and then the target was up to date. The idiom is inherited from
selftests/bpf/Makefile and the comment correctly explains why the content
check exists, but would 'cmp -s $@.tmp $@ && touch $@ || mv $@.tmp $@' keep
the no-rebuild property while also stopping the repeated dump?

>
> +# ---- BPF objects and skeletons --------------------------------------------
> +BPF_PROG_EXT ?= .bpf.c
> +# Each source must end with BPF_PROG_EXT so Make can remove that ending.
> +bpf_bad_srcs := $(filter-out %$(BPF_PROG_EXT),$(BPF_SRCS))
> +ifneq ($(bpf_bad_srcs),)
> +$(error lib.bpf.mk: BPF_SRCS entries must end in $(BPF_PROG_EXT): $(bpf_bad_srcs))
> +endif
> +bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
> +# Reject any dot left after removing BPF_PROG_EXT. For example, foo.bpf.c leaves
> +# foo.bpf when the ending is set to .c.
> +bpf_dotted_stems := $(filter-out $(basename $(bpf_stems)),$(bpf_stems))
> +ifneq ($(bpf_dotted_stems),)
> +$(error lib.bpf.mk: BPF_SRCS basenames must not contain a dot: $(bpf_dotted_stems))
> +endif
> +# Generated files use only the source filename. Reject equal filenames instead
> +# of letting one replace another.
> +ifneq ($(words $(bpf_stems)),$(words $(sort $(bpf_stems))))
> +$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
> +endif

[ ... ]

> +BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(bpf_stems)))
> +BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(bpf_stems)))

[ ... ]

> +# Link three times and compare the last two outputs. A correct linker must not
> +# change an object that it already linked.
> +$(BPF_SKELS): $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)

BPF_SRCS is the fragment's one mandatory input, and the validation above
checks three different ways it can be malformed (wrong extension, dotted
basename, colliding basenames) with a clear $(error) message. The one
remaining malformed value - empty - is not checked, and it is the case that
degrades worst.

With an empty BPF_SRCS, bpf_stems, BPF_OBJS and BPF_SKELS are all empty,
and the static pattern rule above is read by make as a rule whose target
list is empty - a rule with nothing before the first colon. GNU make
rejects this outright, so the *include* of ../lib.bpf.mk aborts with a
generic parse error naming lib.bpf.mk:252 rather than with one of the
fragment's own diagnostics, and it does so for 'make clean' and 'make
install' too. This is the failure mode the author deliberately avoided for
the missing-vmlinux case (see the comment at lines 105-106 and the runtime
guard at line 199).

This is reachable through the way the fragment is actually being adopted:
two of the three consumers in this series derive BPF_SRCS from a wildcard
whose expansion depends on the working tree - 'BPF_SRCS := $(wildcard
progs/*.c)' (selftests/hid) and 'BPF_SRCS := $(wildcard *.bpf.c)'
(selftests/sched_ext). Any tree where that glob comes back empty (a partial
copy, a directory whose programs were removed or renamed, or a future user
who sets BPF_SRCS from a variable that is not set) turns a
should-be-obvious configuration mistake into an unexplained make failure in
a shared file.

Would a fourth guard next to the existing three, e.g.

    ifeq ($(BPF_SRCS),)
    $(error lib.bpf.mk: BPF_SRCS is empty; set it before including lib.bpf.mk)
    endif

make it self-describing and consistent with the checks immediately above?

> +	$(call msg,GEN-SKEL,,$@)

[ ... ]

> +# Read the header dependencies written by -MMD.
> +-include $(BPF_OBJS:.o=.d)
> +
> +# ---- values for the test Makefile -----------------------------------------
> +# Add paths for generated skeletons and vmlinux.h. Put the new libbpf headers
> +# first so an older copy under BPF_SKEL_DIR cannot be used by mistake.
> +CFLAGS += -I$(INCLUDE_DIR) -I$(OUTPUT) -I$(BPF_SKEL_DIR)

The comment does not describe what the line does, and the stated hazard
cannot occur.

BPF_SKEL_DIR is the directory this fragment writes skeleton headers into -
the only things placed there are *$(BPF_SKEL_EXT) and *$(BPF_SUBSKEL_EXT).
libbpf's headers are installed elsewhere: 'install_headers' in
tools/lib/bpf/Makefile writes only to $(DESTDIR)$(prefix)/include/bpf/,
which with 'DESTDIR=$(SCRATCH_DIR) prefix=' is $(INCLUDE_DIR)/bpf/.
Nothing in this fragment can ever put a libbpf header under BPF_SKEL_DIR,
so there is no stale copy for the ordering to protect against. The ordering
rationale is not inherited from the code being consolidated either -
selftests/bpf/Makefile has the opposite order, '-I$(CURDIR)
-I$(INCLUDE_DIR) ...'.

The comment also explains a two-element ordering while the line adds three
paths, and silently skips the middle one. -I$(OUTPUT) is unexplained and
does no work in either configuration: with the default 'BPF_SKEL_DIR ?=
$(OUTPUT)' it is an exact duplicate of the -I$(BPF_SKEL_DIR) that follows
it, and when a consumer overrides BPF_SKEL_DIR (sched_ext sets
'$(OUTPUT)/build/include') nothing this fragment generates lives in
$(OUTPUT) for it to find.

For a new shared file whose comments are the interface documentation for
future consumers, would it be worth either dropping -I$(OUTPUT) and the
invented rationale, or replacing the comment with the real reason the order
was chosen?

>
> +# Add target zstd when pkg-config finds it. A cross build must use the target
> +# pkg-config, not the host one.

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31820214629
--===============4448923700193765925==--
