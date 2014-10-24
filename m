From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 2/3] mm: memcontrol: pull the NULL check from
 __mem_cgroup_same_or_subtree()
Date: Fri, 24 Oct 2014 20:30:32 +0200
Message-ID: <20141024183032.GB18956@dhcp22.suse.cz>
References: <1414158589-26094-1-git-send-email-hannes@cmpxchg.org>
 <1414158589-26094-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QhYI8F/Lt+sA2TlrovLbyaN0Ee2NwYCg4pgg5M/OTyA=;
        b=LkJpaRj3JQe+yXJywyQp1DK2KKtBKgd6ONYhp/tiQFEJJiWw8GMDcnLSxNIdCasnID
         A7VSc1IrUPo65kbyiS8qlBXPkQWiQEWPHeA+EIajLckkGOZPACN/BCQFyyHQmuEEMWbV
         CdbYkWDG7bwPQ2nr0BOc2QJJj9MXjvo15IwF7j43QYshuMtxoFlf0KZjw1tPm9YSGJE8
         NHBBVyuTSNcLxNOpYTknvj+UYnaMzHUOxCwOsq6/t11VLYzFtiVycM81n3yRgHdwssnM
         i8icj0h7IJYQCGd5/8+MFRusRE+69nKOM4NB3I+5AxpSUj+70zq4h8An2iKwhYnJtPuY
         KwCg==
Content-Disposition: inline
In-Reply-To: <1414158589-26094-2-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@parallels.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri 24-10-14 09:49:48, Johannes Weiner wrote:
> The NULL in mm_match_cgroup() comes from a possibly exiting mm->owner.
> It makes a lot more sense to check where it's looked up, rather than
> check for it in __mem_cgroup_same_or_subtree() where it's unexpected.
> 
> No other callsite passes NULL to __mem_cgroup_same_or_subtree().

Much better!

> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  include/linux/memcontrol.h | 5 +++--
>  mm/memcontrol.c            | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index ea007615e8f9..e32ab948f589 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -83,11 +83,12 @@ static inline
>  bool mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup *task_memcg;
> -	bool match;
> +	bool match = false;
>  
>  	rcu_read_lock();
>  	task_memcg = mem_cgroup_from_task(rcu_dereference(mm->owner));
> -	match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
> +	if (task_memcg)
> +		match = __mem_cgroup_same_or_subtree(memcg, task_memcg);
>  	rcu_read_unlock();
>  	return match;
>  }
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bdf8520979cf..15b1c5110a8f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1316,7 +1316,7 @@ bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
>  {
>  	if (root_memcg == memcg)
>  		return true;
> -	if (!root_memcg->use_hierarchy || !memcg)
> +	if (!root_memcg->use_hierarchy)
>  		return false;
>  	return cgroup_is_descendant(memcg->css.cgroup, root_memcg->css.cgroup);
>  }
> -- 
> 2.1.2
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
