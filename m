Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63F544BCAE;
	Fri, 11 Sep 2026 07:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112697; cv=none; b=fxp8sSI+oT2dUnxcEEXnTTJ3OUfBNbLtxfEgrs6Q1s1cSNDUA6ea/GdtSy2okBoTFs5bvCZriSS6ns8DdhnMy0HOunbTaTBKR4rj4go4858RJM1jsGvkKd5jlsrFF9mlGj9h6IVjjV8OyoP/7qgPkBB7tJFPqoNjaQ9gpnnrMmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112697; c=relaxed/simple;
	bh=F5gWWSNqHxis+mEexCTYx+bQntoGdKudDjdbvc/jjEc=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=o5UjyWRMp4W2mBwjCapVRECE0d8phAXSjuqor/rowUGpK/zJ3h/YCOm+iPfF40+is6v00+rSsOvAptYkZ1TdIjnF+mGt7cvcTuyOiOhsLQJdsP54vq66P9A7TAPP70YOM7Ht3B8ENOC4UJXf5RHzpJjDl3y3ntzhn9qOqtQB8eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IndTzz0q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IndTzz0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6CA1F00893;
	Fri, 11 Sep 2026 07:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789112695;
	bh=OBzZVFee4S2rVGtg6M6II1AeDxf+F8a1EcPtLaDHgSA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=IndTzz0qx5n84yuYFaj0DWuFbXlMNMPU4pRMRYbKWgxyf4TAx2zBq8olTVJsw4s2u
	 T8ETqh0czo2f8KDTWd/deX51MYFDkVdIFO3jrx3+oJdStA6flfctbs8Kow9r290h9/
	 ysBcd4DtTy6jucTnsC9uG3bAlZdzphZM22IDAA+tfNUpb1185+ZTvA0wuTYdkFIDlQ
	 GY+8MTjJh6Sf1yjKHRdxLJRSR4tsXlWw8dXmKWnC+c0hbF7rNeEftF3Q0uYOwSChKD
	 6R3SIFMUrqRBR5DKwf4bY4JCkrXjt16eiRWlwNww199xaYLBMnyK0TdnOyRIMGd5MC
	 z5YYoLKAUXWUw==
Content-Type: multipart/mixed; boundary="===============1662541605359616403=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <c51a056670cea30c7fb85ed0ef80a6be9b7e538196a5ae53cbad3b374db70c2c@mail.kernel.org>
In-Reply-To: <20260910233303.1063501-5-ziyang.meme@gmail.com>
References: <20260910233303.1063501-5-ziyang.meme@gmail.com>
Subject: Re: [PATCH v5 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 11 Sep 2026 07:44:53 +0000 (UTC)

--===============1662541605359616403==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
> index 3cfe90e0f34f..dd3f5594af24 100644
> --- a/tools/testing/selftests/sched_ext/Makefile
> +++ b/tools/testing/selftests/sched_ext/Makefile
> @@ -14,48 +14,29 @@ CURDIR := $(abspath .)
>  REPOROOT := $(abspath ../../../..)
>  TOOLSDIR := $(REPOROOT)/tools
>  LIBDIR := $(TOOLSDIR)/lib
> -BPFDIR := $(LIBDIR)/bpf
>  TOOLSINCDIR := $(TOOLSDIR)/include
> -BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
> -APIDIR := $(TOOLSINCDIR)/uapi
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
> +# Build scheduler skeletons and subskeletons with the shared BPF rules.
> +BPF_SRCS        := $(wildcard *.bpf.c)
> +BPF_SKEL_EXT    := .bpf.skel.h
> +BPF_GEN_SUBSKEL := 1

This isn't a bug, but is anything consuming the generated
*.bpf.subskel.h headers? Grepping the directory for "subskel" matches
only the Makefile itself - no .c or .h file under
tools/testing/selftests/sched_ext/ includes a subskeleton header. The
pre-patch rule generated them too, so this preserves existing behavior,
but the conversion makes the subskeleton an explicit one-line opt-in.
Would dropping BPF_GEN_SUBSKEL be a reasonable follow-up to save a
bpftool run per scheduler?

> +# Preserve the existing build/ layout.
> +BPF_OBJ_DIR  := $(OUTPUT)/build/obj/sched_ext
> +BPF_SKEL_DIR := $(OUTPUT)/build/include
> +SCXOBJ_DIR   := $(BPF_OBJ_DIR)
>
> -BPFTOOL ?= $(DEFAULT_BPFTOOL)
> +include ../lib.bpf.mk

[ ... ]

> @@ -64,102 +45,26 @@ endif
>
>  LDFLAGS = -lelf -lz -lpthread -lzstd

[ ... ]

> +EXTRA_CLEAN += $(OUTPUT)/build
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
> -# allows testcases to load any BPF scheduler, which is useful for testcases
> -# that don't need their own prog to run their test.
> -all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
> +# Build every scheduler before each test.
> +all_test_bpfprogs := $(BPF_SKELS)

This isn't a bug, but since the variable assignment is otherwise a
straight substitution (the foreach expression becomes $(BPF_SKELS)),
would it be worth keeping the original comment wording? The previous
text explained the rationale - "Every testcase takes all of the BPF
progs as dependencies by default. This allows testcases to load any BPF
scheduler, which is useful for testcases that don't need their own prog
to run their test." - while the replacement restates what the following
line does and drops the reason a testcase depends on schedulers it does
not own.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34573210499
--===============1662541605359616403==--
