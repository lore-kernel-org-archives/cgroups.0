From: "Huang\, Ying" <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: fix mem_cgroup_swapout() for THPs
Date: Wed, 29 Nov 2017 08:38:08 +0800
Message-ID: <87o9nlc427.fsf@yhuang-dev.intel.com>
References: <20171128161941.20931-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171128161941.20931-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> (Shakeel Butt's
        message of "Tue, 28 Nov 2017 08:19:41 -0800")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Huang Ying <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> writes:

> The commit d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout()
> support THP") changed mem_cgroup_swapout() to support transparent huge
> page (THP). However the patch missed one location which should be
> changed for correctly handling THPs. The resulting bug will cause the
> memory cgroups whose THPs were swapped out to become zombies on
> deletion.

Good catch!  Thanks a lot for fixing!

Best Regards,
Huang, Ying

> Fixes: d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 50e6906314f8..ac2ffd5e02b9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6044,7 +6044,7 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  	memcg_check_events(memcg, page);
>  
>  	if (!mem_cgroup_is_root(memcg))
> -		css_put(&memcg->css);
> +		css_put_many(&memcg->css, nr_entries);
>  }
>  
>  /**
