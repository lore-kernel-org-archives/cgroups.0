Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEDB1BD9C9
	for <cgroups@vger.kernel.org>; Thu, 24 Sep 2026 21:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790284749; cv=none; b=AjXliEDE/yFKC2QGrBueFofm20c6+GiZh7Bd5rrdd4sERWdn1nC+21bzWIJFipamCDyGmbMvFwOaov2cLsvl9wO/k++uxU8dNYks6J4SNPLJM8FAQlS8GVOJ9odYf/HNZX/dXz5rSyxkaqfKt4eUIuTT0DZI60YIzz4hNHJa1RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790284749; c=relaxed/simple;
	bh=mU5oJrgH1sYUjWonRB98Yad1omw/P5Tdsx9/iTNI1j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsVLikG+mFFFoz0u+9eqTNrA2j/wTf8W7GmntS1QGhuo63eUr1U0FaolUxdzFMrwCUXKbN2NQ/1bXaP6OgeHqgV8pBxBEEERN0OwPg9MlV0C6nyaZh+UakgyVXOT1zoBk8ezy0Q/3SGqfL+ZNVjuF2eraeZxe064ZUVEMRLJqvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=u4brnE0F; arc=none smtp.client-ip=91.218.175.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="u4brnE0F"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=mU5oJrgH1sYUjWonRB98Yad1omw/P5Tdsx9/iTNI1j0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790284746; v=1; x=1790889546;
 b=u4brnE0F1411IWpvTlPuKrmb+pPcXKQAcZcbVyFNSaPhlH7xA6yjcjVwGCK9iTlyyLrmu5OM
 GeMZ7BW5QY2OYrigXc1iTUf0IP4j9GWGb4sEcvhcARFhE3qMbI/YKf6SbM9fVrv8z9zfkBynsPZ
 bcJswsyvHNLV3jNCSgLDV9OM=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 840ded800c29f88f;
	Thu, 24 Sep 2026 21:19:06 +0000
X-Mizu-Trace-ID: 840ded800c29f88f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 14:19:04 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alexei Starovoitov <ast@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Michal Koutny <mkoutny@suse.com>, 
	Amery Hung <ameryhung@gmail.com>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ihor Solodrai <ihor.solodrai@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev, Donet Tom <donettom@linux.ibm.com>, 
	Greg Thelen <gthelen@google.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	bpf@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/4] memcg_ext: allow BPF to defer memory.high
 enforcement
Message-ID: <arWTPMEm5C9tFeGc@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
 <20260921192559.2619635-4-shakeel.butt@linux.dev>
 <c8b8504c-8e54-479f-a372-3d2755edaf88@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8b8504c-8e54-479f-a372-3d2755edaf88@linux.dev>

On Thu, Sep 24, 2026 at 01:14:59PM -0700, JP Kobryn wrote:
[...]
> > +static void bpf_memcg_ctx_init(struct bpf_memcg_ctx *ctx,
> > +			       struct mem_cgroup *memcg,
> > +			       struct mem_cgroup *over_limit, gfp_t gfp_mask)
> > +{
> > +	ctx->memcg = memcg;
> > +	ctx->memcg_over_limit = over_limit;
> > +	ctx->task = current;
> > +	ctx->cgroup_id = cgroup_id(memcg->css.cgroup);
> > +	ctx->over_limit_cgroup_id = over_limit ?
> > +		cgroup_id(over_limit->css.cgroup) : 0;
> > +	ctx->nr_pages_over_high = current->memcg_nr_pages_over_high;
> > +	ctx->gfp_flags = (__force u32)gfp_mask;
> > +}
> > +
> > +u32 bpf_memcg_high_policy(struct mem_cgroup *memcg,
> > +			  struct mem_cgroup *over_limit, gfp_t gfp_mask)
> > +{
> > +	const struct bpf_prog_array_item *item;
> > +	const struct bpf_memcg_ops *ops;
> > +	struct bpf_memcg_ctx ctx;
> > +	u32 acc = BPF_MEMCG_HIGH_NO_OPINION;
> > +	struct cgroup *cgrp;
> > +
> > +	if (!cgroup_bpf_enabled(CGROUP_MEMCG_OPS))
> > +		return acc;
> > +
> > +	/*
> > +	 * Only the default hierarchy has a cgroup_bpf, and the static key is
> > +	 * global, so one policy anywhere turns this on for v1 memcgs too.  A
> > +	 * v1 memcg still cannot get here, because memory.high and swap.high
> > +	 * are both v2-only and so it never builds the debt that leads to this
> > +	 * call.  A hook on a path v1 can reach needs its own cgroup_on_dfl()
> > +	 * test: a v1 cgroup has no effective array and an uninitialised
> > +	 * cgrp->bpf.refcnt.
> > +	 */
> > +	cgrp = memcg->css.cgroup;
> > +
> > +	/*
> > +	 * A program can allocate and re-enter the charge path.  Skip the
> > +	 * nested call.  This guards the callbacks only.
> > +	 */
> > +	if (current->in_bpf_memcg)
> > +		return acc;
> > +	current->in_bpf_memcg = 1;
> > +
> > +	rcu_read_lock_dont_migrate();
> > +
> > +	/*
> > +	 * A memcg outlives its cgroup while it has charges, and
> > +	 * cgroup_bpf_release() frees the arrays when the cgroup goes.
> > +	 */
> > +	if (!cgroup_bpf_tryget_live(cgrp))
> > +		goto out;
> > +
> > +	bpf_memcg_ctx_init(&ctx, memcg, over_limit, gfp_mask);
> > +
> > +	bpf_cgroup_struct_ops_foreach(ops, item, cgrp, CGROUP_MEMCG_OPS) {
> > +		if (ops->high_policy)
> > +			acc |= ops->high_policy(&ctx) &
> > +			       BPF_MEMCG_HIGH_VALID_MASK;
> > +	}
> 
> If I'm reading correctly, the gfp_mask at this point doesn't account for
> task restrictions, so the BPF program may see __GFP_FS, __GFP_IO, etc
> which may later be cleared when setting up the scan_control instance.

I am passing the same gfp_mask which has been passed to try_charge_memcg(), so
it should be same as what reclaim_high (reclaim internal) sees.
