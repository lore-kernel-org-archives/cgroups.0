Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D922A43FD18;
	Fri, 11 Sep 2026 07:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789112694; cv=none; b=PtoUwxkj3V/yik3gZshSNVDn1RGQHjes9D/sl8q51T6oByzKijhoxmBVM6ji59Ny3ZhWwsO4oIIGXehu9O0H1Ypj8zHUH5ZwDxHsipJtlAQlXYHPXuVrOdtKw6E0WoVlIdgRas8aQYYHvGiRtx46Yuvip1C9MC9RIj07uVoLmiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789112694; c=relaxed/simple;
	bh=CozpsqKYWbQnFcDTKflFHOpM+sIi6p3fXyPJ3ObzalM=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=qYyKObEXHxx5ls0CR7IvIEZZUwc0LK004bJaExOdR8UICDWXHtdnQP1BpTVGoJqNQYlJoKohyYjtMPYREzuDiu/ixGuyMC599FLaSEXHu7306KJ9BJAMU2qEP8sAioKD95ERGNpxpyVC+1T0qwnb0It7zKpO6thq29/etP0ODpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSh8nXxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSh8nXxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E101F000FF;
	Fri, 11 Sep 2026 07:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789112692;
	bh=JVNsmiGxY1SdhPHsIl79rzqOKs/aP852ofsVaoPTftY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=nSh8nXxfkEr1kUl7cfnHIIf1jZLF1ZnKYJMXAxMWbeex/1I+vA4DWR+URZEpMvHbi
	 Xnd9r+6mji6dWqQ9LCBHTlIGDBmfENwyZi5PoKHpFNaZUjNorCTFH/TTHY/G3I1dA4
	 S7uGU0ykKRHQQVaF4JDhVsKt2auPoAB+6NT3b+aIPD9mvfkjstADVlQH8nTUnqC0r2
	 EwAuj7ZGUOIv8VXmM6rLhTrgeRIR/46HXvJwII9OQYXc9vwQOiXOJmpXzAlsrcDx6V
	 vqfoDjPnSK3T0vArVyKY6JMKGujqewoGn/BM3DPlCS9vZ6WnXsmenQnuYyeu9uaoQT
	 gm0AJS8Tv+A5w==
Content-Type: multipart/mixed; boundary="===============1065213570066958851=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <81d809ef7a590d33ae978b98bb3d830b3cff2ce34a091ab3f4a5f0b977bfdfeb@mail.kernel.org>
In-Reply-To: <20260910233303.1063501-4-ziyang.meme@gmail.com>
References: <20260910233303.1063501-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH v5 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 11 Sep 2026 07:44:50 +0000 (UTC)

--===============1065213570066958851==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
> index 2f423de83147..1190a747036d 100644
> --- a/tools/testing/selftests/hid/Makefile
> +++ b/tools/testing/selftests/hid/Makefile
> @@ -47,7 +47,6 @@ msg =
>  else
>  msg = @printf '  %-8s%s %s%s\n' "$(1)" "$(if $(2), [$(2)])" "$(notdir $(3))" "$(if $(4), $(4))";
>  MAKEFLAGS += --no-print-directory
> -submake_extras := feature_display=0
>  endif

This isn't a bug, but with submake_extras gone, does anything still need
this local msg/MAKEFLAGS block?  lib.mk defines both identically a few
lines below, so it looks like it could be dropped along with the rest of
the copied machinery.

> @@ -58,172 +57,25 @@ override define CLEAN
>  	$(Q)$(RM) -r $(EXTRA_CLEAN)
>  endef
>
> -include ../lib.mk
> -
> -TOOLSDIR := $(top_srcdir)/tools
> -LIBDIR := $(TOOLSDIR)/lib
> -BPFDIR := $(LIBDIR)/bpf
> -TOOLSINCDIR := $(TOOLSDIR)/include
> -BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
> -SCRATCH_DIR := $(OUTPUT)/tools
> -BUILD_DIR := $(SCRATCH_DIR)/build
> -INCLUDE_DIR := $(SCRATCH_DIR)/include
> -BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a

[ ... ]

> +# Build the legacy progs/*.c layout with the shared BPF rules.
> +BPF_SRCS       := $(wildcard progs/*.c)
> +BPF_PROG_EXT   := .c
> +# BPFDIR is defined when this recursive variable is expanded.
> +BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
> +		  $(wildcard $(BPFDIR)/*.bpf.h)
> +

This isn't a bug, but do the two $(BPFDIR) wildcards still match anything
here?  tools/lib/bpf has no hid_bpf_*.h, and lib.bpf.mk's
lib_bpf_header_sources already covers *.bpf.h - if so, this could become
a simple BPF_EXTRA_HDRS := $(wildcard progs/*.h) and lose the
recursive-expansion comment.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34573210499
--===============1065213570066958851==--
