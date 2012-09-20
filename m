From: JoonSoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 06/13] memcg: kmem controller infrastructure
Date: Fri, 21 Sep 2012 01:05:47 +0900
Message-ID: <CAAmzW4ONnc7n3kZbYnE6n2Cg0ZyPXW0QU2NMr0uRkyTxnGpNqQ@mail.gmail.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
	<1347977050-29476-7-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=C3cPZwqXAscM3qmauCiQSIDJrHkePeinPKBiekRu+zE=;
        b=qVcMfMmqWjsUzw9TNRC6PSukFtAY5X2fyYaZMW6CHxvVSGKjUneJivviEZQNgoLXU6
         nO+c2ZEfdfOcWJ/1t9zswTu2YAHxd3svORH23Ssjov/qZaOOib4QV4VeABLR8j4Fx+b+
         PIUDWA/Fy9s6S1kAOFdSx0xtYLcflnh/QdqAmLvMjS1y+9l9kWSYc0g0iVBIk9zss24u
         5aEVyUz/iOzLH71NZsfxpegzOXq9+9Y8hWJf2Ru6K0+n20QTmdcb6beOa6KgZUJZCuen
         ivVNXvcv4H66UBIl7Q+CTFVmsuIUGatEVOFPdNH4BBDM5rM3z2mj5Hh4NpS4Wcn5Z84X
         2MyA==
In-Reply-To: <1347977050-29476-7-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hi, Glauber.

2012/9/18 Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>:
> +/*
> + * We need to verify if the allocation against current->mm->owner's memcg is
> + * possible for the given order. But the page is not allocated yet, so we'll
> + * need a further commit step to do the final arrangements.
> + *
> + * It is possible for the task to switch cgroups in this mean time, so at
> + * commit time, we can't rely on task conversion any longer.  We'll then use
> + * the handle argument to return to the caller which cgroup we should commit
> + * against. We could also return the memcg directly and avoid the pointer
> + * passing, but a boolean return value gives better semantics considering
> + * the compiled-out case as well.
> + *
> + * Returning true means the allocation is possible.
> + */
> +bool
> +__memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **_memcg, int order)
> +{
> +       struct mem_cgroup *memcg;
> +       bool ret;
> +       struct task_struct *p;
> +
> +       *_memcg = NULL;
> +       rcu_read_lock();
> +       p = rcu_dereference(current->mm->owner);
> +       memcg = mem_cgroup_from_task(p);
> +       rcu_read_unlock();
> +
> +       if (!memcg_can_account_kmem(memcg))
> +               return true;
> +
> +       mem_cgroup_get(memcg);
> +
> +       ret = memcg_charge_kmem(memcg, gfp, PAGE_SIZE << order) == 0;
> +       if (ret)
> +               *_memcg = memcg;
> +       else
> +               mem_cgroup_put(memcg);
> +
> +       return ret;
> +}

"*_memcg = memcg" should be executed when "memcg_charge_kmem" is success.
"memcg_charge_kmem" return 0 if success in charging.
Therefore, I think this code is wrong.
If I am right, it is a serious bug that affect behavior of all the patchset.

> +void __memcg_kmem_commit_charge(struct page *page, struct mem_cgroup *memcg,
> +                             int order)
> +{
> +       struct page_cgroup *pc;
> +
> +       WARN_ON(mem_cgroup_is_root(memcg));
> +
> +       /* The page allocation failed. Revert */
> +       if (!page) {
> +               memcg_uncharge_kmem(memcg, PAGE_SIZE << order);
> +               return;
> +       }

In case of "!page ", mem_cgroup_put(memcg) is needed,
because we already call "mem_cgroup_get(memcg)" in
__memcg_kmem_newpage_charge().
I know that mem_cgroup_put()/get() will be removed in later patch, but
it is important that every patch works fine.

Thanks.
