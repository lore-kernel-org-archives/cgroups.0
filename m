Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793154256;
	b=I+siazBoBk3ay5+fCjEEArlNcgHJ2BlxT5hHPWZZrsZDReJ23CiTTv8yprtp+Os5RSkJ
	 JILz5amG4x1xnuQoJ3gj/rE0mtZF9wbW+el0SfWz4mdRAhCw2xkn39Dd8GAzjCZKhzIb0
	 27ek4rrsgwSuX59pEOWwvBsSQfnJgJu9n+3RWojlVr6CcTenolu4aJbvdYxNb3fMqTf14
	 g/lN09y3PLQqr30iBIxHOn2pFEIiSg6xhw3isWAlxpVb05FDi/NnsMjgg0Qs3e7w+sBm4
	 uFHRl02aL0nMyHUCVM3/x+wtIVgjQKriS024POmXZ8MisU7eKt3vFw7P/7SD5MxWwjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793154256;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=kW6mzNv9d6yhsfaYr7C1SS1O9TnPTANE1C6w87x8UOI=;
	b=yDvYWbi36NjdCf9OLo43/83QXK23frx/zrpvN3VCtfoDz+ej+QCg0e5eGdDPSMfYLm5e
	 nmc4p87PCmXBjtpYTetD87Kk1D1SxZc7aeqLptgSuZgA+/pQiZc7PASEYEsUyZzRxHk7f
	 YzQ585B6RIz7GSpIZazyevDnQHkhNh99uxNTkwey6PN64g2j0QwyMHHmjhUcKk2algA0G
	 YV/PZO+ucRsfyJC0+akyv+vJ2qLfPMsxbAajov/XqFiKqbrazAZSQ3FbQMHyRVoNn3SPR
	 fT1e6m1ZTpRRB59O4ADHqri9M+RlXKqm0QhdHMkvz3eeTxz8w74fMNcE6TQsbnkaI9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t7Zex76s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544D9606A31A
	for <cgroups@vger.kernel.org>; Wed, 28 Oct 2026 02:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t7Zex76s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1F51F01825;
	Wed, 28 Oct 2026 02:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793154255;
	bh=kW6mzNv9d6yhsfaYr7C1SS1O9TnPTANE1C6w87x8UOI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t7Zex76sZygL34C3bGAE/bdKfCXA/NQNhzNyXl5a34bLDu8qnEAUmyJW3fxNhw08C
	 tbzAmjUEM+gttOp+naQ4mxx1OuMWy2NNsfLeeotgwWGP1gKVbMKuceyohlZcWvq/Bc
	 fthpJqRPvByozPwnLn76K5SqpPFTRbAOt0lo2jro=
Date: Tue, 27 Oct 2026 19:24:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song
 <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec
 stat
Message-Id: <20261027192414.cb3318abc07232ec5f1bc937@linux-foundation.org>
In-Reply-To: <CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com>
References: <20261023195417.1391216-1-joannelkoong@gmail.com>
	<20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
	<CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Oct 2026 15:57:43 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> Here's an updated version of the "Fix this by moving the memcg_pn_cold
> group..." paragraph in patch 1 that mentions this:
> 
> Fix this by moving the memcg_pn_cold group, which is only touched when
> the memcg is reparented or freed, right after memcg_pn_read_mostly.
> SLAB_HWCACHE_ALIGN only aligns objects to a cacheline, and the struct
> is 576 bytes, so depending on where an object lands, its read-mostly
> cacheline is now paired either with its cold cacheline or with the last
> cacheline of the preceding object, which holds the end of
> lru_zone_size[] and the reclaim iterator. Both are rarely written
> outside of reclaim, so either way the read-mostly cacheline is no
> longer paired with the LRU list heads.
> 
> Would you be able to swap it in or would you prefer that I send a v4?

Thanks.  I'll take care of this when I process the patchset.  Which
will be quite soon now we're all merged up.
