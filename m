From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: remove useless check on page->mem_cgroup
Date: Mon, 10 Aug 2020 11:55:00 +0200
Message-ID: <20200810095500.GE4773@dhcp22.suse.cz>
References: <1596166480-22814-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200731151655.GB491801@cmpxchg.org>
 <9338716f-ca0e-057f-8d94-03e2b3f70281@linux.alibaba.com>
 <20200803081815.GD5174@dhcp22.suse.cz>
 <bd61e672-b997-c4cd-2047-fca9dc11cc4c@linux.alibaba.com>
 <92dd8e68-8095-72c5-0144-2a084e4d5993@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <92dd8e68-8095-72c5-0144-2a084e4d5993-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 05-08-20 20:28:33, Alex Shi wrote:
[...]
> >From 2ca3e87fd3878ab729551682ad083a70f15bb3fc Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Date: Sat, 1 Aug 2020 10:43:55 +0800
> Subject: [PATCH v3] mm/memcg: warning on !memcg after readahead page charged
> 
> Since readahead page is charged on memcg too, in theory we don't have to
> check this exception now. Before safely remove them all, add a warning
> for the unexpected !memcg.
> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Looks good to me. I am not familiar with the section tweaks but that
should be ok.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Once you collect more feedback, please send both patches so that they do
not get lost in this thread.

Thanks!

> ---
>  include/linux/mmdebug.h | 13 +++++++++++++
>  mm/memcontrol.c         | 15 ++++++++-------
>  2 files changed, 21 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index 2ad72d2c8cc5..4ed52879ce55 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -37,6 +37,18 @@
>  			BUG();						\
>  		}							\
>  	} while (0)
> +#define VM_WARN_ON_ONCE_PAGE(cond, page)	({			\
> +	static bool __section(.data.once) __warned;			\
> +	int __ret_warn_once = !!(cond);					\
> +									\
> +	if (unlikely(__ret_warn_once && !__warned)) {			\
> +		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
> +		__warned = true;					\
> +		WARN_ON(1);						\
> +	}								\
> +	unlikely(__ret_warn_once);					\
> +})
> +
>  #define VM_WARN_ON(cond) (void)WARN_ON(cond)
>  #define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
>  #define VM_WARN_ONCE(cond, format...) (void)WARN_ONCE(cond, format)
> @@ -48,6 +60,7 @@
>  #define VM_BUG_ON_MM(cond, mm) VM_BUG_ON(cond)
>  #define VM_WARN_ON(cond) BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
> +#define VM_WARN_ON_ONCE_PAGE(cond, page)  BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN_ONCE(cond, format...) BUILD_BUG_ON_INVALID(cond)
>  #define VM_WARN(cond, format...) BUILD_BUG_ON_INVALID(cond)
>  #endif
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 130093bdf74b..299382fc55a9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1322,10 +1322,8 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgd
>  	}
>  
>  	memcg = page->mem_cgroup;
> -	/*
> -	 * Swapcache readahead pages are added to the LRU - and
> -	 * possibly migrated - before they are charged.
> -	 */
> +	/* Readahead page is charged too, to see if other page uncharged */
> +	VM_WARN_ON_ONCE_PAGE(!memcg, page);
>  	if (!memcg)
>  		memcg = root_mem_cgroup;
>  
> @@ -6906,8 +6904,9 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  	if (newpage->mem_cgroup)
>  		return;
>  
> -	/* Swapcache readahead pages can get replaced before being charged */
>  	memcg = oldpage->mem_cgroup;
> +	/* Readahead page is charged too, to see if other page uncharged */
> +	VM_WARN_ON_ONCE_PAGE(!memcg, oldpage);
>  	if (!memcg)
>  		return;
>  
> @@ -7104,7 +7103,8 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  
>  	memcg = page->mem_cgroup;
>  
> -	/* Readahead page, never charged */
> +	/* Readahead page is charged too, to see if other page uncharged */
> +	VM_WARN_ON_ONCE_PAGE(!memcg, page);
>  	if (!memcg)
>  		return;
>  
> @@ -7168,7 +7168,8 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
>  
>  	memcg = page->mem_cgroup;
>  
> -	/* Readahead page, never charged */
> +	/* Readahead page is charged too, to see if other page uncharged */
> +	VM_WARN_ON_ONCE_PAGE(!memcg, page);
>  	if (!memcg)
>  		return 0;
>  
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
