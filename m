From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Date: Wed, 3 Dec 2014 10:22:31 -0500
Message-ID: <20141203152231.GA2822@phnom.home.cmpxchg.org>
References: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1417560083-27157-1-git-send-email-rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 02, 2014 at 11:41:23PM +0100, Rickard Strandqvist wrote:
> Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist-IW2WV5XWFqGZkjO+N0TKoMugMpMbD5Xr@public.gmane.org>
> ---
>  mm/memcontrol.c |    5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d6ac0e3..5edd1fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4379,11 +4379,6 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>  }
>  #endif /* CONFIG_NUMA */
>  
> -static inline void mem_cgroup_lru_names_not_uptodate(void)
> -{
> -	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> -}

That assertion doesn't work in an unused function, but we still want
this check.  Please move the BUILD_BUG_ON() to the beginning of
memcg_stat_show() instead.
