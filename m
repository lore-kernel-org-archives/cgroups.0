From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/3] mm: memcg: remote memcg charging for kmem allocations
Date: Tue, 19 Jun 2018 16:31:18 -0700
Message-ID: <CALvZod7eq3WnMU8dzA+9CmbOuf-peaCyhLuMRW2n_VyOPqjZ7A@mail.gmail.com>
References: <20180619051327.149716-1-shakeelb@google.com> <20180619051327.149716-2-shakeelb@google.com>
 <20180619162429.GB27423@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KLUGix+u8YxaEilfclW80OJnWpbxSGKRxeUu0OHvIRY=;
        b=LPEt3Wm+H78tMEjCrA9SK1n5bsWI6kVikPAR+srvTd/psEn8EvN4jjIcY8vrz8RJfe
         7SncILq6mg4QUAX0Fk/SvT7YYFZQGZA1RbeoIqZgKJPGofiBSfb4dWNLsOPTxqej7y1h
         rKCIyGiSs/OkbrFSGPz7+Xo1N5NCQKeX/OnDlCpJQFdSUDG5ANNxZ1EcYezz2bOwq1qB
         tohdgyd9JY9I+Fxu8XVwRDXrnCzj72xQ3rm9h81eLbp9HrJ3sTlO0Rz7Kwgh0C1wU7Xo
         SusUoVCoNjPCA1n80zhKeJyiDLYEhkECWPj2R5xl3swbT6WyDe6azjJzKM8xxijWWxNv
         NoaQ==
In-Reply-To: <20180619162429.GB27423@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>

On Tue, Jun 19, 2018 at 9:22 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Mon, Jun 18, 2018 at 10:13:25PM -0700, Shakeel Butt wrote:
> > @@ -248,6 +248,30 @@ static inline void memalloc_noreclaim_restore(unsigned int flags)
> >       current->flags = (current->flags & ~PF_MEMALLOC) | flags;
> >  }
> >
> > +#ifdef CONFIG_MEMCG
> > +static inline struct mem_cgroup *memalloc_memcg_save(struct mem_cgroup *memcg)
> > +{
> > +     struct mem_cgroup *old_memcg = current->target_memcg;
> > +
> > +     current->target_memcg = memcg;
> > +     return old_memcg;
> > +}
> > +
> > +static inline void memalloc_memcg_restore(struct mem_cgroup *memcg)
> > +{
> > +     current->target_memcg = memcg;
> > +}
>
> The use_mm() and friends naming scheme would be better here:
> memalloc_use_memcg(), memalloc_unuse_memcg(), current->active_memcg
>

Ack. Though do you still think <linux/sched/mm.h> is the right place
for these functions?

> > @@ -375,6 +376,27 @@ static __always_inline void kfree_bulk(size_t size, void **p)
> >       kmem_cache_free_bulk(NULL, size, p);
> >  }
> >
> > +/*
> > + * Calling kmem_cache_alloc_memcg implicitly assumes that the caller wants
> > + * a __GFP_ACCOUNT allocation. However if memcg is NULL then
> > + * kmem_cache_alloc_memcg is same as kmem_cache_alloc.
> > + */
> > +static __always_inline void *kmem_cache_alloc_memcg(struct kmem_cache *cachep,
> > +                                                 gfp_t flags,
> > +                                                 struct mem_cgroup *memcg)
> > +{
> > +     struct mem_cgroup *old_memcg;
> > +     void *ptr;
> > +
> > +     if (!memcg)
> > +             return kmem_cache_alloc(cachep, flags);
> > +
> > +     old_memcg = memalloc_memcg_save(memcg);
> > +     ptr = kmem_cache_alloc(cachep, flags | __GFP_ACCOUNT);
> > +     memalloc_memcg_restore(old_memcg);
> > +     return ptr;
>
> I'm not a big fan of these functions as an interface because it
> implies that kmem_cache_alloc() et al wouldn't charge a memcg - but
> they do, just using current's memcg.
>
> It's also a lot of churn to duplicate all the various slab functions.
>
> Can you please inline the save/restore (or use/unuse) functions into
> the callsites? If you make them handle NULL as parameters, it merely
> adds two bracketing lines around the allocation call in the callsites,
> which I think would be better to understand - in particular with a
> comment on why we are charging *that* group instead of current's.
>

Ack.

> > +static __always_inline struct mem_cgroup *get_mem_cgroup(
> > +                             struct mem_cgroup *memcg, struct mm_struct *mm)
> > +{
> > +     if (unlikely(memcg)) {
> > +             rcu_read_lock();
> > +             if (css_tryget_online(&memcg->css)) {
> > +                     rcu_read_unlock();
> > +                     return memcg;
> > +             }
> > +             rcu_read_unlock();
> > +     }
> > +     return get_mem_cgroup_from_mm(mm);
> > +}
> > +
> >  /**
> >   * mem_cgroup_iter - iterate over memory cgroup hierarchy
> >   * @root: hierarchy root
> > @@ -2260,7 +2274,7 @@ struct kmem_cache *memcg_kmem_get_cache(struct kmem_cache *cachep)
> >       if (current->memcg_kmem_skip_account)
> >               return cachep;
> >
> > -     memcg = get_mem_cgroup_from_mm(current->mm);
> > +     memcg = get_mem_cgroup(current->target_memcg, current->mm);
>
> get_mem_cgroup_from_current(), which uses current->active_memcg if set
> and current->mm->memcg otherwise, would be a nicer abstraction IMO.

Ack.

thanks,
Shakeel
