From: Vladimir Davydov <vdavydov-mJ5StSI9eqKXDw4h08c5KA@public.gmane.org>
Subject: Re: [PATCH 8/9] slab: remove synchronous synchronize_sched() from
 memcg cache deactivation path
Date: Sat, 14 Jan 2017 16:57:27 +0300
Message-ID: <20170114135727.GG2668@esperanza>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-9-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tarantool.org; s=mailru;
        h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=54+oYKq7q+nqMsfF8oJdeyjfi+NcnG+VhFyBVSAs+MA=;
        b=JsX5CjBuMahQOMWjAfFrDQa+yoFgjxU2dD6T0Ky97JbBSoU3cAPoNO8OdJUWVuc+DrY5jBu3sxR6k8AHQPIq03NpZI9fArQlaWwttVywOczUTe3NWIq+BU6+6KGFEDNO+6VM5Y6CGDqZ/1wDpgh32MubNE+X2ozlH0n0s2Qxqzc=;
Content-Disposition: inline
In-Reply-To: <20170114055449.11044-9-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, jsvana-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Jan 14, 2017 at 12:54:48AM -0500, Tejun Heo wrote:
> With kmem cgroup support enabled, kmem_caches can be created and
> destroyed frequently and a great number of near empty kmem_caches can
> accumulate if there are a lot of transient cgroups and the system is
> not under memory pressure.  When memory reclaim starts under such
> conditions, it can lead to consecutive deactivation and destruction of
> many kmem_caches, easily hundreds of thousands on moderately large
> systems, exposing scalability issues in the current slab management
> code.  This is one of the patches to address the issue.
> 
> slub uses synchronize_sched() to deactivate a memcg cache.
> synchronize_sched() is an expensive and slow operation and doesn't
> scale when a huge number of caches are destroyed back-to-back.  While
> there used to be a simple batching mechanism, the batching was too
> restricted to be helpful.
> 
> This patch implements slab_deactivate_memcg_cache_rcu_sched() which
> slub can use to schedule sched RCU callback instead of performing
> synchronize_sched() synchronously while holding cgroup_mutex.  While
> this adds online cpus, mems and slab_mutex operations, operating on
> these locks back-to-back from the same kworker, which is what's gonna
> happen when there are many to deactivate, isn't expensive at all and
> this gets rid of the scalability problem completely.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Jay Vana <jsvana-b10kYP2dOMg@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> Cc: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

I don't think there's much point in having the infrastructure for this
in slab_common.c, as only SLUB needs it, but it isn't a show stopper.

Acked-by: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
