Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE543B6BEE;
	Sat,  3 Oct 2026 23:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791069201; cv=none; b=kUxqqbrH/+yUS1sl1afOpvpDBu2tTMK4AcW7bNM/Bhsj/WnhxTnxerREP+ecg9Z+HpjUO4bMlYr7XJQrT7MrxzeY21pOXFAijYddU/AZDqw9d3BXBYPMsmxAL8HOloG4PFUwpMcj2VYM1INbREQyWysDpPuOdkaGgHp0iQ++TDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791069201; c=relaxed/simple;
	bh=dGOV/yJOQ5jw5eVcduFh2lJwtzgZP+1eJlCQtogU2Po=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Tqeq+WUnQ/JyRHniAx7E7YP7wbrT4Ea+mPfu/FhwQ07YkQBaXWcLcz3sOxuJ1xTSrIj2yivffnh0u+v9XBrzvbVf+rYAuRXxK+aS0yV/rEXy37dMGWbH9BMQtMwEfrDEgurgzHKXbCpmW6Az2pUy7zMMlsijLJ0qc7tiAHyOM2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bej0s0NJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bej0s0NJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EF41F0089C;
	Sat,  3 Oct 2026 23:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069199;
	bh=hjdLeITgvZLNhUTfFbAwoCm4iJ6OC8058r//qE36TfE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Bej0s0NJaASQzvzEI3tJ2yAj9Wz8FjWNRSLLb9vrlcUbicahh11ViNrcIzsFNv9SZ
	 VNqD6If/BUxrnMUDLp61l1jBFmz/dMAqXFyo0FIyWD2sw+dosk2gXuZEq2G4o87mMk
	 RAkkx00cpBitBnKZPk1KZS7ZQbeuXtqOHTETmSVnqbNvzXmcU/bidYY9TvTx/jdqX9
	 43tunTgAvDHU85VDXc25vioamh8euZEAfMEP852K8gGHxgYbvEG/TKK8qOShcXs0K0
	 V4pPxSWdduWDaAm2p5aZ5H5OFfEvhBg+ShX0f4eBSNLRrRF382ni++enIquZEV68S4
	 K3ln1PsxEZRqg==
Subject: Re: [PATCH net-next v5 3/7] mm/slab: Add kmem_buckets_destroy()
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
Date: Sat, 03 Oct 2026 23:13:17 +0000
Message-ID: <179106919785.434549.14247431491192293062@kernel.org>
In-Reply-To: <20261002231132.1646573-3-kees@kernel.org>
References: <20261002231132.1646573-3-kees@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The new comment in kmem_buckets_destroy() (mm/slab_common.c)
  says: "Sizes below arch_slab_minalign() share one cache, which…

--

mm/slab: Add kmem_buckets_destroy()

This adds kmem_buckets_destroy() as a counterpart to kmem_buckets_create(),
so that KUnit tests built as modules can tear down a bucket set. The
create path's bitmap-based error unwinding is replaced with a call to the
new helper. The helper clears every aliased pointer to a cache before
destroying it.

Link: https://lore.kernel.org/all/20240809073309.2134488-1-kees@kernel.org/

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 71926f726a07a..bdc34a5e6d6f5 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c

[ ... ]

> +void kmem_buckets_destroy(kmem_buckets *bucket)
> +{
> +	unsigned int idx, i;
> +
> +	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
> +		return;
> +
> +	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
> +		struct kmem_cache *cache = (*bucket)[idx];
> +
> +		if (!cache)
> +			continue;
> +
> +		/*
> +		 * Sizes below arch_slab_minalign() share one cache, which
> +		 * kmem_buckets_create() then stores at each of their indices.

[Severity: Low]
This isn't a bug, but is this comment accurate about where the aliasing
comes from?

The aliasing in kmalloc_caches[] is set up by new_kmalloc_cache(). It uses
__kmalloc_minalign(), and that is not arch_slab_minalign() on its own:

mm/slab_common.c:__kmalloc_minalign() {
	unsigned int minalign = dma_get_cache_alignment();
	...
	return max(minalign, arch_slab_minalign());
}

new_kmalloc_cache() then rounds every size up to that alignment:

	if (minalign > ARCH_KMALLOC_MINALIGN) {
		aligned_size = ALIGN(aligned_size, minalign);
		aligned_idx = __kmalloc_index(aligned_size, false);
	}

This aliases sizes that are not multiples of minalign, even when they are
not below it. For example, kmalloc-96 maps to the 128 cache when minalign
is 64, and kmalloc-192 maps to the 256 cache when minalign is 128.

kmem_buckets_create() reads object_size from the already-aliased
kmalloc_caches[KMALLOC_NORMAL][idx], so the same aliasing ends up in the
bucket set.

The code itself is fine, because the inner loop clears every matching
pointer whatever caused the alias. Could the comment say that sizes are
rounded up to the kmalloc minimum alignment, rather than "sizes below
arch_slab_minalign()"?

The same wording also survives in the later commit "mm/slab: Let a
bucket set handle __GFP_ACCOUNT". That commit rewords this comment but
keeps "sizes below arch_slab_minalign() share one".

> +		 * Drop every reference to it before destroying it, so that no
> +		 * later pass reads a pointer to a cache that is already gone.
> +		 */
> +		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
> +			if ((*bucket)[i] == cache)
> +				(*bucket)[i] = NULL;
> +
> +		kmem_cache_destroy(cache);
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org
