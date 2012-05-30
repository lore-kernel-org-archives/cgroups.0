From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 16/28] memcg: kmem controller charge/uncharge
 infrastructure
Date: Wed, 30 May 2012 15:04:18 +0200
Message-ID: <20120530130416.GD25094@somewhere.redhat.com>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com>
 <1337951028-3427-17-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Wz2N9wn2GMECjvsXMBephyWIrpb/Qan6RurERtNkjJg=;
        b=SJyc7r4i59VwXs9O7YYON4X5oRImyeIPq/xElZdJKg4tZWIJ6OOi68bCbZsx/pe56S
         0qodlQocsQ6suE4Rp57GCt9/2rN0xmTOAH1HGAJ80P4Ookbq0qBk/IkOv0+H96Qmb0Ay
         auYYA39giquZmPSZp1YK+MdhBUd/9aeSKrAn763NqtlahlIPBp3aGQA/T0u1G47ELghk
         UVTQp4HoeDFSIaoJhVKZmEE7mFmA4HhiaBMlvKqBR77roNV/eGGCwAQ4IZC59IQiWal0
         7Rzfys88A2YsUg2+E01rwDcd93Lb1y3gKPlZ7ADBAKWdwEWYXfygoorQkzcuiJ7G+jTb
         t5sQ==
Content-Disposition: inline
In-Reply-To: <1337951028-3427-17-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri, May 25, 2012 at 05:03:36PM +0400, Glauber Costa wrote:
> +struct kmem_cache *__mem_cgroup_get_kmem_cache(struct kmem_cache *cachep,
> +					     gfp_t gfp)
> +{
> +	struct mem_cgroup *memcg;
> +	int idx;
> +	struct task_struct *p;
> +
> +	gfp |=  cachep->allocflags;
> +
> +	if (cachep->memcg_params.memcg)
> +		return cachep;
> +
> +	idx = cachep->memcg_params.id;
> +	VM_BUG_ON(idx == -1);
> +
> +	p = rcu_dereference(current->mm->owner);
> +	memcg = mem_cgroup_from_task(p);
> +
> +	if (!mem_cgroup_kmem_enabled(memcg))
> +		return cachep;
> +
> +	if (memcg->slabs[idx] == NULL) {
> +		memcg_create_cache_enqueue(memcg, cachep);
> +		return cachep;
> +	}
> +
> +	return memcg->slabs[idx];
> +}
> +EXPORT_SYMBOL(__mem_cgroup_get_kmem_cache);
> +
> +bool __mem_cgroup_new_kmem_page(struct page *page, gfp_t gfp)
> +{
> +	struct mem_cgroup *memcg;
> +	struct page_cgroup *pc;
> +	bool ret = true;
> +	size_t size;
> +	struct task_struct *p;
> +
> +	if (!current->mm || in_interrupt())
> +		return true;
> +
> +	rcu_read_lock();
> +	p = rcu_dereference(current->mm->owner);
> +	memcg = mem_cgroup_from_task(p);
> +
> +	if (!mem_cgroup_kmem_enabled(memcg))
> +		goto out;

Do you think it's possible that this memcg can be destroyed (like ss->destroy())
concurrently?

Probably not because there is a synchronize_rcu() in cgroup_diput() so as long
as we are in rcu_read_lock() we are fine.

OTOH current->mm->owner can exit() right after we fetched its memcg and thus the css_set
can be freed concurrently? And then the cgroup itself after we call rcu_read_unlock()
due to cgroup_diput().
And yet we are doing the mem_cgroup_get() below unconditionally assuming it's
always fine to get a reference to it.

May be I'm missing something?


> +	mem_cgroup_get(memcg);
> +
> +	size = (1 << compound_order(page)) << PAGE_SHIFT;
> +
> +	ret = memcg_charge_kmem(memcg, gfp, size) == 0;
> +	if (!ret) {
> +		mem_cgroup_put(memcg);
> +		goto out;
> +	}
> +
> +	pc = lookup_page_cgroup(page);
> +	lock_page_cgroup(pc);
> +	pc->mem_cgroup = memcg;
> +	SetPageCgroupUsed(pc);
> +	unlock_page_cgroup(pc);
> +
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +EXPORT_SYMBOL(__mem_cgroup_new_kmem_page);
