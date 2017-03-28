From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: rmap: fix huge file mmap accounting in the memcg
 stats
Date: Tue, 28 Mar 2017 16:52:46 +0200
Message-ID: <20170328145245.GL18241@dhcp22.suse.cz>
References: <20170322005111.3156-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170322005111.3156-1-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill@shutemov.name>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue 21-03-17 20:51:11, Johannes Weiner wrote:
> Huge pages are accounted as single units in the memcg's "file_mapped"
> counter. Account the correct number of base pages, like we do in the
> corresponding node counter.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

with the CC: stable 
Acked-by: Michal Hocko <mhocko@suse.com>

thanks!
> ---
>  include/linux/memcontrol.h | 6 ++++++
>  mm/rmap.c                  | 4 ++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index baa274150210..c5ebb32fef49 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -741,6 +741,12 @@ static inline bool mem_cgroup_oom_synchronize(bool wait)
>  	return false;
>  }
>  
> +static inline void mem_cgroup_update_page_stat(struct page *page,
> +					       enum mem_cgroup_stat_index idx,
> +					       int nr)
> +{
> +}
> +
>  static inline void mem_cgroup_inc_page_stat(struct page *page,
>  					    enum mem_cgroup_stat_index idx)
>  {
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1d82057144ba..f514cdd84482 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1154,7 +1154,7 @@ void page_add_file_rmap(struct page *page, bool compound)
>  			goto out;
>  	}
>  	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, nr);
> -	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
> +	mem_cgroup_update_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, nr);
>  out:
>  	unlock_page_memcg(page);
>  }
> @@ -1194,7 +1194,7 @@ static void page_remove_file_rmap(struct page *page, bool compound)
>  	 * pte lock(a spinlock) is held, which implies preemption disabled.
>  	 */
>  	__mod_node_page_state(page_pgdat(page), NR_FILE_MAPPED, -nr);
> -	mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
> +	mem_cgroup_update_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED, -nr);
>  
>  	if (unlikely(PageMlocked(page)))
>  		clear_page_mlock(page);
> -- 
> 2.12.0
> 

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
