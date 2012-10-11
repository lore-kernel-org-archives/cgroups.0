From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v4 10/14] memcg: use static branches when code not in use
Date: Thu, 11 Oct 2012 15:40:28 +0200
Message-ID: <20121011134028.GH29295@dhcp22.suse.cz>
References: <1349690780-15988-1-git-send-email-glommer@parallels.com>
 <1349690780-15988-11-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1349690780-15988-11-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Mon 08-10-12 14:06:16, Glauber Costa wrote:
> We can use static branches to patch the code in or out when not used.
> 
> Because the _ACTIVE bit on kmem_accounted is only set after the
> increment is done, we guarantee that the root memcg will always be
> selected for kmem charges until all call sites are patched (see
> memcg_kmem_enabled).  This guarantees that no mischarges are applied.
> 
> static branch decrement happens when the last reference count from the
> kmem accounting in memcg dies. This will only happen when the charges
> drop down to 0.
> 
> When that happen, we need to disable the static branch only on those
> memcgs that enabled it. To achieve this, we would be forced to
> complicate the code by keeping track of which memcgs were the ones
> that actually enabled limits, and which ones got it from its parents.
> 
> It is a lot simpler just to do static_key_slow_inc() on every child
> that is accounted.
> 
> [ v4: adapted this patch to the changes in kmem_accounted ]
> 
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Looks reasonable to me
Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Just a little nit.

[...]

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 634c7b5..724a08b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -344,11 +344,15 @@ struct mem_cgroup {
>  /* internal only representation about the status of kmem accounting. */
>  enum {
>  	KMEM_ACCOUNTED_ACTIVE = 0, /* accounted by this cgroup itself */
> +	KMEM_ACCOUNTED_ACTIVATED, /* static key enabled. */
>  	KMEM_ACCOUNTED_DEAD, /* dead memcg, pending kmem charges */
>  };
>  
> -/* first bit */
> -#define KMEM_ACCOUNTED_MASK 0x1
> +/*
> + * first two bits. We account when limit is on, but only after
> + * call sites are patched
> + */
> +#define KMEM_ACCOUNTED_MASK 0x3

The names are long but why not use KMEM_ACCOUNTED_ACTIVE*
#define KMEM_ACCOUNTED_MASK 1<<KMEM_ACCOUNTED_ACTIVE | 1<<KMEM_ACCOUNTED_ACTIVATED

[...]
-- 
Michal Hocko
SUSE Labs
