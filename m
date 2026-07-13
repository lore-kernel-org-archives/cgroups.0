Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EAC3E7BA9
	for <cgroups@vger.kernel.org>; Mon, 13 Jul 2026 10:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783938172; cv=none; b=BLkzQt1MX7//0Jek0oki7TsHvLYbDYnwtXcain8pKy58cbnf3tZkJFb6tfyh14byx6RBsO3yjapbE+PNoE5RWRB2KHqZ2loc7KRdNeOZ/sQilQJVJ87+JGY0kn0ZVuU/9DzPtBCCj/Y+1KnBgnqTJ7s6w3G0/t+CwmKsCpU7y4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783938172; c=relaxed/simple;
	bh=VX4g3z4Wikmxzsaw+/m6jdJkTveTTJM1UMis/os1+EE=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QJ88HEHlYi4MI9HQBofVolbVLdBabeqv/EThs7tfK7ke9q2JSnJLrXA/ODNb7UiZKheaQ7lSi8MofuPstBf+77GXb9VkiY2VHvSBptCmwmp6wqfrzaMNzLvhahB+Y2GGfTv+Ekz141z9BSR/vnDBxAD8QZZN+uTL0Gdqz7uAfe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=h9p5lrWo; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="h9p5lrWo"
Message-ID: <99977527-c2d7-4c70-8d92-03c306d3ec36@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783938158;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hRcZAfhs+kHcVySJuPzxTTfP2MnAcNBGTb9R86cF3qs=;
	b=h9p5lrWoV13zy8DGeLR6b7gi3acso++iVPQs8D7wNMi/Ih6KYYfFJUmgfgkfEv8+XFNcc1
	OZcCWSmr4yLy1eth1NIjkqg0xOwrOFEP2ALqZBlkt2ef+WIhGVktu0vDSCRWZIfGJhWt9F
	7txsaIItmeJFSUeYUgQWdBIa6aEa09k=
Date: Mon, 13 Jul 2026 18:22:28 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Alexandre Ghiti <alex@ghiti.fr>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: update state_local when flushing NMI
 stats
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>
References: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260713085053.2916813-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/13 16:50, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> flush_nmi_stats() updates state[] for kmem and slab counters but leaves
> the corresponding state_local[] counters unchanged. Local kmem and
> slab statistics therefore miss updates collected through the NMI-safe
> atomic path.
> 
> Update state_local[] together with state[].
> 
> Fixes: 940b01fc8dc1 ("memcg: nmi safe memcg stats for specific archs")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22f55aeb94f3..02599b8b6bd5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4443,6 +4443,7 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  		int index = memcg_stats_index(MEMCG_KMEM);
>  
>  		memcg->vmstats->state[index] += kmem;
> +		memcg->vmstats->state_local[index] += kmem;
>  		if (parent)
>  			parent->vmstats->state_pending[index] += kmem;
>  	}
> @@ -4460,9 +4461,11 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  			int index = memcg_stats_index(NR_SLAB_RECLAIMABLE_B);
>  
>  			lstats->state[index] += slab;
> +			lstats->state_local[index] += slab;
>  			if (plstats)
>  				plstats->state_pending[index] += slab;
>  			memcg->vmstats->state[index] += slab;
> +			memcg->vmstats->state_local[index] += slab;
>  			if (parent)
>  				parent->vmstats->state_pending[index] += slab;
>  		}
> @@ -4471,9 +4474,11 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent,
>  			int index = memcg_stats_index(NR_SLAB_UNRECLAIMABLE_B);
>  
>  			lstats->state[index] += slab;
> +			lstats->state_local[index] += slab;
>  			if (plstats)
>  				plstats->state_pending[index] += slab;
>  			memcg->vmstats->state[index] += slab;
> +			memcg->vmstats->state_local[index] += slab;
>  			if (parent)
>  				parent->vmstats->state_pending[index] += slab;
>  		}

Looks correct — state_local[] mirrors state[] for this cgroup's own NMI-accounted kmem/slab charges, and pending→local is properly left untouched.

Acked-by: Tao Cui <cuitao@kylinos.cn>
