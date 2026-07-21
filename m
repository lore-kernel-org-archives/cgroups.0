Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F97415F12
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 17:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656128; cv=none; b=mLERkUhvZzt29noCJvweukjv7YVhQKEinljdjdAoP2C8ZmTdbJcB8mbYfZ4Q/Ym2q526nNhdpGTH9cv9ywcPGzNGXM7gKzmyeqMHRqF3TSns5j2ZPo4B+ZHTnOkZsk3y2tBYQX3kaatKBarEKFji1MZf7BFISu6rExTHNYVZC40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656128; c=relaxed/simple;
	bh=sRoAOqve++B63kDPpInmDmu+xh4/uy82qPpeQLmoTZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9bnyp+Bi0/DqzwKH4ud5mj/N4WDZ1R/7NwcoGgKz3dFmlJUhGlIJ1oFJg0VJoqxCyMyiD4W3kyCThzusAs966SQCiaV/INvk5lymYw3UZ/qNc51qi221dKK1l1Drlk5axn+TjA686TgCt0UaKv3FuYf8OZk/YKOOp3eAGNmR24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UtUM5tXN; arc=none smtp.client-ip=74.125.227.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UtUM5tXN"
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38de693676dso8209496a91.0
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 10:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784656123; x=1785260923; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jApOwXpBhXqEU1tu6BspXbjxNN8qabGRryStwscMjoo=;
        b=UtUM5tXNxah0MeaB2u4x9Z/b6ueSU8GdalGAbwyRqFFnrNMo43HQAGLjmb2DRAs9UV
         FdYMo75b95znPf4jVK2MxidJyVilzE0xALTBe1xQmCfqHEAxJZb//O0FBK5O/vBlmxd8
         qziNSexSv8AJ4EMEg3D151EarB/I6EWyxvy6RYaZpE3WG9OV8gO2fY767ofBf28YfF3z
         bSnlgbLJYkHCOOR6+15ue9Ds3py+N6IpPOZnY9dUTLpBxyT9+pd4wJrl+tq4wsQkrmHU
         lTXl9iSrZi1qAreQtr+Xf6hPUmes9oA593ITV2ziqt+9e/VegmlXr6ummtq3P5P7C1aW
         L22w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784656123; x=1785260923;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jApOwXpBhXqEU1tu6BspXbjxNN8qabGRryStwscMjoo=;
        b=nRJ0/YLpuGDTk0NyJBu8aV2NN949PDyEk36EQDj8kAAbAs7Qenb6TJVxZNLruN4xiT
         A1rtDmv6L60vqULVqJxHDnHjx6AJo3nLGW6AAlSj9t2VnsYTfNwCy96yEF65Ae8Co669
         uLoUu6i2i+pe3ohU5tuflOn2XwPiPUt4DPR25KpRPfUTKhvduHFiKz6WvmqOSBdd1DMN
         8fYScqzYcBiNewFjH7Ry6O4uvKqZ0WZFbSQPZ/fBdJPfveexZVzKzkrUP4HejG1lsZZF
         nlu6hkrVPLhAHHOxBHBGfPnYz/vDapT+HsSS7sn4olKC/SFwP6A0QIX3GLLEmM3KDr5m
         uFIQ==
X-Forwarded-Encrypted: i=1; AHgh+RqZBNDBGO5T3ooG+432sENBnC7XX/UChN3SS+vtA9gBMOGQrTK82UzHEc0CjIH13+t1NxxmFRIK@vger.kernel.org
X-Gm-Message-State: AOJu0Yyy79WhszHL4ZZWYvOMXsqur28ierTgsvHXC61LVko0A9J8wwt9
	qXiq6oNV/WnmfMEKYl+a/zuAQk7i1OmXXtsFJIZq7jWbaqEbmpwO+x2L
X-Gm-Gg: AR+sD10mHK/LqJ3SmZ5YXlIlvoB7ihTRIunlnHKTgyJwHXb2sR2r/FUZuQy89EenHZF
	qa3I5qSS6e3p13qCGBMSVyNIStZ6dVJfrjuQzxLU8kzJgnIV2795Ltw3gbrlGVGhPawZpB5JgM2
	PP3RyWFVzBeWVvgXaEi5A9rIuLTVMjKSrbEPKhyzN+wSV7nS+aaZOjrEskvplDWSJ7+nlTlXklR
	fBoEks5bVYlABg4oVEXKWOvSKB2gRySVMyOOlUN987tcQIrYEaUCodeccCx4O4EvrjnZh/T9dhE
	cQO91MFPrjiaJqelJphl0a4SdaGbwRWwmxFlcT2eLgtrJOg9NgLkWkFkuPMD6O+JklosYggq3Oi
	r1qk+S9XPJGT4Vb9SrG99ObJBMzI2fhMXqsGlwnkZ8dgkh3XNNJjgqVRvGf8SbX65PgWKbOLP
X-Received: by 2002:a05:6a21:a393:b0:3c3:9251:fe49 with SMTP id adf61e73a8af0-3c3ad972d5bmr20981964637.50.1784656123174;
        Tue, 21 Jul 2026 10:48:43 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:66::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147dc193f8sm2331163eec.1.2026.07.21.10.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:48:42 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ziyang Men <ziyang.meme@gmail.com>
Subject: [PATCH v2 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
Date: Tue, 21 Jul 2026 10:48:32 -0700
Message-ID: <20260721174833.1232771-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260721174833.1232771-1-ziyang.meme@gmail.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

hid carries its own ~150 lines of libbpf + bpftool + vmlinux.h +
BPF-object + skeleton build machinery, copied from selftests/bpf.
Replace it with an include of the shared
tools/testing/selftests/lib.bpf.mk, so that the previous ~150 lines of
BPF build configuration can now be achieved in only ~10 lines.

hid keeps the legacy progs/<name>.c layout, so it sets BPF_PROG_EXT := .c
and passes its shared BPF headers through BPF_EXTRA_HDRS.  It also gains
the fragment's -Wall on the BPF compile, which its old Makefile did not
set; hid.c has a few pre-existing unused locals, so
BPF_EXTRA_CFLAGS := -Wno-unused-variable keeps the previous behaviour
without touching the program source.

The conversion drops two pieces of dead machinery hid had copied from
selftests/bpf: a resolve_btfids build that was never a prerequisite of
any target, and a CLANG_CFLAGS variable that was never passed to any
compile.

No functional change: the generated hid.skel.h public API is
byte-identical before and after, hid_bpf and hidraw are built and linked
the same way, and the folder builds cleanly under both plain make and
LLVM=1.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/hid/Makefile | 182 +++------------------------
 1 file changed, 20 insertions(+), 162 deletions(-)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 2f423de83147..48def484703c 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -58,172 +58,31 @@ override define CLEAN
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 endef
 
-include ../lib.mk
+# The BPF program (progs/hid.c) is compiled into a skeleton by the shared
+# tools/testing/selftests/lib.bpf.mk fragment.  hid keeps the legacy
+# progs/<name>.c layout, so point BPF_PROG_EXT at .c and hand the fragment
+# hid's shared BPF headers as extra prerequisites.  BPF_EXTRA_HDRS is deferred
+# because it references $(BPFDIR), which lib.bpf.mk defines.
+BPF_SRCS       := progs/hid.c
+BPF_PROG_EXT   := .c
+BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
+		  $(wildcard $(BPFDIR)/*.bpf.h)
+# hid.c predates the shared -Wall (hid's old Makefile didn't set it) and has a
+# few unused locals; tolerate that pre-existing warning without touching the
+# program source.
+BPF_EXTRA_CFLAGS := -Wno-unused-variable
 
-TOOLSDIR := $(top_srcdir)/tools
-LIBDIR := $(TOOLSDIR)/lib
-BPFDIR := $(LIBDIR)/bpf
-TOOLSINCDIR := $(TOOLSDIR)/include
-BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
-SCRATCH_DIR := $(OUTPUT)/tools
-BUILD_DIR := $(SCRATCH_DIR)/build
-INCLUDE_DIR := $(SCRATCH_DIR)/include
-BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a
-ifneq ($(CROSS_COMPILE),)
-HOST_BUILD_DIR		:= $(BUILD_DIR)/host
-HOST_SCRATCH_DIR	:= $(OUTPUT)/host-tools
-HOST_INCLUDE_DIR	:= $(HOST_SCRATCH_DIR)/include
-else
-HOST_BUILD_DIR		:= $(BUILD_DIR)
-HOST_SCRATCH_DIR	:= $(SCRATCH_DIR)
-HOST_INCLUDE_DIR	:= $(INCLUDE_DIR)
-endif
-HOST_BPFOBJ := $(HOST_BUILD_DIR)/libbpf/libbpf.a
-RESOLVE_BTFIDS := $(HOST_BUILD_DIR)/resolve_btfids/resolve_btfids
-
-VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
-		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
-		     ../../../../vmlinux				\
-		     /sys/kernel/btf/vmlinux				\
-		     /boot/vmlinux-$(shell uname -r)
-VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
-ifeq ($(VMLINUX_BTF),)
-$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
-endif
+include ../lib.mk
+include ../lib.bpf.mk
 
-# Define simple and short `make test_progs`, `make test_sysctl`, etc targets
-# to build individual tests.
+# Define simple and short `make hid_bpf`, `make hidraw` targets.
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
 # rule for binaries.
 $(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
 
-# sort removes libbpf duplicates when not cross-building
-MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
-	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids	\
-	       $(INCLUDE_DIR))
-$(MAKE_DIRS):
-	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $@
-
-DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
-
-TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
-
-$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(BPFOBJ)
-
-BPFTOOL ?= $(DEFAULT_BPFTOOL)
-$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
-		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
-	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)			       \
-		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) 	       \
-		    EXTRA_CFLAGS='-g -O0'				       \
-		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/			       \
-		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/		       \
-		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/			       \
-		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
-
-$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
-	   | $(BUILD_DIR)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
-		    EXTRA_CFLAGS='-g -O0'				       \
-		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
-
-ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
-$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)		       \
-		| $(HOST_BUILD_DIR)/libbpf
-	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR)                             \
-		    EXTRA_CFLAGS='-g -O0' ARCH= CROSS_COMPILE=		       \
-		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
-		    DESTDIR=$(HOST_SCRATCH_DIR)/ prefix= all install_headers
-endif
-
-$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
-ifeq ($(VMLINUX_H),)
-	$(call msg,GEN,,$@)
-	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
-else
-	$(call msg,CP,,$@)
-	$(Q)cp "$(VMLINUX_H)" $@
-endif
-
-$(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/resolve_btfids	\
-		       $(TOOLSDIR)/bpf/resolve_btfids/main.c	\
-		       $(TOOLSDIR)/lib/rbtree.c			\
-		       $(TOOLSDIR)/lib/zalloc.c			\
-		       $(TOOLSDIR)/lib/string.c			\
-		       $(TOOLSDIR)/lib/ctype.c			\
-		       $(TOOLSDIR)/lib/str_error_r.c
-	$(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids	\
-		CC=$(HOSTCC) LD=$(HOSTLD) AR=$(HOSTAR) \
-		LIBBPF_INCLUDE=$(HOST_INCLUDE_DIR) \
-		OUTPUT=$(HOST_BUILD_DIR)/resolve_btfids/ BPFOBJ=$(HOST_BPFOBJ)
-
-# Get Clang's default includes on this system, as opposed to those seen by
-# '--target=bpf'. This fixes "missing" files on some architectures/distros,
-# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
-#
-# Use '-idirafter': Don't interfere with include mechanics except where the
-# build would have failed anyways.
-define get_sys_includes
-$(shell $(1) -v -E - </dev/null 2>&1 \
-	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
-$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
-endef
-
-# Determine target endianness.
-IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
-			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
-MENDIAN=$(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
-
-CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
-BPF_CFLAGS = -g -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN) 		\
-	     -Wno-microsoft-anon-tag                                    \
-	     -fms-extensions                                            \
-	     -I$(INCLUDE_DIR)
-
-CLANG_CFLAGS = $(CLANG_SYS_INCLUDES) \
-	       -Wno-compare-distinct-pointer-types
-
-# Build BPF object using Clang
-# $1 - input .c file
-# $2 - output .o file
-# $3 - CFLAGS
-define CLANG_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v3 -o $2
-endef
-# Similar to CLANG_BPF_BUILD_RULE, but with disabled alu32
-define CLANG_NOALU32_BPF_BUILD_RULE
-	$(call msg,CLNG-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(CLANG) $3 -O2 --target=bpf -c $1 -mcpu=v2 -o $2
-endef
-# Build BPF object using GCC
-define GCC_BPF_BUILD_RULE
-	$(call msg,GCC-BPF,$(TRUNNER_BINARY),$2)
-	$(Q)$(BPF_GCC) $3 -O2 -c $1 -o $2
-endef
-
-BPF_PROGS_DIR := progs
-BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
-BPF_SRCS := $(notdir $(wildcard $(BPF_PROGS_DIR)/*.c))
-BPF_OBJS := $(patsubst %.c,$(OUTPUT)/%.bpf.o, $(BPF_SRCS))
-BPF_SKELS := $(patsubst %.c,$(OUTPUT)/%.skel.h, $(BPF_SRCS))
-TEST_GEN_FILES += $(BPF_OBJS)
-
-$(BPF_PROGS_DIR)-bpfobjs := y
-$(BPF_OBJS): $(OUTPUT)/%.bpf.o:				\
-	     $(BPF_PROGS_DIR)/%.c			\
-	     $(wildcard $(BPF_PROGS_DIR)/*.h)		\
-	     $(INCLUDE_DIR)/vmlinux.h				\
-	     $(wildcard $(BPFDIR)/hid_bpf_*.h)			\
-	     $(wildcard $(BPFDIR)/*.bpf.h)			\
-	     | $(OUTPUT) $(BPFOBJ)
-	$(call $(BPF_BUILD_RULE),$<,$@, $(BPF_CFLAGS))
-
-$(BPF_SKELS): %.skel.h: %.bpf.o $(BPFTOOL) | $(OUTPUT)
-	$(call msg,GEN-SKEL,$(BINARY),$@)
-	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
-	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked1.o) name $(notdir $(<:.bpf.o=)) > $@
+# Each test binary links against the in-tree static libbpf that lib.bpf.mk
+# built (lib.mk has already prefixed TEST_GEN_PROGS with $(OUTPUT)/).
+$(TEST_GEN_PROGS): $(BPFOBJ)
 
 $(OUTPUT)/%.o: %.c $(BPF_SKELS) hid_common.h
 	$(call msg,CC,,$@)
@@ -233,5 +92,4 @@ $(OUTPUT)/%: $(OUTPUT)/%.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN := $(SCRATCH_DIR) $(HOST_SCRATCH_DIR) feature bpftool	\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32)
+EXTRA_CLEAN += feature bpftool $(addprefix $(OUTPUT)/,*.o no_alu32)
-- 
2.53.0-Meta

