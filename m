From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: remove rcu_read_lock from
 get_mem_cgroup_from_page
Date: Fri, 5 Feb 2021 09:36:44 +0100
Message-ID: <YB0DnAlCaQza4Uf9@dhcp22.suse.cz>
References: <20210205062719.74431-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1612514205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TPEtPSJTJFr+uqHAFw8+/pwPBdso+nWGktyWxW/+4Bk=;
        b=RyIyP8hptBgLl6GItYcCzNcgE23w04gkI+vhzyGupcf+vAkfOBL3NGDJoMkbwLULc7ZOIn
        KgXw1u/bFSbp2L2QMKEeMyfURJzyEQieaBdVVcZe5DvlRVdsYV0BXNd/oZSCCN5ElKdFKQ
        SsPnoVS4Z5uDTEN2uywLQ/P8ZTj2OaA=
Content-Disposition: inline
In-Reply-To: <20210205062719.74431-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 05-02-21 14:27:19, Muchun Song wrote:
> The get_mem_cgroup_from_page() is called under page lock, so the page
> memcg cannot be changed under us.

Where is the page lock enforced?

> Also, css_get is enough because page
> has a reference to the memcg.

tryget used to be there to guard against offlined memcg but we have
concluded this is impossible in this path. tryget stayed there to catch
some unexpected cases IIRC.

> If we really want to make the get_mem_cgroup_from_page() suitable for
> arbitrary page, we should use page_memcg_rcu() instead of page_memcg()
> and call it after rcu_read_lock().

What is the primary motivation to change this code? is the overhead of
tryget/RCU something that needs optimizing?
 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/memcontrol.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 87f01bc05d1f..6c7f1ea3955e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1063,16 +1063,15 @@ EXPORT_SYMBOL(get_mem_cgroup_from_mm);
>   */
>  struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
>  {
> -	struct mem_cgroup *memcg = page_memcg(page);
> +	struct mem_cgroup *memcg;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> -	rcu_read_lock();
>  	/* Page should not get uncharged and freed memcg under us. */
> -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
> -		memcg = root_mem_cgroup;
> -	rcu_read_unlock();
> +	memcg = page_memcg(page) ? : root_mem_cgroup;
> +	css_get(&memcg->css);
> +
>  	return memcg;
>  }
>  EXPORT_SYMBOL(get_mem_cgroup_from_page);
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
