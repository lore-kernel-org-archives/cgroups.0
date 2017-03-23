From: Vladimir Davydov <vdavydov@tarantool.org>
Subject: Re: [PATCH] mm: workingset: fix premature shadow node shrinking with
 cgroups
Date: Thu, 23 Mar 2017 11:28:22 +0300
Message-ID: <20170323082822.GA17625@esperanza>
References: <20170322005320.8165-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=UwJksYM29U/4hvcaOVl/RokullR7bgc39taDUvDxqZ4=;
	b=eNzdci6FQPKLF+UiZ9PFAdeA9HMJtY7KneQANmUTR1SJDmaZ5d/9sDz7E1xXdCX0UmV3e9EAAnyZWhrn/MGKyUt9bwJWjHLHolpMf/GYMfyr+Eiu0clHA6nxSNuqBKstKhOFq9z47tpYEQN8kkxq2IQE2Q4ZNt+F0kBM1ze7zrM=;
Content-Disposition: inline
In-Reply-To: <20170322005320.8165-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Mar 21, 2017 at 08:53:20PM -0400, Johannes Weiner wrote:
> 0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
> enabled cgroup-awareness in the shadow node shrinker, but forgot to
> also enable cgroup-awareness in the list_lru the shadow nodes sit on.
> 
> Consequently, all shadow nodes are sitting on a global (per-NUMA node)
> list, while the shrinker applies the limits according to the amount of
> cache in the cgroup its shrinking. The result is excessive pressure on
> the shadow nodes from cgroups that have very little cache.
> 
> Enable memcg-mode on the shadow node LRUs, such that per-cgroup limits
> are applied to per-cgroup lists.
> 
> Fixes: 0a6b76dd23fa ("mm: workingset: make shadow node shrinker memcg aware")
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: <stable@vger.kernel.org> # 4.6+

Acked-by: Vladimir Davydov <vdavydov@tarantool.org>

> ---
>  mm/workingset.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index ac839fca0e76..eda05c71fa49 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -532,7 +532,7 @@ static int __init workingset_init(void)
>  	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
>  	       timestamp_bits, max_order, bucket_order);
>  
> -	ret = list_lru_init_key(&shadow_nodes, &shadow_nodes_key);
> +	ret = __list_lru_init(&shadow_nodes, true, &shadow_nodes_key);
>  	if (ret)
>  		goto err;
>  	ret = register_shrinker(&workingset_shadow_shrinker);
> -- 
> 2.12.0
> 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
