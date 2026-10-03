Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF53B7760;
	Sat,  3 Oct 2026 23:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791069209; cv=none; b=ZjudlClWORKMrezxtg+yXoItL1qpsSko7Mnc0/sZUxAryGmmlkH28QNxRsSqD3gy0Ww2/MKj9ocC9gCXz5mmkZrKIkFGVt9CTMDYuImGPU2FBlB+/N972SGQ36APiyBIxZJ6EjqjofzEYuHc1LPRxumKQzkFnspo6cVTtL4osYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791069209; c=relaxed/simple;
	bh=m6x+QohLazM6n94oET/vCQjOeBmkfLjMD8HPJd8IU5g=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ED7KF/Sq75hstkUSOC44GUAJ1awEddSsKbze/iEdsvxezMvxyTMYiUifpZmKTjyG5sm9zHDvy6HjjjAksqkVPLuCJ5RS17iBBcoIfhoYYif9/3t0QGzTTy5oltKrRoRpFu7NSlQyMFPho7jWfZhei+sTifQV0Y2pGbZwKLYZ7hQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aSkUnWZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aSkUnWZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D24F1F0089C;
	Sat,  3 Oct 2026 23:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791069208;
	bh=MmC3HEgkDX9MlcGsgiuH35IWs/E9FDG/g8OR9C7T9KA=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=aSkUnWZ1SNAbpwLsB3KU5uD7pViDv+bcq49TV6pIyPiLmShD03VIblVl9lx44Y1Kz
	 TUaKFJMhqCQ9mF+4//XPjxe//UmrlXVRJDbvu1UZyaxQk9HpoB64cdM/3dHj+F+Pak
	 Igbw2AzRYzdGg+9bnkzaEZtNLWRBhRyCo+cnrkGAdnn22cE5dGLUwaaRr4Gliz7b4R
	 Bu0m9tqvCl06mTKVdEgZu3ayBWZRW/9gK/L/dLb0Vof+YltrBSuheo3oBO0etQ2Lep
	 NDSdqd/UTcJ4w/qz0IyCU2Y/qHss7Teu5kcW+TiduXXDrVjxgkqTiSPmkCtVO9TNsl
	 XXEYTNpj1ZCAg==
Subject: Re: [PATCH net-next v5 7/7] net: skb: isolate skb data area
 allocations into a separate bucket
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
Date: Sat, 03 Oct 2026 23:13:26 +0000
Message-ID: <179106920612.434549.10910954892692956019@kernel.org>
In-Reply-To: <20261002231132.1646573-7-kees@kernel.org>
References: <20261002231132.1646573-7-kees@kernel.org>
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

- [Low] The block comment above kmalloc_reserve() in net/core/skbuff.c
  (line 603) still says "kmalloc_reserve is a wrapper around…

--

net: skb: isolate skb data area allocations into a separate bucket

This patch moves skb data area allocations in kmalloc_reserve() and
kmalloc_pfmemalloc() off the general kmalloc caches and onto a dedicated
kmem_buckets set named "skb_data". The set is created in skb_init() with
both the normal and the accounted kmalloc types, so GFP_KERNEL_ACCOUNT
users such as AF_UNIX are isolated as well.

Link: https://github.com/google/security-research/blob/master/pocs/linux/kernelctf/CVE-2023-4207_lts_cos_mitigation_2/docs/exploit.md [0]

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 4aea06d5167d1..a83689661fc28 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c

[ ... ]

> @@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
>  	if (!obj_size)
>  		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
>  					     flags, node);
> -	return kmalloc_node_track_caller(obj_size, flags, node);
> +	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
> +						    flags, node);
>  }
>  
>  /*

[Severity: Low]
This isn't a bug, but the block comment that follows here, above
kmalloc_reserve() in net/core/skbuff.c, still says:

 * kmalloc_reserve is a wrapper around kmalloc_node_track_caller that tells
 * the caller if emergency pfmemalloc reserves are being used. ...

After this patch, neither kmalloc_reserve() nor kmalloc_pfmemalloc() calls
kmalloc_node_track_caller(). Both now use
kmem_buckets_alloc_node_track_caller(skb_data_buckets, ...).

Should the comment be updated to name the bucket allocator? As it stands,
it points readers at the general kmalloc caches instead of the skb_data
caches.

> @@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
>  	 * Try a regular allocation, when that fails and we're not entitled
>  	 * to the reserves, fail.
>  	 */
> -	obj = kmalloc_node_track_caller(obj_size,
> +	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
>  					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
>  					node);
>  	if (likely(obj))

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261002231120.late.500-kees%40kernel.org
