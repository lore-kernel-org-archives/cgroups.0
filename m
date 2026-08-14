Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C9F47254A;
	Fri, 14 Aug 2026 17:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786727112; cv=none; b=E6PHKzOcrDl8Ny33QEVfIb1KIMHvF+gYQY/fZ7V6Rjl7iYrGTJgLpIWwxjGOr4qfLXKeM5QPX1VB0M/mSiOTh6xoUNhVx1NSS94mFYTDebRgPCibJ+nfM3YjaZXMdWafdAF5Zknq9F9DzfzTKi0opTUpi0jD4hbbNFocBAK4/nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786727112; c=relaxed/simple;
	bh=hmk5DMYYPmU0hVlqz0ianL+11xxxbuG8IpeYoMizpfc=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=i51n+oajP7kNHmIkJJ4awp6lIJuf/o0bg+nMrqjPHPFBylJ2g95PSBimgUGJ8v4HS9bDfd2wlcbVGvQxEui3mgSpoY2Jq31AmAVQmEHh/Oehi92JbYU+ULcCG+wMEJLdAZ2dhXaChREWbQ0fJzwFV1Qlg7v3L35FPBm+CLId2FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebwNvCqU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebwNvCqU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E461F000E9;
	Fri, 14 Aug 2026 17:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786727111;
	bh=X/oq0HBoJMRapoD7XWtIdy5xy+Ds8RrmKGd6Lc/Pysc=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=ebwNvCqUju/eAaqKWY2V19wi/U9Lgt/o8wQot0+G2TbFHEvlXiLg0BCdU9eT+x79Y
	 YyWDrqJD1bqXn15z4tYiP2yWmfOxFMSrwUCq+0KgINHhXxRzNnMatX0TyRRB+EVWr3
	 +RDRwR8uLF1gVT4ee1tcNIxVuuzuMdm3Vkn98rX6Y4j/P1eHQqd9CCAgDe0LDC9NXc
	 6Mb8UdJT55rfklnAnJd9Y0Bc78PiZi6kd65v64/v27mEyX429i9ys+xvoeva0cmCrh
	 8iLtVm32WSB26NoDgxdTTWuqNbB89txZW4zVjbp+DF6FIe2oq9B2BC2FxY7CrfVDUK
	 Tg2xmyIrwXcGA==
Content-Type: multipart/mixed; boundary="===============3060449598212239265=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <a13e1c45f40c04350b700e6b2ad5bae5dc72c8402ec59b0edbfb7907e90ca13e@mail.kernel.org>
In-Reply-To: <20260814075054.507089-4-ziyang.meme@gmail.com>
References: <20260814075054.507089-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 14 Aug 2026 17:05:09 +0000 (UTC)

--===============3060449598212239265==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> The generated hid.skel.h public API is same before and after, hid_bpf
> and hidraw are built and linked the same way.

This isn't a bug, but could the changelog mention that the BPF compile
flags change with the shared fragment (added -Wall/-std=gnu11/
-fno-strict-aliasing, added include paths, auto-detected -mcpu instead
of a hardcoded v3) rather than describing the build as unchanged?

The flags used to compile progs/hid.c do change: the shared BPF_CFLAGS
add -Wall, -std=gnu11, -fno-strict-aliasing, -I$(APIDIR)
-I$(TOOLSINCDIR) and the clang system-include set (which the old
Makefile computed into CLANG_SYS_INCLUDES but never passed), and -mcpu
becomes auto-detected (v3/v2) instead of hardcoded -mcpu=v3. The
-Wno-unused-variable line the patch has to add is direct evidence that
the compile flags are not identical.

> diff --git a/tools/testing/selftests/hid/.gitignore b/tools/testing/selftests/hid/.gitignore

[ ... ]

> diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
> index 2f423de83147..1d7c64ec992c 100644
> --- a/tools/testing/selftests/hid/Makefile
> +++ b/tools/testing/selftests/hid/Makefile

[ ... ]

> +# progs/hid.c is built into a skeleton by ../lib.bpf.mk.  hid keeps the legacy
> +# progs/<name>.c layout, hence BPF_PROG_EXT.  BPF_EXTRA_HDRS is deferred: it
> +# uses $(BPFDIR), which lib.bpf.mk defines.
> +BPF_SRCS       := $(wildcard progs/*.c)
> +BPF_PROG_EXT   := .c
> +BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
> +		  $(wildcard $(BPFDIR)/*.bpf.h)
> +# hid.c predates the shared -Wall and has a few unused locals.
> +BPF_EXTRA_CFLAGS := -Wno-unused-variable

This isn't a bug, but would dropping the four unused locals in
progs/hid.c (the `int i` in the three hid_user_* syscall programs and
the unused `int ret` in hid_test_hidraw_output_report) let this
directory build without the -Wno-unused-variable override?

The shared lib.bpf.mk compiles BPF objects with -Wall -Werror, and this
patch reacts by permanently disabling -Wunused-variable for every BPF
program in this directory. The trigger is exactly four dead locals:
`int i` in hid_user_raw_request(), hid_user_output_report() and
hid_user_input_report(), plus an `int ret;` in
hid_test_hidraw_output_report() that is never assigned or read.
Deleting those four declarations would let the directory build with the
shared warning set unmodified, and would keep the suppression from
silently hiding unused locals in BPF programs added here later.

[ ... ]

> +EXTRA_CLEAN += feature bpftool $(addprefix $(OUTPUT)/,*.o no_alu32)

This isn't a bug, but since the no_alu32 build rule goes away in this
patch, is the `no_alu32` (and `feature`) entry in EXTRA_CLEAN still
needed, or could this line shrink to just `$(OUTPUT)/*.o`?

The rewritten EXTRA_CLEAN keeps the `no_alu32` entry, but this patch
removes the only thing that could ever have produced such an artifact:
the CLANG_NOALU32_BPF_BUILD_RULE definition (and hid never had the
selftests/bpf per-flavor subdirectory machinery that creates a
no_alu32/ tree in the first place). Now that the flavor rule is gone,
nothing in this directory can create $(OUTPUT)/no_alu32. The `feature`
entry is in a similar position - libbpf/bpftool feature-detection
output lands under $(BUILD_DIR)/libbpf/, which is already covered by
the $(SCRATCH_DIR) entry that lib.bpf.mk adds.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31820214629
--===============3060449598212239265==--
