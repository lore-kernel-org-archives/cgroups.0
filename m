From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: update page struct member in comments
Date: Fri, 6 Nov 2020 10:45:27 -0800
Message-ID: <20201106184527.GD3976735@iweiny-DESK2.sc.intel.com>
References: <1604662413-5734-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1604662413-5734-1-git-send-email-alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 06, 2020 at 07:33:33PM +0800, Alex Shi wrote:
> The page->mem_cgroup member is replaced by memcg_data, and add a helper
> page_memcg() for it. Need to update comments to avoid confusing.

I'm not an expert in this code but IMO the pointer manipulation of
page->mem_cgroup could be thought of as local to the code in mm/memcontrol.c.
As such the detail of the member of the page struct that the code depends on is
a valuable part of the comment.  Having to look at page_memcg() to find out
this information is kind of annoying.

Ira

> 
> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> 
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> 
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> 
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> 
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org 
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org 
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b2aa3b73ab82..8a8debea34fc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1310,7 +1310,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>   * @page: the page
>   * @pgdat: pgdat of the page
>   *
> - * This function relies on page->mem_cgroup being stable - see the
> + * This function relies on page_memcg(page) being stable - see the
>   * access rules in commit_charge().
>   */
>  struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
> @@ -2862,7 +2862,7 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg)
>  {
>  	VM_BUG_ON_PAGE(page_memcg(page), page);
>  	/*
> -	 * Any of the following ensures page->mem_cgroup stability:
> +	 * Any of the following ensures page_memcg(page) stability:
>  	 *
>  	 * - the page lock
>  	 * - LRU isolation
> -- 
> 1.8.3.1
> 
