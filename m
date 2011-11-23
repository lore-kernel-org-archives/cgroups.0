From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 7/8] mm: memcg: modify PageCgroupAcctLRU non-atomically
Date: Wed, 23 Nov 2011 10:52:39 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1111231039390.2175@sister.anvils>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org> <1322062951-1756-8-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=BKTHSeIt7cjPI1sPB/ky3litC/4xgoU7bQ3Fp/mfwRc=;
        b=d4MGw7XoSfwgBaO/P2WC4gKhcj9FnbLBfnuA6R14ZJDuurYq0FjI9rrb4RxqeQnTRL
         nWlSYaG2CM5JUEUcgPSg==
In-Reply-To: <1322062951-1756-8-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 23 Nov 2011, Johannes Weiner wrote:

> From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> This bit is protected by zone->lru_lock, there is no need for locked
> operations when setting and clearing it.
> 
> Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Unless there are special considerations which you have not mentioned at
all in the description above, this 7/8 and the similar 8/8 are mistaken.

The atomic operation is not for guaranteeing the setting and clearing
of the bit in question: it's for guaranteeing that you don't accidentally
set or clear any of the other bits in the same word when you're doing so,
if another task is updating them at the same time as you're doing this.

There are circumstances when non-atomic shortcuts can be taken, when
you're sure the field cannot yet be visible to other tasks (we do that
when setting PageLocked on a freshly allocated page, for example - but
even then have to rely on others using get_page_unless_zero properly).
But I don't think that's the case here.

Hugh

> ---
>  include/linux/page_cgroup.h |   16 ++++++++++++----
>  mm/memcontrol.c             |    4 ++--
>  2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index aaa60da..a0bc9d0 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -57,14 +57,23 @@ static inline int PageCgroup##uname(struct page_cgroup *pc)	\
>  #define SETPCGFLAG(uname, lname)			\
>  static inline void SetPageCgroup##uname(struct page_cgroup *pc)\
>  	{ set_bit(PCG_##lname, &pc->flags);  }
> +#define __SETPCGFLAG(uname, lname)			\
> +static inline void __SetPageCgroup##uname(struct page_cgroup *pc)\
> +	{ __set_bit(PCG_##lname, &pc->flags);  }
>  
>  #define CLEARPCGFLAG(uname, lname)			\
>  static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
>  	{ clear_bit(PCG_##lname, &pc->flags);  }
> +#define __CLEARPCGFLAG(uname, lname)			\
> +static inline void __ClearPageCgroup##uname(struct page_cgroup *pc)	\
> +	{ __clear_bit(PCG_##lname, &pc->flags);  }
>  
>  #define TESTCLEARPCGFLAG(uname, lname)			\
>  static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
>  	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
> +#define __TESTCLEARPCGFLAG(uname, lname)			\
> +static inline int __TestClearPageCgroup##uname(struct page_cgroup *pc)	\
> +	{ return __test_and_clear_bit(PCG_##lname, &pc->flags);  }
>  
>  /* Cache flag is set only once (at allocation) */
>  TESTPCGFLAG(Cache, CACHE)
> @@ -75,11 +84,10 @@ TESTPCGFLAG(Used, USED)
>  CLEARPCGFLAG(Used, USED)
>  SETPCGFLAG(Used, USED)
>  
> -SETPCGFLAG(AcctLRU, ACCT_LRU)
> -CLEARPCGFLAG(AcctLRU, ACCT_LRU)
> +__SETPCGFLAG(AcctLRU, ACCT_LRU)
> +__CLEARPCGFLAG(AcctLRU, ACCT_LRU)
>  TESTPCGFLAG(AcctLRU, ACCT_LRU)
> -TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
> -
> +__TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
>  
>  SETPCGFLAG(FileMapped, FILE_MAPPED)
>  CLEARPCGFLAG(FileMapped, FILE_MAPPED)
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b9a3b94..51aba19 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -995,7 +995,7 @@ struct lruvec *mem_cgroup_lru_add_list(struct zone *zone, struct page *page,
>  		/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
>  		smp_rmb();
>  		memcg = pc->mem_cgroup;
> -		SetPageCgroupAcctLRU(pc);
> +		__SetPageCgroupAcctLRU(pc);
>  	} else
>  		memcg = root_mem_cgroup;
>  	mz = page_cgroup_zoneinfo(memcg, page);
> @@ -1031,7 +1031,7 @@ void mem_cgroup_lru_del_list(struct page *page, enum lru_list lru)
>  	 * LRU-accounting happened against pc->mem_cgroup or
>  	 * root_mem_cgroup.
>  	 */
> -	if (TestClearPageCgroupAcctLRU(pc)) {
> +	if (__TestClearPageCgroupAcctLRU(pc)) {
>  		VM_BUG_ON(!pc->mem_cgroup);
>  		memcg = pc->mem_cgroup;
>  	} else
> -- 
> 1.7.6.4
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
> 
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
