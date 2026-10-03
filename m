Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C503B2FD6;
	Sat,  3 Oct 2026 23:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791069205; cv=none; b=PASPkod+EQEoLWoKC67BaTr+eOqb6DeSE85ukEmpJcDo7nJbGTtnCCx09TArf7HSeohyei2zGK8bjDGV9PjRlpx0vxgjPJM+nkraPZLaT21PVeSH4Rn4etjxJM5e37CxdXm2l0S2vFBDZka8utancmrUyhVmlZvALtC/XI9/MvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791069205; c=relaxed/simple;
	bh=jeLTWqv1HorSaZmbwa1dw1eW5NeZUC8JceuKleIynLI=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZJMWlk2PV4+WkOUZ2BajwoF27QW6eayp3A+fyTr7JnrJV+nY+NhIKZn5//xlKbu9m+3hdSHGxlENMIIae1o2vALnADy8LfNPV/pkCWy36JHjeL8z8p1enN+tP1A46yIFRoPqOHZwKmbJs0ORMkfTB7P9EHpr24KhncUIxb3j58g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h06qkKwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h06qkKwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445E21F0089C;
	Sat,  3 Oct 2026 23:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069203;
	bh=eGdC2lf8b/ZOvjCNTArSuVDjf7dxJqfVxE783PPAfaM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=h06qkKwpPs/8cPDBnXeUIyOF63McYZaAPtjHzscLIuPtdiDDJY5g3tGOKKarSP1QV
	 DBCAk9RaqbcNKueKTR8559a9EI8ja7x3kLUHrHU/nVBmI+j6QnYFVFp0Stk1OSlHO5
	 jnn/Ul3JQ8c9hBeTodVMgLext99iVLgcfHDyTlp/4iLY0VkbRLoXiNNFMqwecWC028
	 yfBI7wq0UKa9SUn7M6mTK7RzofyKnhDsOqnrCR5lxo1NB7YJf1xQSTCb3wIHwQYdBF
	 ycnUmkJGmjISEfsXT+jXdzywid8Ukai0Mp/TbGDqvvecT6f5wwGJBaeybzfpVVGrlu
	 kwk1BctuyWmsA==
Subject: Re: [PATCH net-next v5 5/7] mm/slab: Provide kmalloc type fallback
 for bucket allocations
From: netdev-bot+sashiko@kernel.org
To: kees@kernel.org
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org,
 hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, pfalcato@suse.de,
 kuniyu@google.com, linux-hardening@vger.kernel.org, davem@davemloft.net,
 hannes@cmpxchg.org, mhocko@kernel.org, shakeel.butt@linux.dev,
 muchun.song@linux.dev, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, kerneljasonxing@gmail.com,
 willemb@google.com, almasrymina@google.com, bjorn@kernel.org,
 jiayuan.chen@linux.dev, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 netdev@vger.kernel.org
Date: Sat, 03 Oct 2026 23:13:21 +0000
Message-ID: <179106920182.434549.1755707422798774394@kernel.org>
In-Reply-To: <20261002231132.1646573-5-kees@kernel.org>
References: <20261002231132.1646573-5-kees@kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] kmem_buckets_create() takes @ctor, @align,
  @useroffset/@usersize and @flags (e.g. SLAB_ACCOUNT), and applies them…

--

mm/slab: Provide kmalloc type fallback for bucket allocations

This patch changes kmalloc_slab() so that a bucketed allocation whose
kmalloc type the bucket set doesn't hold (DMA, reclaimable, accounted,
and so on) goes to the general kmalloc caches. Before, it was always
served from the bucket's normal caches. It also adds a KUnit test for
the fallback and exports mem_cgroup_kmem_disabled() for KUnit.

Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]

> diff --git a/mm/slab.h b/mm/slab.h
> index 8fd6835e42352..7f1bfee83b92e 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -421,6 +421,26 @@ static inline unsigned int size_index_elem(unsigned int bytes)
>  	return (bytes - 1) / 8;
>  }
>  
> +/*
> + * Which set of buckets to use for the given kmalloc_cache_type. If not
> + * handled by the kmem_buckets, fall back to general caches.
> + */
> +static inline kmem_buckets *
> +kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
> +{
> +	enum kmem_bucket_type btype;
> +
> +	if (!bucket)
> +		return &kmalloc_caches[type];
> +
> +	if (type <= KMALLOC_PARTITION_END)
> +		btype = KMEM_BUCKET_NORMAL;
> +	else
> +		return &kmalloc_caches[type];	/* No set holds a row for it. */

[Severity: Medium]

If a bucket set is in use and the type is above KMALLOC_PARTITION_END,
this returns the general kmalloc caches. That happens for GFP_DMA with
CONFIG_ZONE_DMA, __GFP_RECLAIMABLE, and __GFP_ACCOUNT with CONFIG_MEMCG.
Do the parameters passed to kmem_buckets_create() still apply in that
case?

kmem_buckets_create() applies align, flags, useroffset/usersize and ctor
only to the bucket's own caches:

mm/slab_common.c:kmem_buckets_create() {
    ...
			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
					align ?: kmalloc_caches[KMALLOC_NORMAL][idx]->align,
					flags, cache_useroffset,
					cache_usersize, ctor);
    ...
}

The general caches have no ctor, and their usercopy window covers the
whole object:

mm/slab_common.c:create_kmalloc_cache() {
    ...
	create_boot_cache(s, name, size, flags | SLAB_KMALLOC, 0, size);
    ...
}

With the fallback, it looks like four things are lost:

  - the ctor never runs
  - the requested alignment is not honoured
  - the hardened usercopy window widens to the whole object
  - creator flags such as SLAB_ACCOUNT are dropped

For the SLAB_ACCOUNT case, ipc/msgutil.c creates msg_msg this way:

	msg_buckets = kmem_buckets_create("msg_msg", 0, SLAB_ACCOUNT,
					  sizeof(struct msg_msg),
					  DATALEN_MSG, NULL);

Suppose a bucket like this gets GFP_DMA or __GFP_RECLAIMABLE without
__GFP_ACCOUNT. The allocation would land in dma-kmalloc-N or
kmalloc-rcl-N, and neither has SLAB_ACCOUNT. memcg_slab_post_alloc_hook()
then returns early:

	if (likely(!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT)))
		return true;

Wouldn't the memcg charge be skipped here?

Before this patch, every bucketed allocation got these parameters.
kmem_buckets_create() doesn't reject or warn about combinations that the
fallback can't honour.

No in-tree caller hits this today. memdup_user uses GFP_USER and msg_msg
uses GFP_KERNEL. skb data uses ctor=NULL, align=0 and a full usercopy
window, so it loses only isolation on its rare GFP_DMA path. The API is
exported, though.

A later patch in the series doesn't change this either. After "mm/slab:
Let a bucket set handle __GFP_ACCOUNT", the kmem_buckets_create()
kernel-doc in include/linux/slab.h says:

 * Covers KMEM_BUCKET_NORMAL only. Allocations needing another kmalloc type
 * are served by the general caches, keeping the type they asked for and
 * losing only the isolation.

Is "losing only the isolation" accurate, given that the ctor, alignment,
usercopy restriction and creator flags are lost as well? The existing
kernel-doc in mm/slab_common.c also says the ctor is "run when new
allocations are made", with no exception for fallback types.
kmem_buckets_create_types() has the same fallback for any type it doesn't
cover.

Should kmem_buckets_create() reject or warn about the parameter
combinations the fallback can't satisfy? Or should the documentation
describe what is lost?

> +
> +	return &bucket[btype];
> +}
> +

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org
