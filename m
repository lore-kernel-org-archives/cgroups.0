From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 28 Aug 2015 19:49:18 +0300
Message-ID: <20150828164918.GJ9610@esperanza>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440775530-18630-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Aug 28, 2015 at 11:25:30AM -0400, Tejun Heo wrote:
> On the default hierarchy, all memory consumption will be accounted
> together and controlled by the same set of limits.  Always enable
> kmemcg on the default hierarchy.

IMO we should introduce a boot time knob for disabling it, because kmem
accounting is still not perfect, besides some users might prefer to go
w/o it for performance reasons.

> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  mm/memcontrol.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c94b686..8a5dd01 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4362,6 +4362,13 @@ mem_cgroup_css_online(struct cgroup_subsys_state *css)
>  	if (ret)
>  		return ret;
>  
> +	/* kmem is always accounted together on the default hierarchy */
> +	if (cgroup_on_dfl(css->cgroup)) {
> +		ret = memcg_activate_kmem(memcg, PAGE_COUNTER_MAX);
> +		if (ret)
> +			return ret;
> +	}
> +

This is a wrong place for this. The kernel will panic on an attempt to
create a sub memcg, because memcg_init_kmem already enables kmem
accounting in this case. I guess we should add this hunk to
memcg_propagate_kmem instead.

Thanks,
Vladimir
