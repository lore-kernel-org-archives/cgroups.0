From: David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/memcg: remove unneeded nr_scanned
Date: Mon, 28 Mar 2022 16:16:36 +0200
Message-ID: <02a7f297-b9fd-1c32-b4ea-92779dfe56ab@redhat.com>
References: <20220328114144.53389-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648477008;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4R1I/hCcAQyQZ62VKidYDJvIMBja7RGHE6ljlNOv9w=;
        b=HNXL1DOmjO7jQtIdsLaAPORm6oxNB9jfl0EZe8qs9CkD4qDxDG44Zif5hPMq6zskVqZzVq
        WJantjtfepWCnzf+JWUqgvqWol91WfnoS1cxFq+OVdMdGWmagOhnd6wXWCJ+5Rb4DLSt2U
        Ik2xjigdWEVYs91Gk3YBQHEuHSIL+Fw=
Content-Language: en-US
In-Reply-To: <20220328114144.53389-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe@huawei.com>, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On 28.03.22 13:41, Miaohe Lin wrote:
> The local variable nr_scanned is unneeded as mem_cgroup_soft_reclaim always
> does *total_scanned += nr_scanned. So we can pass total_scanned directly to
> the mem_cgroup_soft_reclaim to simplify the code and save some cpu cycles
> of adding nr_scanned to total_scanned.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  mm/memcontrol.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b686ec4f42c6..79341365ec90 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3384,7 +3384,6 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  	int loop = 0;
>  	struct mem_cgroup_tree_per_node *mctz;
>  	unsigned long excess;
> -	unsigned long nr_scanned;
>  
>  	if (order > 0)
>  		return 0;
> @@ -3412,11 +3411,9 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  		if (!mz)
>  			break;
>  
> -		nr_scanned = 0;
>  		reclaimed = mem_cgroup_soft_reclaim(mz->memcg, pgdat,
> -						    gfp_mask, &nr_scanned);
> +						    gfp_mask, total_scanned);
>  		nr_reclaimed += reclaimed;
> -		*total_scanned += nr_scanned;
>  		spin_lock_irq(&mctz->lock);
>  		__mem_cgroup_remove_exceeded(mz, mctz);
>  

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

