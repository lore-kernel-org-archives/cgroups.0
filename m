From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 06/14] memcg: kmem controller infrastructure
Date: Fri, 12 Oct 2012 11:47:26 +0200
Message-ID: <20121012094726.GH10110@dhcp22.suse.cz>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com>
 <1349690780-15988-7-git-send-email-glommer@parallels.com>
 <20121011124212.GC29295@dhcp22.suse.cz>
 <5077CAAA.3090709@parallels.com>
 <20121012083944.GD10110@dhcp22.suse.cz>
 <5077D889.2040100@parallels.com>
 <20121012085740.GG10110@dhcp22.suse.cz>
 <5077DF20.7020200@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5077DF20.7020200-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri 12-10-12 13:13:04, Glauber Costa wrote:
[...]
> Just so we don't ping-pong in another submission:
> 
> I changed memcontrol.h's memcg_kmem_newpage_charge to include:
> 
>         /* If the test is dying, just let it go. */
>         if (unlikely(test_thread_flag(TIF_MEMDIE)
>                      || fatal_signal_pending(current)))
>                 return true;

OK

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c32aaaf..72cf189 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> +static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
> +{
> +	struct res_counter *fail_res;
> +	struct mem_cgroup *_memcg;
> +	int ret = 0;
> +	bool may_oom;
> +
> +	ret = res_counter_charge(&memcg->kmem, size, &fail_res);
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Conditions under which we can wait for the oom_killer.
> +	 * We have to be able to wait, but also, if we can't retry,
> +	 * we obviously shouldn't go mess with oom.
> +	 */
> +	may_oom = (gfp & __GFP_WAIT) && !(gfp & __GFP_NORETRY);
> +
> +	_memcg = memcg;
> +	ret = __mem_cgroup_try_charge(NULL, gfp, size >> PAGE_SHIFT,
> +				      &_memcg, may_oom);
> +
> +	if (ret == -EINTR)  {
> +		/*
> +		 * __mem_cgroup_try_charge() chosed to bypass to root due to
> +		 * OOM kill or fatal signal.  Since our only options are to
> +		 * either fail the allocation or charge it to this cgroup, do
> +		 * it as a temporary condition. But we can't fail. From a
> +		 * kmem/slab perspective, the cache has already been selected,
> +		 * by mem_cgroup_get_kmem_cache(), so it is too late to change
> +		 * our minds. This condition will only trigger if the task
> +		 * entered memcg_charge_kmem in a sane state, but was
> +		 * OOM-killed.  during __mem_cgroup_try_charge. Tasks that are
> +		 * already dying when the allocation triggers should have been
> +		 * already directed to the root cgroup.
> +		 */
> +		res_counter_charge_nofail(&memcg->res, size, &fail_res);
> +		if (do_swap_account)
> +			res_counter_charge_nofail(&memcg->memsw, size,
> +						  &fail_res);
> +		ret = 0;
> +	} else if (ret)
> +		res_counter_uncharge(&memcg->kmem, size);
> +
> +	return ret;
> +}

OK
-- 
Michal Hocko
SUSE Labs
