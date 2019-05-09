From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] memcg: make it work on sparse non-0-node systems
Date: Thu, 9 May 2019 09:21:41 +0200
Message-ID: <414a361f-90c5-36ef-e290-c3551595e854@suse.cz>
References: <359d98e6-044a-7686-8522-bdd2489e9456@suse.cz>
 <20190429105939.11962-1-jslaby@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190429105939.11962-1-jslaby@suse.cz>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Vladimir,

as you are perhaps the one most familiar with the code, could you take a
look on this?

On 29. 04. 19, 12:59, Jiri Slaby wrote:
> We have a single node system with node 0 disabled:
>   Scanning NUMA topology in Northbridge 24
>   Number of physical nodes 2
>   Skipping disabled node 0
>   Node 1 MemBase 0000000000000000 Limit 00000000fbff0000
>   NODE_DATA(1) allocated [mem 0xfbfda000-0xfbfeffff]
> 
> This causes crashes in memcg when system boots:
>   BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>   #PF error: [normal kernel read fault]
> ...
>   RIP: 0010:list_lru_add+0x94/0x170
> ...
>   Call Trace:
>    d_lru_add+0x44/0x50
>    dput.part.34+0xfc/0x110
>    __fput+0x108/0x230
>    task_work_run+0x9f/0xc0
>    exit_to_usermode_loop+0xf5/0x100
> 
> It is reproducible as far as 4.12. I did not try older kernels. You have
> to have a new enough systemd, e.g. 241 (the reason is unknown -- was not
> investigated). Cannot be reproduced with systemd 234.
> 
> The system crashes because the size of lru array is never updated in
> memcg_update_all_list_lrus and the reads are past the zero-sized array,
> causing dereferences of random memory.
> 
> The root cause are list_lru_memcg_aware checks in the list_lru code.
> The test in list_lru_memcg_aware is broken: it assumes node 0 is always
> present, but it is not true on some systems as can be seen above.
> 
> So fix this by checking the first online node instead of node 0.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: <cgroups@vger.kernel.org>
> Cc: <linux-mm@kvack.org>
> Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  mm/list_lru.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 0730bf8ff39f..7689910f1a91 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -37,11 +37,7 @@ static int lru_shrinker_id(struct list_lru *lru)
>  
>  static inline bool list_lru_memcg_aware(struct list_lru *lru)
>  {
> -	/*
> -	 * This needs node 0 to be always present, even
> -	 * in the systems supporting sparse numa ids.
> -	 */
> -	return !!lru->node[0].memcg_lrus;
> +	return !!lru->node[first_online_node].memcg_lrus;
>  }
>  
>  static inline struct list_lru_one *
> 


-- 
js
suse labs
