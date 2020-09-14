From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Correct the comment of mem_cgroup_iter()
Date: Mon, 14 Sep 2020 12:46:42 +0200
Message-ID: <20200914104642.GJ16999@dhcp22.suse.cz>
References: <20200913094129.44558-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200913094129.44558-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun 13-09-20 05:41:29, Miaohe Lin wrote:
> Since commit bbec2e15170a ("mm: rename page_counter's count/limit into
> usage/max"), the arg @reclaim has no priority field anymore.

The priority field has been removed by 9da83f3fc74b ("mm, memcg: clean
up reclaim iter array")
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Other than that
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 75cd1a1e66c8..a57aa0f42d40 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1138,9 +1138,9 @@ static __always_inline struct mem_cgroup *get_mem_cgroup_from_current(void)
>   * invocations for reference counting, or use mem_cgroup_iter_break()
>   * to cancel a hierarchy walk before the round-trip is complete.
>   *
> - * Reclaimers can specify a node and a priority level in @reclaim to
> - * divide up the memcgs in the hierarchy among all concurrent
> - * reclaimers operating on the same node and priority.
> + * Reclaimers can specify a node in @reclaim to divide up the memcgs
> + * in the hierarchy among all concurrent reclaimers operating on the
> + * same node.
>   */
>  struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  				   struct mem_cgroup *prev,
> -- 
> 2.19.1

-- 
Michal Hocko
SUSE Labs
