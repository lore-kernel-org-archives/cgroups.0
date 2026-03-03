Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD5B38C2C5;
	Tue,  3 Mar 2026 09:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772529839; cv=none; b=WVcRB22PrlBIAQmqblJVhyFk+Xw3OcuQPthTRW86uJ4QvLFqvIFDeWGsTP72n1n5m+ERlmRhtVg9b34t9ZG/7lFmfXzULgZk+9QIK0NSpeOea1dGEpXMqLXfC2XHO47NU51SV6OJWEHd+gsfz7GTU+L6xSUsLu9lnxlDiiUv7UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772529839; c=relaxed/simple;
	bh=T5SIuOMiWFmjtgV2QvoBtw5OpiYnIs1FtaXsK/C2OaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jUv/R/1jp7d5N6CimzsSBG2Z5ogYblXi7Z4TJm5HMU8zgcrSdeEiz0pJzt9P2w1y3eU/a9wo5uFLmCLA7b+ZmEjE0ZmMD+OUNxE32EYp34bZvrPbgMkP3hQy50paO6IVRw63Zsn4zK4XgNgMPrtdf6v5qRcfkXwAmnR2t5kKYrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e6A+XVLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e6A+XVLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A19C116C6;
	Tue,  3 Mar 2026 09:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772529838;
	bh=T5SIuOMiWFmjtgV2QvoBtw5OpiYnIs1FtaXsK/C2OaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e6A+XVLcPNLMwESEyueodgvH20aogrinLt8IHP7JLiav1mjuv9iBK3j3H+gsaeGEA
	 TRHUPeZiKGnnckMPa7m53eDQEVXJEAKC7ZIZEmtxf4eHcQiGTQ69SeddnpJmBr2NSa
	 juD5lEYubD370CxevcqTNgL03R8fCaq1acShGgrgw2RlXByQYpFykeXFoejKIMotJc
	 hNWChV2ja9ceDUXUxsN26VijxnczwFfb9pD5NhfWbCCn4frwFMC7qOINrvTDtbEKim
	 0W5RWX9q4PQ8g0yQsx2uMKwC/hoH+7G73p2EwAghfx6hR+lVOE+fiSpbFXYuTU2WzF
	 63nghwL5iIpPQ==
Message-ID: <e30308d3-b70a-40f9-9c4a-b3a777bbe45a@kernel.org>
Date: Tue, 3 Mar 2026 10:23:54 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: memcg: factor out trylock_stock() and
 unlock_stock()
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <jweiner@meta.com>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-2-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302195305.620713-2-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/2/26 20:50, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Consolidate the local lock acquisition and the local stock
> lookup. This allows subsequent patches to use !!stock as an easy way
> to disambiguate the locked vs. contended cases through the callstack.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

nit:

> ---
>  mm/memcontrol.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 753d76e96cc6..a975ab3aee10 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3208,6 +3208,19 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
>  	obj_cgroup_put(objcg);
>  }
>  
> +static struct obj_stock_pcp *trylock_stock(void)
> +{
> +	if (local_trylock(&obj_stock.lock))
> +		return this_cpu_ptr(&obj_stock);
> +
> +	return NULL;
> +}
> +
> +static void unlock_stock(struct obj_stock_pcp *stock)
> +{
> +	local_unlock(&obj_stock.lock);
> +}

Could have added inline's there. The compiler heuristics can be sometimes
unpredictable.

