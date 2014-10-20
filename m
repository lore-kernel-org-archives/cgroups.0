From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch] mm: memcontrol: update mem_cgroup_page_lruvec()
 documentation
Date: Mon, 20 Oct 2014 21:12:56 +0200
Message-ID: <20141020191256.GD505@dhcp22.suse.cz>
References: <1413732616-15962-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=toVy/uvqWQsid/EC7u7WF0n8osB+leFOdk5h+oemxJw=;
        b=MNaH6LLQDEzWy4BJhW4cwSxZL5ZFwUf1S5tostUN4LJ6ZWcomjrx6Jq+EEo1pYSMQM
         NSYjOf/UNRR1GHF4lxVWNY0wQ4rlQGi1P1lhl0gp71YyfWElLTZctXzlxkxHEgxyacAh
         F0voJ2ik7/zqOjEnXML/tWGYE6iH3YftU6jYOEBpDMdNmmKn0e4urFmCus0QL+gVV7xa
         5BlI7xhg9TIN413XLc8Si3sbRUoh4PawLnXGs/xV2ylu1ClM4E0efhp8O7rYr6K2ZTSl
         OQ/8aLoOcRPqoD9urZ7aHxZXJZvWNgOo/ggACL2D+V4EOxNhoeFX1Po/AkzauqJErPx8
         PZpw==
Content-Disposition: inline
In-Reply-To: <1413732616-15962-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun 19-10-14 11:30:16, Johannes Weiner wrote:
> 7512102cf64d ("memcg: fix GPF when cgroup removal races with last
> exit") added a pc->mem_cgroup reset into mem_cgroup_page_lruvec() to
> prevent a crash where an anon page gets uncharged on unmap, the memcg
> is released, and then the final LRU isolation on free dereferences the
> stale pc->mem_cgroup pointer.
> 
> But since 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API"), pages
> are only uncharged AFTER that final LRU isolation, which guarantees
> the memcg's lifetime until then.  pc->mem_cgroup now only needs to be
> reset for swapcache readahead pages.

Do we want VM_BUG_ON_PAGE(!PageSwapCache, page) into the fixup path?

> Update the comment and callsite requirements accordingly.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3a203c7ec6c7..fc1d7ca96b9d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1262,9 +1262,13 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
>  }
>  
>  /**
> - * mem_cgroup_page_lruvec - return lruvec for adding an lru page
> + * mem_cgroup_page_lruvec - return lruvec for isolating/putting an LRU page
>   * @page: the page
>   * @zone: zone of the page
> + *
> + * This function is only safe when following the LRU page isolation
> + * and putback protocol: the LRU lock must be held, and the page must
> + * either be PageLRU() or the caller must have isolated/allocated it.
>   */
>  struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
>  {
> @@ -1282,13 +1286,9 @@ struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct zone *zone)
>  	memcg = pc->mem_cgroup;
>  
>  	/*
> -	 * Surreptitiously switch any uncharged offlist page to root:
> -	 * an uncharged page off lru does nothing to secure
> -	 * its former mem_cgroup from sudden removal.
> -	 *
> -	 * Our caller holds lru_lock, and PageCgroupUsed is updated
> -	 * under page_cgroup lock: between them, they make all uses
> -	 * of pc->mem_cgroup safe.
> +	 * Swapcache readahead pages are added to the LRU - and
> +	 * possibly migrated - before they are charged.  Ensure
> +	 * pc->mem_cgroup is sane.
>  	 */
>  	if (!PageLRU(page) && !PageCgroupUsed(pc) && memcg != root_mem_cgroup)
>  		pc->mem_cgroup = memcg = root_mem_cgroup;
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
