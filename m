From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 17/23] kmem controller charge/uncharge infrastructure
Date: Tue, 24 Apr 2012 16:22:34 +0200
Message-ID: <20120424142232.GC8626@somewhere>
References: <1334959051-18203-1-git-send-email-glommer@parallels.com>
 <1335138820-26590-6-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.00.1204231522320.13535@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=PE4Msp8n/EH83MgFjmmyymU6Ch5sc/NtHvzYPc5rjYE=;
        b=C683F3kon1fonwdVEmY1aDcyc4qy5vmiNPg5isovR/Z12i4kVtffzWhtf+YmWgFORA
         +HsAmFstQYgQuUJjO05pNIQiLypvMPR0s/sVgUH3HvuoJxGDrNFdPZ6NyU+zzV8sDB8A
         amZOI/J23qroU3rxa22dsm//cKdO2AVvGQviGplw3Qp2pOmMMb9olnU3y7CD7zuhKH8c
         fMtiHWNh/cYCqBao8PQfalayPHJmv4B1c8nGgkgf/K6a5PN19fuhQx2HM6YVDC2iOe+g
         UPJMl7Ddfh4psq9Eim1jFI2eD7nhGaUqMIMbAbr4zCWlvloW4MPZVsYR3WDcBCkzJDMp
         Cobw==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1204231522320.13535-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Mon, Apr 23, 2012 at 03:25:59PM -0700, David Rientjes wrote:
> On Sun, 22 Apr 2012, Glauber Costa wrote:
> 
> > +/*
> > + * Return the kmem_cache we're supposed to use for a slab allocation.
> > + * If we are in interrupt context or otherwise have an allocation that
> > + * can't fail, we return the original cache.
> > + * Otherwise, we will try to use the current memcg's version of the cache.
> > + *
> > + * If the cache does not exist yet, if we are the first user of it,
> > + * we either create it immediately, if possible, or create it asynchronously
> > + * in a workqueue.
> > + * In the latter case, we will let the current allocation go through with
> > + * the original cache.
> > + *
> > + * This function returns with rcu_read_lock() held.
> > + */
> > +struct kmem_cache *__mem_cgroup_get_kmem_cache(struct kmem_cache *cachep,
> > +					     gfp_t gfp)
> > +{
> > +	struct mem_cgroup *memcg;
> > +	int idx;
> > +
> > +	gfp |=  cachep->allocflags;
> > +
> > +	if ((current->mm == NULL))
> > +		return cachep;
> > +
> > +	if (cachep->memcg_params.memcg)
> > +		return cachep;
> > +
> > +	idx = cachep->memcg_params.id;
> > +	VM_BUG_ON(idx == -1);
> > +
> > +	memcg = mem_cgroup_from_task(current);
> > +	if (!mem_cgroup_kmem_enabled(memcg))
> > +		return cachep;
> > +
> > +	if (rcu_access_pointer(memcg->slabs[idx]) == NULL) {
> > +		memcg_create_cache_enqueue(memcg, cachep);
> > +		return cachep;
> > +	}
> > +
> > +	return rcu_dereference(memcg->slabs[idx]);
> > +}
> > +EXPORT_SYMBOL(__mem_cgroup_get_kmem_cache);
> > +
> > +void mem_cgroup_remove_child_kmem_cache(struct kmem_cache *cachep, int id)
> > +{
> > +	rcu_assign_pointer(cachep->memcg_params.memcg->slabs[id], NULL);
> > +}
> > +
> > +bool __mem_cgroup_charge_kmem(gfp_t gfp, size_t size)
> > +{
> > +	struct mem_cgroup *memcg;
> > +	bool ret = true;
> > +
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_task(current);
> 
> This seems horribly inconsistent with memcg charging of user memory since 
> it charges to p->mm->owner and you're charging to p.  So a thread attached 
> to a memcg can charge user memory to one memcg while charging slab to 
> another memcg?

Charging to the thread rather than the process seem to me the right behaviour:
you can have two threads of a same process attached to different cgroups.

Perhaps it is the user memory memcg that needs to be fixed?

> 
> > +
> > +	if (!mem_cgroup_kmem_enabled(memcg))
> > +		goto out;
> > +
> > +	mem_cgroup_get(memcg);
> > +	ret = memcg_charge_kmem(memcg, gfp, size) == 0;
> > +	if (ret)
> > +		mem_cgroup_put(memcg);
> > +out:
> > +	rcu_read_unlock();
> > +	return ret;
> > +}
> > +EXPORT_SYMBOL(__mem_cgroup_charge_kmem);
> > +
> > +void __mem_cgroup_uncharge_kmem(size_t size)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_task(current);
> > +
> > +	if (!mem_cgroup_kmem_enabled(memcg))
> > +		goto out;
> > +
> > +	mem_cgroup_put(memcg);
> > +	memcg_uncharge_kmem(memcg, size);
> > +out:
> > +	rcu_read_unlock();
> > +}
> > +EXPORT_SYMBOL(__mem_cgroup_uncharge_kmem);
