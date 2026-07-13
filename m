Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FDA35F61A;
	Mon, 13 Jul 2026 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783938271; cv=none; b=MlcjUgGuEEUvQojlDITvvhioELKdkkts1yW5+XzxRWVVmCGjmXh2M5Vp119LC/jIxryUo1P9Z258vf9N1k+1BbfT8uF2BcxLSeNs0x/UCCfqG0lc7qW589HTbSIZUyAOGFMyu3Y9W7C7qGKTutkmQgnqp90OGUkOEPG5t8ODYlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783938271; c=relaxed/simple;
	bh=N6ENnk3rgY035vjNsHIRv2m6en78KY1ZwtwIFc+ebh8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=I2r4M/2BhworIZTvl4HegZpZcaobASu4yBBIPFf/vBWGc53Zxk+X9fIhdWvZjL+OL3LU0itwsT7pNdbLMuUXCUcetev5IUZWYTOBxt3QY3yvNwtetwWYWUaeyXqG8A7lFsMvnzpjilkpk5BBbd0xTU1hAeUQY5Gld0A6zwO92GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uvMmJ6cU; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uvMmJ6cU"
Message-ID: <1bd1dd99-4db0-4120-bebf-b1da42977778@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783938267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nlpe1/nwJgVHs+1CgELsGk74K3Ki4WuxEiQer53NK8w=;
	b=uvMmJ6cUAyBsmzFEXhT9EaxuwrEH+WOZ9I2vr8S7uIrGuNyoIhqebiAcV8/uYTDFI52Mop
	rtyUJEmCxdapuezObmHKvTA8N7XA0oUHZ5RTvMJX3BMHFgoH0swoYx44FF89YtuVo3kVxh
	zW3velkdD7gVnpzhzlfybnpoaCRkLyg=
Date: Mon, 13 Jul 2026 18:24:14 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
To: Guopeng Zhang <guopeng.zhang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
References: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



在 2026/7/13 17:03, Guopeng Zhang 写道:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
> memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
> in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
> small memcg_uncharge_kmem() helper. The reference get/put stays at the
> call sites, as they differ.
> 
> No functional change.

Acked-by: Tao Cui <cuitao@kylinos.cn>

> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 22f55aeb94f3..86acfe55a201 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -137,6 +137,14 @@ bool mem_cgroup_kmem_disabled(void)
>  
>  static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
>  
> +static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
> +{
> +	mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> +	memcg1_account_kmem(memcg, -nr_pages);
> +	if (!mem_cgroup_is_root(memcg))
> +		memcg_uncharge(memcg, nr_pages);
> +}
> +
>  static void obj_cgroup_release(struct percpu_ref *ref)
>  {
>  	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
> @@ -172,10 +180,7 @@ static void obj_cgroup_release(struct percpu_ref *ref)
>  		struct mem_cgroup *memcg;
>  
>  		memcg = get_mem_cgroup_from_objcg(objcg);
> -		mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> -		memcg1_account_kmem(memcg, -nr_pages);
> -		if (!mem_cgroup_is_root(memcg))
> -			memcg_uncharge(memcg, nr_pages);
> +		memcg_uncharge_kmem(memcg, nr_pages);
>  		mem_cgroup_put(memcg);
>  	}
>  
> @@ -3329,10 +3334,7 @@ static void drain_obj_stock_slot(struct obj_stock_pcp *stock, int i)
>  
>  			memcg = get_mem_cgroup_from_objcg(old);
>  
> -			mod_memcg_state(memcg, MEMCG_KMEM, -nr_pages);
> -			memcg1_account_kmem(memcg, -nr_pages);
> -			if (!mem_cgroup_is_root(memcg))
> -				memcg_uncharge(memcg, nr_pages);
> +			memcg_uncharge_kmem(memcg, nr_pages);
>  
>  			css_put(&memcg->css);
>  		}

