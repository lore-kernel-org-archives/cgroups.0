Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABE338B7BB;
	Sat,  4 Jul 2026 05:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783144705; cv=none; b=bolGQlWJ7zw/u0e+vkiy6TEEOl0EHTL7UpAxg9EmS2GLIeWELTLRz1SCeciTLhZT8qAUNY8FHbqb3OVRaj/LBI1DcdrU0zErZQPRclpNFHumS4+IKfwPidOJadi7FfeX1ZLn2IpZ+pGF+wvI7WnyjdB5xP554SlmNuSNvdHuhmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783144705; c=relaxed/simple;
	bh=hOn6we4RfMiN12EwAa+NNmEUJkAWQI4gee4tcRfPRxA=;
	h=Content-Type:MIME-Version:Message-Id:In-Reply-To:References:
	 Subject:From:To:Cc:Date; b=fcQn7+HCgwsb7BeugnmL5tgK3u6jlH/KX5bf+0AHUs4zHvoADA9GNWfskASTRv2FZT98pQYhYuP2n3BusCM1RuI1lUTts1cWKcFG5yJuRp/5zKDx3Wb/ztOwpgTunIMnn2JBawnHrdtPXdxn/u0Q98PAMZsSmc6k38GRuNT6/+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XYFOk2kT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XYFOk2kT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5E41F000E9;
	Sat,  4 Jul 2026 05:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783144703;
	bh=V83zC+ABVvPZfpSItIVfm+fybD7L3iVSBZB+nvmmqYw=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=XYFOk2kTGPelgRFBCFOy1e5BFq8MR3j2nf5Ucpe7/CKek5scCr344MHbsGfXFuNmW
	 SM7L6Nm0FhGYcdqcF8sq95YTmN0Jhh+1bvL01+d4I8L3OqZb4nzcM0a44QZmuUkEqK
	 GL49THk2qh/CLM2VQDUspnlQBGKR/fve39dyxR7GqFTAptP9L5MO2Hq3rvvtkOWVZb
	 Tn2Lg0iLNmYHqqjLDR/XddQRkS9/G3DRPLcAYbxwcsrcrXuPBWPj2upPA87MZvt0mG
	 oG8Ag4kev34nRzv78qXAbeBSXty8O5zELZDATZ+bH8paUbrgk/ra1kgfGxNbJW11hx
	 muNf0rKM83uCw==
Content-Type: multipart/mixed; boundary="===============8802271696774654361=="
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <c48aa4a4b43fe15d313761d70e2113405c73ad058911cd87d573946ae1740b9e@mail.kernel.org>
In-Reply-To: <20260704045617.487664-4-ziyang.meme@gmail.com>
References: <20260704045617.487664-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH 3/3] selftests/bpf: add memcg_stat_churn_percpu BPF-vs-memory.stat benchmark under cross-CPU churn
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,bpf@vger.kernel.org
Cc: martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,roman.gushchin@linux.dev,kernel-team@meta.com,linux-mm@kvack.org,cgroups@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,ziyang.meme@gmail.com,shakeel.butt@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat,  4 Jul 2026 05:58:23 +0000 (UTC)

--===============8802271696774654361==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn_percpu.c b/tools/testing/selftests/bpf/prog_tests/memcg_stat_churn_percpu.c
> new file mode 100644

[ ... ]

> +static void settle_flush(void)
> +{

The settle_flush() comment explains the reset with:

> + * ~15% window asymmetry, enough to invert bpf_matched vs bpf_full on
> + * flush-dominated cases (e.g. "hot": few cgroups churned from many CPUs).

This isn't a bug, but the cases in this file are narrow/wide/widest, and
there is no "hot" case here (or in the sibling tests).  The timed reads also
always run with collect_full = 1, so there is no bpf_matched-vs-bpf_full
comparison in this test.  Does this example still describe this file, or was
it carried over from another test?

[ ... ]

> +#define CHURN_GAP_US	(50 * 1000)

The gap comment just above this says:

> + * pays that flush inside its timed region.  This gives all four reads
> + * (file/bpf x matched/full) approximately the same start state and folds the

This isn't a bug, but the sampling loop does one file_pass() and one
bpf_pass() per sample (bpf_pass always sets collect_full = 1), so there are
two reads per sample rather than the "four reads (file/bpf x matched/full)"
described here.  Should this be reworded for this test?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/28695985027
--===============8802271696774654361==--
