Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A912852BE27
	for <cgroups@vger.kernel.org>; Tue,  8 Sep 2026 23:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788911786; cv=none; b=O6tofaAtJi3YKYX/j3kTB3768S5j6a6jE4Ls+2ndeP9mWr1YMQ1udEvAqk9pmmV64ShxVPppex9Iq/K3f2cGD+F1CKgWM12WBWNNJp6GcKJigRz641aYmW876vshfwK3x/g7k5L/OMmRbAgu2lcLxq8ky1+etC7/+fA+Co11+Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788911786; c=relaxed/simple;
	bh=CFZl7E/T7hsA/mKXCg0BES3xc8sd+pvX6iOVoxrDtns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGE6ATp4Gn9obnXzE0r54PJ4/voc2q6XFFie8Kk1pLADHVZliKNNLT/RG0dYuMeRL6toMZTGBz8ERhFuWMrMdltQ3ImdBaxCQn3LJhdufdIgeUqS0nkE8ctOqUScmg2YF1QgpGDuJ17YjqxTZg0JqQT5817Egy5HgJsM8cUHTI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fv0QZ7Gt; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fv0QZ7Gt"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc1c7364550so5396625a12.1
        for <cgroups@vger.kernel.org>; Tue, 08 Sep 2026 16:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788911780; x=1789516580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
        b=fv0QZ7Gt8evEAX/OY14YgpeYqtYz49CA1VvL/uodQFZkVQo/FHYmApvWYvmbECo3gS
         wbHNLhMmZjomJ9PZKy+cZvLGSmugVMP1qAl8vtDiNuVtzkOgR1xn8JLD/G7nA0WiBGHY
         sNrsXwjFkRVTm5dM/uZptdakzVYDQzd6oNqFK8DtXk9cmFLcnEiPaypubjJGCQxBw3vs
         SGpeL9fsagzMo3xnufg6UPF+UFJHJ2w5G7FRccbWQcNfqnhrwcARqD3S5Ec/su4kUpYP
         TrdEjdcDjHUl2uC/nPTlA2caBt5M66sxX+ZH6bhTT5CiN4d1p+UgrIqFgyYkKTnnlYHI
         HMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788911780; x=1789516580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zd2gkMuIc1TcNe9YCvTi4dDIYFUJcR5yO2iE7XwTG+I=;
        b=nCohXzjF8YC1BdqLDXpIioVrI+s0IajXh3y1hGR+ZuaJ3ZLCXcQG9IqyM1e7W7cplh
         dHOahCe+6C7Zurdp40zxmixHLQy/ljlr2iJRaDLHd/nDXeBVPWXyDnI8wa4nxobtnPTJ
         X9L1B/BqCJ9l5EMSQek2fbNv3ewq3rFKkJ8rY3h0n0QS/GfsIgVMxzuZ2QdQppVUiEmp
         xKTZxfXJxzNKTPLsX4rANi6N5PMc4qOVZVawHX/cTn/txPb9ytOikLtn89vu8K1wg2yf
         waKARHDH3WNcWTfs4MXMAmS/AyHGPK6zj8qrQA0rbO9J1+rBfz5Liv5vIe2G8/vHZ79U
         JMRQ==
X-Forwarded-Encrypted: i=1; AKwUvBz3rmTmIxuXHvRkDFLOtNpeyMUtFVbl2f2B/7s1b5nUSp7CVPdw1vn0hJpgrjGYMRviT21p6A0S@vger.kernel.org
X-Gm-Message-State: AFuF++kE6PjZxenNqLcAr6JrtpFGQJeDAnK6VuSzMmwI02AXcJAgyUa7
	xIO12yOlKnRMA/WKDCUxpevF3o6BaZZlnf2gSxS1OpVx90NfUIsXTgGV
X-Gm-Gg: AYBFou08wQFd55jj+OJ4VgqbwVFHrlrpVHMH97LvDMkKkGf/6t/uUMbKMR5bPJdsS41
	BbOzDZm0Lv64Zyt+yeSgdG1egZ8NNEKGtjRrM7pnT25+JjKBfeN/aGOo5GOXSkbTCMsoe/mQczi
	W5yUm3os8caWQw5IHl2Eqbr+GZHxutgCK6Xv80YwYl7N2kkH+aFjXhKr6OKJ3W/1gtEbxJl8FXn
	9sW/8t6GF6+fs10InmpsPAVTa9vond15MpD6I4psqmhRRZDokR0WcOK8W60gMXuEdHJxFRqkWTD
	W19OF0st7b/HH0Wi49GT755eCtZZ20UdoPwyWeJQdh8P0r0iFkSjBA7300p/y3BuNDNJGeFEdZw
	vJmdGJ5ucz+Ya593Zv7rNoUsP1c8UrOTGM4DW6qCZQi5aFw7oRApXJJpQB8DIdmARGmTeDZpsMp
	cssAzQtwjMfcBLalEFRGvaPIyn7E2zJVG8V8ShpyZNQSKRLUOlw9kVh7sL+BTBBHleXg==
X-Received: by 2002:a05:6a21:a38b:b0:3d0:9164:98a7 with SMTP id adf61e73a8af0-3da39e830b7mr51255235637.11.1788911780383;
        Tue, 08 Sep 2026 16:56:20 -0700 (PDT)
Received: from localhost ([2a03:2880:9ff:60::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33825669695sm16122237eec.3.2026.09.08.16.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 16:56:19 -0700 (PDT)
From: Ziyang Men <ziyang.meme@gmail.com>
To: Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>
Cc: Viktor Malik <vmalik@redhat.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Ziyang Men <ziyang.meme@gmail.com>,
	kernel-team@meta.com,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-input@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
Date: Tue,  8 Sep 2026 16:55:51 -0700
Message-ID: <20260908235552.2610256-4-ziyang.meme@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260908235552.2610256-1-ziyang.meme@gmail.com>
References: <20260908235552.2610256-1-ziyang.meme@gmail.com>
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

The generated hid.skel.h public API remains byte-identical, and hid_bpf
and hidraw are linked the same way.  The shared fragment also supplies
the common warning, language, system-include and adaptive BPF CPU flags.
Remove four unused locals so hid.c builds with that warning set without a
directory-wide suppression.

Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Suggested-by: Mykola Lysenko <mykolal@meta.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
---
 tools/testing/selftests/hid/.gitignore  |   1 +
 tools/testing/selftests/hid/Makefile    | 179 ++----------------------
 tools/testing/selftests/hid/progs/hid.c |   7 +-
 3 files changed, 19 insertions(+), 168 deletions(-)

diff --git a/tools/testing/selftests/hid/.gitignore b/tools/testing/selftests/hid/.gitignore
index 933f483815b2..69943301dc1d 100644
--- a/tools/testing/selftests/hid/.gitignore
+++ b/tools/testing/selftests/hid/.gitignore
@@ -1,5 +1,6 @@
 bpftool
 *.skel.h
+*.bpf.d
 /host-tools
 /tools
 hid_bpf
diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 2f423de83147..1190a747036d 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -47,7 +47,6 @@ msg =
 else
 msg = @printf '  %-8s%s %s%s\n' "$(1)" "$(if $(2), [$(2)])" "$(notdir $(3))" "$(if $(4), $(4))";
 MAKEFLAGS += --no-print-directory
-submake_extras := feature_display=0
 endif
 
 # override lib.mk's default rules
@@ -58,172 +57,25 @@ override define CLEAN
 	$(Q)$(RM) -r $(EXTRA_CLEAN)
 endef
 
-include ../lib.mk
-
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
-
-# Define simple and short `make test_progs`, `make test_sysctl`, etc targets
-# to build individual tests.
-# NOTE: Semicolon at the end is critical to override lib.mk's default static
-# rule for binaries.
-$(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
-
-# sort removes libbpf duplicates when not cross-building
-MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
-	       $(HOST_BUILD_DIR)/bpftool $(HOST_BUILD_DIR)/resolve_btfids	\
-	       $(INCLUDE_DIR))
-$(MAKE_DIRS):
-	$(call msg,MKDIR,,$@)
-	$(Q)mkdir -p $@
+# Build the legacy progs/*.c layout with the shared BPF rules.
+BPF_SRCS       := $(wildcard progs/*.c)
+BPF_PROG_EXT   := .c
+# BPFDIR is defined when this recursive variable is expanded.
+BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
+		  $(wildcard $(BPFDIR)/*.bpf.h)
 
-DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
+include ../lib.mk
+include ../lib.bpf.mk
 
+# Preserve the existing install list.
+TEST_GEN_FILES += $(BPF_OBJS)
 TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
 
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
+# Keep aliases such as "make hid_bpf" from matching lib.mk's binary rule.
+$(notdir $(TEST_GEN_PROGS)): %: $(OUTPUT)/% ;
 
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
+# Relink tests when the in-tree libbpf changes.
+$(TEST_GEN_PROGS): $(BPFOBJ)
 
 $(OUTPUT)/%.o: %.c $(BPF_SKELS) hid_common.h
 	$(call msg,CC,,$@)
@@ -233,5 +85,4 @@ $(OUTPUT)/%: $(OUTPUT)/%.o
 	$(call msg,BINARY,,$@)
 	$(Q)$(LINK.c) $^ $(LDLIBS) -o $@
 
-EXTRA_CLEAN := $(SCRATCH_DIR) $(HOST_SCRATCH_DIR) feature bpftool	\
-	$(addprefix $(OUTPUT)/,*.o *.skel.h no_alu32)
+EXTRA_CLEAN += $(OUTPUT)/*.o
diff --git a/tools/testing/selftests/hid/progs/hid.c b/tools/testing/selftests/hid/progs/hid.c
index b21fbb13c926..ec734e18d23a 100644
--- a/tools/testing/selftests/hid/progs/hid.c
+++ b/tools/testing/selftests/hid/progs/hid.c
@@ -111,7 +111,7 @@ int hid_user_raw_request(struct hid_hw_request_syscall_args *args)
 {
 	struct hid_bpf_ctx *ctx;
 	const size_t size = args->size;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (size > sizeof(args->data))
 		return -7; /* -E2BIG */
@@ -137,7 +137,7 @@ int hid_user_output_report(struct hid_hw_request_syscall_args *args)
 {
 	struct hid_bpf_ctx *ctx;
 	const size_t size = args->size;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (size > sizeof(args->data))
 		return -7; /* -E2BIG */
@@ -161,7 +161,7 @@ int hid_user_input_report(struct hid_hw_request_syscall_args *args)
 {
 	struct hid_bpf_ctx *ctx;
 	const size_t size = args->size;
-	int i, ret = 0;
+	int ret = 0;
 
 	if (size > sizeof(args->data))
 		return -7; /* -E2BIG */
@@ -417,7 +417,6 @@ SEC("?struct_ops.s/hid_hw_output_report")
 int BPF_PROG(hid_test_hidraw_output_report, struct hid_bpf_ctx *hctx, __u64 source)
 {
 	__u8 *data = hid_bpf_get_data(hctx, 0 /* offset */, 3 /* size */);
-	int ret;
 
 	if (!data)
 		return 0; /* EPERM check */
-- 
2.53.0-Meta

