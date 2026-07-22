Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4C73B993A
	for <cgroups@vger.kernel.org>; Wed, 22 Jul 2026 06:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784703019; cv=none; b=i9eLqLW58cIw9WO2lo/l2dnAB4594q8kiazwldoArnaH71r8ChF5h+E3UL5W8TNQUv7VvSn+NueY53Ku8UXEEE0x75CFScvNMNGLgQc7YVMmjtVwbDUhtLYxjemvQL1SofLUFrCLXIE+jeeAF0IXprXaXHlR2iWF97dW5GQR10Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784703019; c=relaxed/simple;
	bh=W30n+dDFacf9N0Yhym3zvdlZ9DsbgCWqHGjNKOpv9s4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u+hhXPZ3KsUleQTW0t+mbU1oguC3+T+eqsrSz1uy1jO23ExWpt50x5blHyzHEiad7ZOsesp96MaZE5ZpWJojtatidPuKNb8+sh3MQ1Lf3oGvVDbsqxd3uR6HAHWNs2j9FKkcq99e9miaP74A7UjDiZmTZjHO2jDLd74yHniW5P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OjMTxemR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ah2Uq0GS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OjMTxemR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ah2Uq0GS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784703016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lBBnji54QsZ7LpKe0DZFU4BcF1aXn/MPUxyOzixsJo=;
	b=OjMTxemRBkon0I2/+p5AZy1PjE6JB/9K49rm4UC5VXh7jBy/TTmEu5FdCg7UF9TTU+eNoP
	xsucqaX6UTjgsuASVXI9HKmeAyi6j80qlrjUdzsZbyoHkjVZspD/lkrv0flDGJHlEVfqB9
	R9zgRQJQ6ieZxV2DodoNmjau2+0pCXg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-478-4EVX5ON_Pxue1lyYtIMitw-1; Wed, 22 Jul 2026 02:50:12 -0400
X-MC-Unique: 4EVX5ON_Pxue1lyYtIMitw-1
X-Mimecast-MFC-AGG-ID: 4EVX5ON_Pxue1lyYtIMitw_1784703011
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f6d70223dso2791573f8f.1
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 23:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1784703010; x=1785307810; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3lBBnji54QsZ7LpKe0DZFU4BcF1aXn/MPUxyOzixsJo=;
        b=ah2Uq0GS/Msrv0OIG7yt664953CAtt6y1NRjS/o7tr2/W6Y3UA5LKrK9T74hzC5bt6
         hwbD1JLu+HmO9H4XzyqrIih8U6PiBd4soyY/mG4iHr1oTBTGWJcLsWJEkWTVRQvyv/VO
         2SOgMzTBjwhTPdHszuDzxL0YRoKHcYKPgPAkN6EH2Ob+uPBOVYNrqKGsjWRaVC2hwPtK
         BqW5PJKeu9Br/yyP9xIuTsrU+xCgzCw5gg1MHVvFkG8SQf7w4hi3/ArdLL1qLn/rgqVt
         sMq5mGknJZbyic1n8kO/N9MbDDm843czQvQocK/MJNwX+ARgkiLom0xlbpC8YmHWdU8H
         czZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784703010; x=1785307810;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lBBnji54QsZ7LpKe0DZFU4BcF1aXn/MPUxyOzixsJo=;
        b=JD8bey52ekfCX8FHCETkqnGSdvyf1TbqiuuWUopGlb8Uqy/CISsL6yU8JJNKZGjdmC
         yz+YBhq4hGTso2FZN9B3In8mPdCnSCuAKeyaYX7f91FfkSzV1hNmK5zAH4WzP3jLS/XM
         HuHN6ShywHdbhCeurUaptElINXnZWT/SNf0IHLJ6DXs6SvH5ErLOSI5i1adRd+XCHoIU
         SoUD0xRChnlGVGbaqiKfqpRxXQOFVf1tdkobS08GqB+FdSyEgzMNZ2zotbJEMDQAZ0Gk
         ODeX13q6j8QDonmex3HTK7gXKQ9hgzg4ZnpTzPv0/xrZV8Im7Hcl5V6fB1KDEszpiz7L
         z2LA==
X-Forwarded-Encrypted: i=1; AHgh+RoXPkj32Nz37SvXFYB+dfQrbwySu+/4C52InEoxZDx11l0b3Zk7sNnCLtGj9wtlt6fVmc4/5127@vger.kernel.org
X-Gm-Message-State: AOJu0YzSXkmto9K3k6/GCJAEKEAxl1Of+lQ07RbmPQyHDg5XrMD7Egy2
	NcEjwxNp3RZC5fADE63DjjEGVhuq6PByD0tF76aONUgd3pzpBzSYmlDyJBJ+Rt1B0eAq08LbH1f
	wYU8W69fXPZy4t2sjqQVLPK1B/ippCOY2RabXJfg9ycnBBp1/2npOKyUgeg==
X-Gm-Gg: AR+sD11UuFCvwqO4mtBwNJ5jQZt1e4CYbT2+Rxd8AN/Uru/eM71/m4/x0ov3U2COw18
	U7OnykQORLhA1RSgN/E+gp9GQP64yu9f+xx1DUF2pFg9NNzcVbFOMZYTwtpf6tdzAonrzyd7z5r
	DkCSWlyGCUuLPk+TSJHL2j3N2we0fcWVHNMfZIGkaoLJYCM33Hvl9MwJLYpG1kTRlWQaiaPRWAu
	2w8hLto31DfQ67z9C8XmZNSZbNt8ARXn5h5D0TwA+up3dnvZik1LzKQJ+eyIJbhLIB58vg7cJsc
	S8MOwqLugOf8er/t8/bjSKG6V2BwsBhrMG8SxodQ+NlTXFnnbvU3q+ddwkLmsHFg
X-Received: by 2002:a05:600c:3589:b0:495:641a:fffe with SMTP id 5b1f17b1804b1-495641b01acmr102846815e9.39.1784703010356;
        Tue, 21 Jul 2026 23:50:10 -0700 (PDT)
X-Received: by 2002:a05:600c:3589:b0:495:641a:fffe with SMTP id 5b1f17b1804b1-495641b01acmr102846315e9.39.1784703009819;
        Tue, 21 Jul 2026 23:50:09 -0700 (PDT)
Received: from [10.43.17.109] ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653c9d99sm126187325e9.12.2026.07.21.23.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 23:50:09 -0700 (PDT)
Message-ID: <f2a0db3b-ac66-4b29-9dff-a691d9464123@redhat.com>
Date: Wed, 22 Jul 2026 08:50:06 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF
 progs and skeletons
To: Ziyang Men <ziyang.meme@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 David Vernet <void@manifault.com>, Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, JP Kobryn
 <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>,
 Nathan Chancellor <nathan@kernel.org>, linux-kselftest@vger.kernel.org,
 cgroups@vger.kernel.org, linux-input@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm@kvack.org, kernel-team@meta.com,
 bpf@vger.kernel.org, llvm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-2-ziyang.meme@gmail.com>
From: Viktor Malik <vmalik@redhat.com>
Content-Language: en-US
In-Reply-To: <20260721174833.1232771-2-ziyang.meme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/21/26 19:48, Ziyang Men wrote:
> The libbpf + bpftool + vmlinux.h + BPF-object + skeleton build tool-chain
> is currently duplicated across tools/testing/selftests/{bpf,sched_ext,
> hid}/, each carrying ~100-140 lines of near-identical Makefile.  As more
> subsystems grow BPF-based selftests, the duplication scales poorly.
> 
> Add tools/testing/selftests/lib.bpf.mk, a single includable fragment that
> provides the whole chain end-to-end. It builds the in-tree libbpf.a and a
> host bpftool, generates vmlinux.h from the kernel's BTF, compiles *.bpf.c
> into BPF objects (clang --target=bpf) and generates their skeletons. It
> also provides what the user-space test binary needs to build: the header
> search paths (so #includes resolve), a bpf_link macro that wraps the link
> command, and BPF_LDLIBS, so the test can be statically linked against
> libbpf.a.
> 
> To use: set BPF_SRCS and OVERRIDE_TARGETS := 1 before including ../lib.mk
> (so lib.mk's default link rule is suppressed), then include ../lib.bpf.mk
> and list $(BPF_SKELS) as prerequisites of the test binary, e.g.,:
> 
>     BPF_SRCS         := progs/foo.bpf.c
>     OVERRIDE_TARGETS := 1
>     include ../lib.mk
>     include ../lib.bpf.mk
>     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
>             $(call bpf_link,$@,$<)
> 
> This saves much work for configuring selftests in other folder, such the cgroup.
> 
> net/bpf.mk (which only builds *.bpf.o, without skeleton or vmlinux.h
> generation) is left unchanged; replacing the existing duplication
> mentioned above is the next step.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
> Suggested-by: Mykola Lysenko <mykolal@meta.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
> ---
>  tools/testing/selftests/lib.bpf.mk | 247 +++++++++++++++++++++++++++++
>  1 file changed, 247 insertions(+)
>  create mode 100644 tools/testing/selftests/lib.bpf.mk
> 
> diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
> new file mode 100644
> index 000000000000..6f175c6568e9
> --- /dev/null
> +++ b/tools/testing/selftests/lib.bpf.mk
> @@ -0,0 +1,247 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Shared fragment for selftests that compile *.bpf.c into BPF objects +
> +# skeletons and link them into userspace test binaries, without each
> +# subsystem's Makefile re-implementing the libbpf/bpftool/vmlinux.h machinery.
> +#
> +# Caller contract (per-test Makefile):
> +#
> +#     BPF_SRCS         := foo.bpf.c bar.bpf.c
> +#     TEST_GEN_PROGS   := foo_test
> +#     OVERRIDE_TARGETS := 1              # MUST be set before lib.mk
> +#     include ../lib.mk                  # defines OUTPUT, CC, Q, msg,
> +#     include ../lib.bpf.mk              #   selfdir, top_srcdir; honours OVERRIDE
> +#
> +#     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
> +#         $(call bpf_link,$@,$<)
> +#
> +# Optional knobs (set before including lib.bpf.mk):
> +#   BPF_PROG_EXT     - source suffix, default .bpf.c; set to .c for the legacy
> +#                      "progs/foo.c -> foo.bpf.o" layout.
> +#   BPF_EXTRA_HDRS   - extra prerequisites (headers) for the BPF objects.
> +#   BPF_EXTRA_CFLAGS - appended to BPF_CFLAGS for the BPF compile.
> +#   BPF_SKEL_EXT     - skeleton suffix, default .skel.h (e.g. .bpf.skel.h).
> +#   BPF_GEN_SUBSKEL  - if set, also emit a subskeleton next to each skeleton.
> +#   BPF_OBJ_DIR      - dir for generated *.bpf.o (default $(OUTPUT)).
> +#   BPF_SKEL_DIR     - dir for generated skeletons (default $(OUTPUT)).
> +# A caller with unusual compile needs may override BPF_CFLAGS wholesale after
> +# the include (the object recipe expands it lazily).
> +# BPF_SRCS entries may live in a subdirectory (e.g. progs/foo.bpf.c); the
> +# objects and skeletons are always emitted flat under $(OUTPUT), keyed by the
> +# source basename (foo.bpf.o / foo.skel.h).
> +#
> +# lib.mk MUST be included first: this fragment consumes the vars it defines
> +# (OUTPUT, top_srcdir, CC, CLANG, Q, msg) and needs OVERRIDE_TARGETS to have
> +# already suppressed lib.mk's default link rule.
> +
> +include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH
> +# Pull in the shared toolchain definitions (HOSTCC/HOSTLD/CLANG) so this
> +# fragment picks the *same* host compiler the libbpf and bpftool sub-makes
> +# will: in particular HOSTCC becomes clang under LLVM=1 (gcc otherwise).
> +# Without this the host bpftool and its bootstrap libbpf can end up built with
> +# a mix of gcc and clang, which trips clang on gcc-only flags (-Wstrict-aliasing=3).
> +#
> +# Makefile.include's allow-override resets CC to a bare "clang", which would
> +# drop the --target=<arch> flag lib.mk set for LLVM=1 cross builds (make LLVM=1
> +# ARCH=arm64).  lib.mk ran first and configured CC for the target, so save it
> +# across the include and restore it afterwards.
> +lib_bpf_mk_saved_cc := $(CC)
> +include $(top_srcdir)/tools/scripts/Makefile.include
> +CC := $(lib_bpf_mk_saved_cc)
> +
> +CLANG  ?= clang
> +HOSTCC ?= gcc
> +HOSTLD ?= ld
> +ifneq ($(V),1)
> +submake_extras := feature_display=0
> +endif
> +
> +# ---- paths & tools --------------------------------------------------------
> +TOOLSDIR    := $(top_srcdir)/tools
> +LIBDIR      := $(TOOLSDIR)/lib
> +BPFDIR      := $(LIBDIR)/bpf
> +TOOLSINCDIR := $(TOOLSDIR)/include
> +BPFTOOLDIR  := $(TOOLSDIR)/bpf/bpftool
> +APIDIR      := $(TOOLSINCDIR)/uapi
> +
> +# Everything generated lives under $(OUTPUT) so O= and in-tree both work and
> +# per-test builds (distinct $(OUTPUT)) never collide.
> +SCRATCH_DIR := $(OUTPUT)/tools
> +BUILD_DIR   := $(SCRATCH_DIR)/build
> +INCLUDE_DIR := $(SCRATCH_DIR)/include
> +BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
> +
> +# bpftool must run on the *host*; split the host toolchain out when cross-building.
> +ifneq ($(CROSS_COMPILE),)
> +HOST_BUILD_DIR   := $(BUILD_DIR)/host
> +HOST_SCRATCH_DIR := $(OUTPUT)/host-tools
> +else
> +HOST_BUILD_DIR   := $(BUILD_DIR)
> +HOST_SCRATCH_DIR := $(SCRATCH_DIR)
> +endif
> +HOST_BPFOBJ     := $(HOST_BUILD_DIR)/libbpf/libbpf.a
> +DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
> +BPFTOOL         ?= $(DEFAULT_BPFTOOL)
> +
> +# ---- vmlinux BTF discovery -----------------------------------------------
> +VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
> +		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
> +		     $(top_srcdir)/vmlinux				\
> +		     /sys/kernel/btf/vmlinux				\
> +		     /boot/vmlinux-$(shell uname -r)
> +VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> +ifeq ($(VMLINUX_BTF),)
> +$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> +endif
> +
> +# ---- clang flags ----------------------------------------------------------
> +# Clang's default system includes (not the ones seen under --target=bpf); fixes
> +# "missing" asm/byteorder.h etc. '-idirafter' so we never shadow real includes.
> +define get_sys_includes
> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
> +	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
> +endef
> +ifneq ($(CROSS_COMPILE),)
> +CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
> +endif
> +CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
> +
> +IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
> +			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
> +MENDIAN = $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
> +
> +# Prefer -mcpu=v3; fall back to v2 on clang too old to know it (probed once).
> +CLANG_BPF_CPU := $(shell $(CLANG) --target=bpf -mcpu=help 2>&1 | grep -q 'v3' \
> +			 && echo v3 || echo v2)
> +
> +# -fms-extensions + -Wno-microsoft-anon-tag: required so clang accepts the
> +# anonymous nested struct/union members bpftool emits into vmlinux.h.
> +BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
> +	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(TOOLSINCDIR)		\
> +	     -std=gnu11							\
> +	     -fno-strict-aliasing					\
> +	     -fms-extensions -Wno-microsoft-anon-tag			\
> +	     -Wno-compare-distinct-pointer-types			\
> +	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)
> +
> +# $1 = src .bpf.c, $2 = dst .bpf.o
> +define BPF_BUILD_RULE
> +	$(call msg,CLNG-BPF,,$2)
> +	$(Q)$(CLANG) $(BPF_CFLAGS) -O2 --target=bpf -mcpu=$(CLANG_BPF_CPU) -c $1 -o $2
> +endef
> +
> +# ---- output dirs for generated objects/skeletons --------------------------
> +# Default: flat under $(OUTPUT) (what bpf/, hid/, cgroup/ do).  A caller may
> +# segregate the generated files into subdirs, e.g. BPF_SKEL_DIR := $(OUTPUT)/...
> +BPF_OBJ_DIR  ?= $(OUTPUT)
> +BPF_SKEL_DIR ?= $(OUTPUT)
> +
> +# ---- scratch dirs ---------------------------------------------------------
> +MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
> +		    $(HOST_BUILD_DIR)/bpftool $(INCLUDE_DIR)		\
> +		    $(filter-out $(OUTPUT),$(BPF_OBJ_DIR) $(BPF_SKEL_DIR)))
> +$(MAKE_DIRS):
> +	$(call msg,MKDIR,,$@)
> +	$(Q)mkdir -p $@
> +
> +# ---- libbpf (target) ------------------------------------------------------
> +# Pass ARCH/CROSS_COMPILE/CC through: lib.mk's CC is file-origin and is not
> +# exported, so without this the libbpf sub-make would rebuild for the host under
> +# a pure-LLVM cross build (make LLVM=1 ARCH=<arch>).  -fPIC keeps the static
> +# libbpf linkable into position-independent (PIE) test binaries.
> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
> +	   $(APIDIR)/linux/bpf.h | $(BUILD_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
> +		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
> +		    EXTRA_CFLAGS='-g -O0 -fPIC'				      \

Looking at the same line in tools/testing/selftests/bpf/Makefile:

            EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)' \

is there a reason why this is not respected and -O0 and -fPIC are
hard-coded? What if someone wants to build selftests (including libbpf)
with -O2 and some additional flags? Is that possible with the new
lib.bpf.mk? It would be nice if it used at least EXTRA_CFLAGS or
USERCFLAGS defined in lib.mk.

Same questions would apply to other rules for libbpf and bpftool below.

Thanks!
Viktor

> +		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
> +
> +# ---- libbpf (host) -- a distinct rule only when cross-compiling -----------
> +ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
> +$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
> +		| $(HOST_BUILD_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) ARCH= CROSS_COMPILE=	      \
> +		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
> +		    EXTRA_CFLAGS='-g -O0'				      \
> +		    DESTDIR=$(HOST_SCRATCH_DIR) prefix= all install_headers
> +endif
> +
> +# ---- bpftool (host) -------------------------------------------------------
> +$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
> +		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOLDIR)		  \
> +		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
> +		    EXTRA_CFLAGS='-g -O0'			  \
> +		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/		  \
> +		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/	  \
> +		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/		  \
> +		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
> +
> +# ---- vmlinux.h ------------------------------------------------------------
> +$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
> +ifeq ($(VMLINUX_H),)
> +	$(call msg,GEN,,$@)
> +	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> +else
> +	$(call msg,CP,,$@)
> +	$(Q)cp "$(VMLINUX_H)" $@
> +endif
> +
> +# ---- BPF objects + skeletons ---------------------------------------------
> +# Sources may sit in a subdir and use the modern *.bpf.c or the legacy *.c
> +# suffix (BPF_PROG_EXT); objects go in $(BPF_OBJ_DIR) and skeletons in
> +# $(BPF_SKEL_DIR) (both default to $(OUTPUT)), keyed by the source basename.
> +BPF_PROG_EXT ?= .bpf.c
> +bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
> +# The output namespace is flat, so two sources with the same basename would
> +# collapse into one object/skeleton; fail loudly instead of silently dropping.
> +ifneq ($(words $(bpf_stems)),$(words $(sort $(bpf_stems))))
> +$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
> +endif
> +# BPF_SKEL_EXT lets a caller pick the skeleton suffix (default .skel.h; e.g.
> +# .bpf.skel.h).  With BPF_GEN_SUBSKEL set, a matching subskeleton is emitted
> +# alongside (foo.subskel.h / foo.bpf.subskel.h).
> +BPF_SKEL_EXT    ?= .skel.h
> +BPF_SUBSKEL_EXT := $(patsubst %skel.h,%subskel.h,$(BPF_SKEL_EXT))
> +BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(bpf_stems)))
> +BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(bpf_stems)))
> +
> +# Locate the sources wherever the caller keeps them (e.g. progs/).
> +vpath %$(BPF_PROG_EXT) $(sort $(dir $(BPF_SRCS)))
> +
> +$(BPF_OBJS): $(BPF_OBJ_DIR)/%.bpf.o: %$(BPF_PROG_EXT) $(BPF_EXTRA_HDRS) \
> +	     $(wildcard *.bpf.h) $(INCLUDE_DIR)/vmlinux.h | $(BPF_OBJ_DIR) $(BPFOBJ)
> +	$(call BPF_BUILD_RULE,$<,$@)
> +
> +$(BPF_SKELS): $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)
> +	$(call msg,GEN-SKEL,,$@)
> +	$(Q)$(BPFTOOL) gen object $(<:.o=.linked.o) $<
> +	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $@
> +ifneq ($(BPF_GEN_SUBSKEL),)
> +	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $(@:$(BPF_SKEL_EXT)=$(BPF_SUBSKEL_EXT))
> +endif
> +
> +# ---- exports consumed by the caller --------------------------------------
> +# -I$(OUTPUT)/-I$(BPF_SKEL_DIR): so the test .c can #include "foo.skel.h".
> +# -I$(INCLUDE_DIR): so userspace can pull in the generated vmlinux.h if needed.
> +CFLAGS += -I$(OUTPUT) -I$(BPF_SKEL_DIR) -I$(INCLUDE_DIR)
> +
> +# Static libbpf.a first, then its deps. libbpf may pull in zstd (BTF decompress)
> +# only when built against it; link -lzstd only if libzstd is present.
> +BPF_LDLIBS := $(BPFOBJ) -lelf -lz
> +ifneq ($(shell pkg-config --exists libzstd 2>/dev/null && echo y),)
> +BPF_LDLIBS += -lzstd
> +endif
> +
> +TEST_GEN_FILES += $(BPF_OBJS)
> +
> +# Link helper: $1 = output binary, $2 = test .c (skels are the target's deps).
> +define bpf_link
> +	$(call msg,BINARY,,$1)
> +	$(Q)$(CC) $(CFLAGS) $2 $(BPF_LDLIBS) $(LDLIBS) -o $1
> +endef
> +
> +EXTRA_CLEAN += $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)			\
> +	       $(addprefix $(BPF_OBJ_DIR)/,*.bpf.o *.linked.o)		\
> +	       $(addprefix $(BPF_SKEL_DIR)/,*$(BPF_SKEL_EXT) *$(BPF_SUBSKEL_EXT))

