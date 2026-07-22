Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC234BC020;
	Wed, 22 Jul 2026 09:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714203; cv=none; b=PwFkzyZNJ0Te4yLhZsmd5KG1+glDG8tgJawca1Xo014SZxKJtyfVQP3iydjmiZLpCzg6cZMbMWTZ/ilQH6xaUo20eb5kp+WbXoQ0+Nvx/l+Jog5R1OOLE9ZQaAdFQeZTlK1vynem8psiNaavLrUyoMws17wncjZ0Tmwg/z1GDDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714203; c=relaxed/simple;
	bh=qCqgJPnb1PxUj3vAIUc97Jw/ZJZwfxIx8z1tmUOsYTE=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=f2qMXv2bnlSLrtf/Xpd+fic28YN3/TS2zCN/B2uBMKvVIV/XnYX0iwdYdgHw/o5aXxRQnn0h10zWmejjlQLnuLMg8+dXdi44WkQH0kKgm4yxRH5YNNikT4L+Vdg4zbNrmVRL+noIykYYWw9bIwUzkkviht/pe2/FZIxXpZ3bo4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iTTuEnUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iTTuEnUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842D71F00A3D;
	Wed, 22 Jul 2026 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784714199;
	bh=2UKinxtwpUhNzmCHSNfCxB0o/RysIEhOfeODCNlOPoo=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=iTTuEnUKQW7C4i55BdkYOSG2Awg+qdtvweW4/rglmXgra31Eu+PM6mPv/cht4UWFk
	 fLrjFvUrnn1wqgTk6wnnrN93sXSi3+UffEfcG3KILa8CLmML82j0oCAM/KHWuDt1bl
	 sYpXlT+DrNmidRHMyJDMpwaFQyr+DkigbsumgMPOAv+WQ26Fqe5qBmPMtzV7ihzoIJ
	 uXznuCuGQxaKAbAmgZFgLhYEUIMK3a7sMSzPALT0Sm74HXS0RvxY6QmJ92ju59MN17
	 unSXjen5rxZCe+xajZDk4GmGgueRR1Js5Wcer9bDa0Fl1luJCxMNLfTAa0O/2+yako
	 LSAUkAc4Vlg6w==
Content-Type: multipart/mixed; boundary="===============2757309040262801300=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <1358b841fb4669aa04fcb84247b91c74dfc8f4749f665f5c2a058d6c2bb17640@mail.kernel.org>
In-Reply-To: <20260721174833.1232771-2-ziyang.meme@gmail.com>
References: <20260721174833.1232771-2-ziyang.meme@gmail.com>
Subject: Re: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF progs and skeletons
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,kernel-team@meta.com,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ziyang.meme@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 22 Jul 2026 09:56:37 +0000 (UTC)

--===============2757309040262801300==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
> new file mode 100644
> index 000000000000..6f175c6568e9
> --- /dev/null
> +++ b/tools/testing/selftests/lib.bpf.mk

[ ... ]

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
> +		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers

This rule hardcodes EXTRA_CFLAGS='-g -O0 -fPIC' for the libbpf sub-make.
tools/testing/selftests/bpf/Makefile instead passes
EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)'.

With -O0 pinned here, is there a way for someone to build the selftests
(including libbpf) with -O2, or with sanitizer flags?  Could this at least
honor the EXTRA_CFLAGS or USERCFLAGS that lib.mk already defines?

The same hardcoding shows up in the host libbpf and host bpftool rules
below, so the same question applies to them:

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

[ ... ]

On the commit message:

>     This saves much work for configuring selftests in other folder, such the cgroup.

This isn't a bug, but could this sentence be tightened?  "in other
folder" and "such the cgroup" read a little awkwardly, and the preceding
text already explains the deduplication rationale.  Perhaps something like
"This eases adding BPF-based selftests in other directories, such as
cgroup."


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/29908293077
--===============2757309040262801300==--
