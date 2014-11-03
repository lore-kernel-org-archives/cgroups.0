From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: remove stale page_cgroup_lock comment
Date: Mon, 3 Nov 2014 16:28:48 +0100
Message-ID: <20141103152848.GD10156@dhcp22.suse.cz>
References: <1414898060-4658-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1414898060-4658-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat 01-11-14 23:14:20, Johannes Weiner wrote:
> There is no cgroup-specific page lock anymore.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 38f0647a2f12..d20928597a07 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2467,10 +2467,6 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
>  	int isolated;
>  
>  	VM_BUG_ON_PAGE(pc->mem_cgroup, page);
> -	/*
> -	 * we don't need page_cgroup_lock about tail pages, becase they are not
> -	 * accessed by any other context at this point.
> -	 */
>  
>  	/*
>  	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
> -- 
> 2.1.3
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
