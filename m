From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH 2/4] mm: memcontrol: reign in the CONFIG space madness
Date: Sat, 12 Dec 2015 19:33:32 +0300
Message-ID: <20151212163332.GC28521@esperanza>
References: <1449863653-6546-1-git-send-email-hannes@cmpxchg.org>
 <1449863653-6546-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1449863653-6546-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Dec 11, 2015 at 02:54:11PM -0500, Johannes Weiner wrote:
> What CONFIG_INET and CONFIG_LEGACY_KMEM guard inside the memory
> controller code is insignificant, having these conditionals is not
> worth the complication and fragility that comes with them.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vladimir Davydov <vdavydov@virtuozzo.com>

> @@ -4374,17 +4342,11 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
> -#ifdef CONFIG_INET
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
>  		static_branch_dec(&memcg_sockets_enabled_key);
> -#endif
> -
> -	memcg_free_kmem(memcg);

I wonder where the second call to memcg_free_kmem comes from. Luckily,
it couldn't result in a breakage. And now it's removed.

>  
> -#if defined(CONFIG_MEMCG_LEGACY_KMEM) && defined(CONFIG_INET)
>  	if (memcg->tcp_mem.active)
>  		static_branch_dec(&memcg_sockets_enabled_key);
> -#endif
>  
>  	memcg_free_kmem(memcg);
>  

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
