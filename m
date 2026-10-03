Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3613B5E15;
	Sat,  3 Oct 2026 23:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791069207; cv=none; b=nRakX18UOYnwwpWwZlnA5nze3vVTD5dR0u9737HtThcg6WU/A/S0HgwBo6xLDgXPnDiXZu9JDadK+Qx2emrS26enH8CL7AUvb6d4MSYfuXkQCKVRv3J+z86XeKC8oWOtbeCvseEi+hkOe0poTAKJQLkQmvZoY0i+YTp3dcy17jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791069207; c=relaxed/simple;
	bh=YxgkfZkJTpx0LgzUBGFI3j0GVbM+e0bIOgmMZtc3GEs=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DW7qFtkJDqRvo97gqgkiNJjEK8OuaZY+MAokzEgvd+J0XHk6Wx6dALQZdcOamwRIdF898gNEjU9DHVDV98T6cS7oneKsyZueK/EIV/HjYOnF00RxRYRdQVE+GN4qHwnd2FiA/JSkzFAbAD82VHsYcP3u26OF8a1l+VHMgYHFzMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GJSJZfuT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GJSJZfuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6861C1F0089B;
	Sat,  3 Oct 2026 23:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069205;
	bh=WEvGVkjJzFQ0aHmQXFQPEujNs9Tyg+JaVUsrq9l1VIM=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GJSJZfuTQIRM1fr+0rl5LHjZAJyqd4InMjLwI/zFJvIuv5T37W0Q4zyR8ewpgXlyN
	 Emd/SeeL1MakfSB7/zU4yzPaVMIWa/m4cDg0F2yOQ1tLwt1IcvAHUr5L7RJV9iDShB
	 /DLiVokz/HjfEL9i/jB1Ljjuw/mcFKeqshkRKihvTcit8VIEHiwmL2Z3gUxxiPcY01
	 slSnCIqcilboDr/L36IMdwjN0l9ehq6MUd0varD8JEarJqFX+MDWaKmXX1sfdT9TyB
	 7eaQhg1mhCod7b1YTiKqCf8WqG+uv+D1OfLWfbBkD6DwHr2SO/Fa/tr816rvQgw9Od
	 5gBy+sWQDbReQ==
Subject:
 Re: [PATCH net-next v5 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
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
Date: Sat, 03 Oct 2026 23:13:23 +0000
Message-ID: <179106920397.434549.7271409150598093746@kernel.org>
In-Reply-To: <20261002231132.1646573-6-kees@kernel.org>
References: <20261002231132.1646573-6-kees@kernel.org>
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

- [Medium] The patch adds a WARN_ONCE() in kmalloc_choose_bucket()
  (mm/slab.h).

--

mm/slab: Let a bucket set handle __GFP_ACCOUNT

This patch adds an optional accounted row (KMEM_BUCKET_CGROUP) to a
kmem_buckets set. The row is selected through the type mask of a new
kmem_buckets_create_types(), so __GFP_ACCOUNT allocations can stay
isolated in the set. kmem_buckets_create() becomes an inline wrapper that
builds only the normal row, and under cgroup.memory=nokmem the accounted
row aliases the normal one.

> diff --git a/mm/slab.h b/mm/slab.h
> index 7f1bfee83b92e..2af44e09edda1 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -435,10 +435,31 @@ kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
>  
>  	if (type <= KMALLOC_PARTITION_END)
>  		btype = KMEM_BUCKET_NORMAL;
> +	else if (IS_ENABLED(CONFIG_MEMCG) && type == KMALLOC_CGROUP)
> +		btype = KMEM_BUCKET_CGROUP;
>  	else
>  		return &kmalloc_caches[type];	/* No set holds a row for it. */
>  
> -	return &bucket[btype];
> +	/*
> +	 * Either this row was created, and holds a cache everywhere the
> +	 * general caches hold one, or it was never created and holds nothing.
> +	 * Test with the KMALLOC_SHIFT_LOW which exists in every configuration.
> +	 */
> +	if (likely(bucket[btype][KMALLOC_SHIFT_LOW]))
> +		return &bucket[btype];
> +
> +	/*
> +	 * A row this set _could_ have held, but was not created with: the type
> +	 * mask passed to kmem_buckets_create_types() did not cover what its
> +	 * callers actually tried to allocate. Report the mismatch but still
> +	 * fall back to the general caches.
> +	 *
> +	 * At present, only __GFP_ACCOUNT can be missing.
> +	 */
> +	WARN_ONCE(1,
> +		  "kmem_buckets: __GFP_ACCOUNT needs BIT(KMEM_BUCKET_CGROUP) in create mask\n");

[Severity: Medium]
Can a set built with plain kmem_buckets_create() reach this WARN_ONCE()?

That wrapper passes only BIT(KMEM_BUCKET_NORMAL), so the
KMEM_BUCKET_CGROUP row stays zeroed. With CONFIG_MEMCG=y, take this call:

    kmem_buckets_alloc(b, size, GFP_KERNEL | __GFP_ACCOUNT);

kmalloc_type() returns KMALLOC_CGROUP for it, including under
cgroup.memory=nokmem. kmalloc_choose_bucket() then maps that to
KMEM_BUCKET_CGROUP, finds bucket[KMEM_BUCKET_CGROUP][KMALLOC_SHIFT_LOW]
is NULL, and warns.

Before this patch, that allocation fell back to
kmalloc_caches[KMALLOC_CGROUP] without a warning, and
test_kmem_buckets_type_fallback() checked for a "kmalloc-cg-" cache. In
this patch that check is replaced by a comment saying the fallback warns.

The documentation added in this patch still seems to describe the old
behaviour. The kernel-doc for @type_mask in kmem_buckets_create_types()
says:

    Allocations of a type that is not covered are served by the
    general caches instead, so a caller need not know in advance
    which types its own callers will ask for.

The kernel-doc for kmem_buckets_create() in include/linux/slab.h says:

    Covers KMEM_BUCKET_NORMAL only. Allocations needing another kmalloc type
    are served by the general caches, keeping the type they asked for and
    losing only the isolation.

The commit message also says kmem_buckets_create() keeps its name,
"leaving existing users as-is", and does not mention the new warning.

No in-tree caller appears to hit this, and that is still true at the end
of the series. However, kmem_buckets_create_types() is exported, and a
caller that follows the documentation would get a WARN splat. With
panic_on_warn set, that becomes a panic.

Should the WARN_ONCE() be dropped to match the documented contract? If
the warning is intended, could the commit message and both kernel-doc
blocks say that __GFP_ACCOUNT allocations need BIT(KMEM_BUCKET_CGROUP)
and warn otherwise?

> +
> +	return &kmalloc_caches[type];
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org
