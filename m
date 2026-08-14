Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D3A4908C9;
	Fri, 14 Aug 2026 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786727115; cv=none; b=kXhg8oUKbenIt7vCKveifvnAyUbyW15HWME7zN9nHeqcINZflMp5Gu+NVzoLjfy36C86Pj4gp61Zmtw4RzFkf1lOS3Nsm1WGtJwgyE7zBjp0nsw1oTorNJ4yxFia9ougqNJOJtzoVzwD+lBtaciC9coedU5paH5jIzwtyqthWJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786727115; c=relaxed/simple;
	bh=6cKee+4bgf6gp2FRs4ttpp0+QLTW27WA6IEw4JzOP20=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=T+CjYOAo/bE3126LulBtbii//y+N6NjHdVqEvTUis6tlRHWYUkjcPWYDKhmFxSENLe+298S1qk16SXOd0kuKg3rlI9W4fop4meB59F689m3pfjPDNQuvdWs0ziPEwZLS0Go218upA/LJo1Z2ZHxqfVI3d9lkanqPX1Ts/hGrEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmbZodsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmbZodsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D351F00A3A;
	Fri, 14 Aug 2026 17:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786727113;
	bh=nTcDVPb9lc0nxETTOrYdaxHGm4RZ3gRaGaYQ2F0hvPE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TmbZodsjt9oMaWZBMu0XySo46nKHdB1ITiU3ozRdXsJZy+evrN4Y9Hk8w9qYcQEJL
	 1mJITTo3mhPAfmql+Z1h/kmJyoege82jjuv7PAoHgwGLSQB3R5XJAYTtMYlmljEUa+
	 rm692nVl54BOJhZ1QqasYHf6dOYA3QtkDicqSOuydT547RbTpEIhaUPMnUEMuPmV6I
	 X4/1N0wPody7SndkO6SpjTBACTs1ORupSXV3ncyp8Q9yP4x/9ho8wcnTijabuXKCCb
	 8qm/tJba6RWOVNwHcFOxxVfNr925Pw9TofbxwZOwFHAZZsBtojcXNx938RV7hnb9Dx
	 YTpX71qDalB+w==
Content-Type: multipart/mixed; boundary="===============2223739720343807470=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <516ec49a2bff8ffb9142aa02957bcea1ade0398a778eadd1c9277a83782407b4@mail.kernel.org>
In-Reply-To: <20260814075054.507089-5-ziyang.meme@gmail.com>
References: <20260814075054.507089-5-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 14 Aug 2026 17:05:12 +0000 (UTC)

--===============2223739720343807470==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
> index 3cfe90e0f34f..a2df47b300d0 100644
> --- a/tools/testing/selftests/sched_ext/Makefile
> +++ b/tools/testing/selftests/sched_ext/Makefile
> @@ -14,48 +14,32 @@ CURDIR := $(abspath .)
>  REPOROOT := $(abspath ../../../..)
>  TOOLSDIR := $(REPOROOT)/tools
>  LIBDIR := $(TOOLSDIR)/lib
> -BPFDIR := $(LIBDIR)/bpf
>  TOOLSINCDIR := $(TOOLSDIR)/include
> -BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
>  APIDIR := $(TOOLSINCDIR)/uapi
>  GENDIR := $(REPOROOT)/include/generated
>  GENHDR := $(GENDIR)/autoconf.h
> -SCXTOOLSDIR := $(TOOLSDIR)/sched_ext
>  SCXTOOLSINCDIR := $(TOOLSDIR)/sched_ext/include
>
> -OUTPUT_DIR := $(OUTPUT)/build
> -OBJ_DIR := $(OUTPUT_DIR)/obj
> -INCLUDE_DIR := $(OUTPUT_DIR)/include
> -BPFOBJ_DIR := $(OBJ_DIR)/libbpf
> -SCXOBJ_DIR := $(OBJ_DIR)/sched_ext
> -BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
> -LIBBPF_OUTPUT := $(OBJ_DIR)/libbpf/libbpf.a
> -
> -DEFAULT_BPFTOOL := $(OUTPUT_DIR)/host/sbin/bpftool
> -HOST_OBJ_DIR := $(OBJ_DIR)/host/bpftool
> -HOST_LIBBPF_OUTPUT := $(OBJ_DIR)/host/libbpf/
> -HOST_LIBBPF_DESTDIR := $(OUTPUT_DIR)/host/
> -HOST_DESTDIR := $(OUTPUT_DIR)/host/
> -
> -VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)					\
> -		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)		\
> -		     ../../../../vmlinux					\
> -		     /sys/kernel/btf/vmlinux					\
> -		     /boot/vmlinux-$(shell uname -r)
> -VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> -ifeq ($(VMLINUX_BTF),)
> -$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> -endif
> +# The schedulers are built by ../lib.bpf.mk: modern *.bpf.c layout, a
> +# .bpf.skel.h suffix, and subskeletons.
> +BPF_SRCS        := $(wildcard *.bpf.c)
> +BPF_SKEL_EXT    := .bpf.skel.h
> +BPF_GEN_SUBSKEL := 1
> +# Keep the generated files under build/ as before.  SCXOBJ_DIR (userspace
> +# objects) reuses the BPF object dir.
> +BPF_OBJ_DIR  := $(OUTPUT)/build/obj/sched_ext
> +BPF_SKEL_DIR := $(OUTPUT)/build/include
> +SCXOBJ_DIR   := $(BPF_OBJ_DIR)

The comment says generated files stay 'under build/ as before', but only
two of the five generated-output locations do. lib.bpf.mk hardcodes its own
scratch tree from $(OUTPUT):

tools/testing/selftests/lib.bpf.mk defines:
  SCRATCH_DIR := $(OUTPUT)/tools
  BUILD_DIR   := $(SCRATCH_DIR)/build
  INCLUDE_DIR := $(SCRATCH_DIR)/include
  BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
  HOST_SCRATCH_DIR := $(OUTPUT)/host-tools
  DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool

So relative to the pre-conversion layout:

  build/obj/sched_ext/         BPF + userspace objects   unchanged
  build/include/               skeletons and subskeletons unchanged
  build/obj/libbpf/libbpf.a -> tools/build/libbpf/libbpf.a       moved out
  build/include/vmlinux.h   -> tools/include/vmlinux.h           moved out
  build/include/bpf/*.h     -> tools/include/bpf/*.h             moved out
  build/host/sbin/bpftool   -> tools/sbin/bpftool or host-tools/sbin/bpftool

The layout change itself is fine and is not a leak: lib.bpf.mk already adds
$(SCRATCH_DIR) and $(HOST_SCRATCH_DIR) to EXTRA_CLEAN, so 'make clean'
still removes everything the deleted 'override define CLEAN' used to
remove.

Could the comment be more precise by naming what actually stays put, namely
the BPF objects and the skeleton headers?

[ ... ]

>
>  ################
>  # C schedulers #
>  ################
>
> -override define CLEAN
> -	rm -rf $(OUTPUT_DIR)
> -	rm -f $(TEST_GEN_PROGS)
> -endef
> -
> -# Every testcase takes all of the BPF progs are dependencies by default. This
> +# Every testcase takes all of the BPF progs as dependencies by default. This

[ ... ]

>
>  .DEFAULT_GOAL := all


Separately, the commit message states:

>     sched_ext carried its own ~130 lines of libbpf + bpftool + vmlinux.h +
>     BPF-object + skeleton build machinery.  Replace it with an include of the
>     shared tools/testing/selftests/lib.bpf.mk, making sched_ext the third
>     in-tree consumer of that fragment, after selftests/cgroup and
>     selftests/hid.
>
>     All 28 skeletons and 28 subskeletons keep a same public API before and
>     after, the runner builds and links the same way.

The '28 skeletons and 28 subskeletons' count looks off. The directory holds
29 BPF sources at this commit, so the conversion generates 29 skeletons and
29 subskeletons, not 28:

  $ git ls-tree --name-only f71f601c6ade:tools/testing/selftests/sched_ext \
      | grep '\.bpf\.c$' | wc -l
  29

Both the old wildcard rule and the new BPF_SRCS enumerate the same 29 files,
and the skeleton rule emits one .bpf.skel.h plus one .bpf.subskel.h per
file. The two easy-to-miss sources are maybe_null_fail_dsp.bpf.c and
maybe_null_fail_yld.bpf.c, which have no matching userspace .c file and so
do not appear in auto-test-targets. A count taken from the test list rather
than from *.bpf.c comes out one or two short.

Should this read '29 skeletons and 29 subskeletons'? Also, the same sentence
reads oddly: 'keep a same public API' should be 'keep the same public API',
and the two clauses after it look like a comma splice.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31820214629
--===============2223739720343807470==--
