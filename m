From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v3 12/13] execute the whole memcg freeing in rcu callback
Date: Mon, 24 Sep 2012 12:48:01 +0400
Message-ID: <50601E41.5000603@parallels.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com> <1347977050-29476-13-git-send-email-glommer@parallels.com> <20120921172355.GD7264@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120921172355.GD7264-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

> And the above description too makes me scratch my head quite a bit.  I
> can see what the patch is doing but can't understand the why.
> 
> * Why was it punting the freeing to workqueue anyway?  ISTR something
>   about static_keys but my memory fails.  What changed?  Why don't we
>   need it anymore?
> 
> * As for locking context, the above description seems a bit misleading
>   to me.  Synchronization constructs involved there currently doesn't
>   require softirq or irq safe context.  If that needs to change,
>   that's fine but that's a completely different reason than given
>   above.
> 
> Thanks.
> 

I just suck at changelogs =(

The problem here is very much like the one we had with static branches.
In that case, we had the problem with the cgroup_lock() being held, in
which case the jump label lock could not be called.

In here, after the kmem patches are in, the destruction function could
be called directly from memcg_kmem_uncharge_page() when the last put is
done. But this can actually be called from the page allocator, with an
incompatible softirq context. So it is not that it could be called, they
are actually called in that context at this point.

