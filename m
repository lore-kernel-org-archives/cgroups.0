From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v3] mm: fix race between kmem_cache destroy, create and deactivate
Date: Sun, 10 Jun 2018 07:52:50 -0700
Message-ID: <CALvZod7OrDrq571An-GHeWFNvARWsS+fvX1-G9=nYzxgq2N3UQ@mail.gmail.com>
References: <20180530001204.183758-1-shakeelb@google.com> <20180609102027.5vkqucnzvh6nfdxu@esperanza>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oC2cacfKI/jQ1T1rWZ5MzJlK2AopP4vAVEDjBOXQ+xE=;
        b=czCqUysKIuhwZAfc9PEuKNdFMQ+uaCkdJBGKkkKIK7utpbtj6on78rjDc6clDIr0hj
         gITnMxKI0PBUVjaPIaodVQHjw6m+t99D0XR/nD8DvURlYH7Q+906s1L5vxzoNWIqBlmg
         CgEQSzDipM9i81gzgkNIvh1IIXdIFe5sbvKHtl0s626/lHEcZwiW8INVPTMIVEVauA3B
         AHYhPhKe4tJ3r5/UAuPE3CLe1RGnRS8p2FCBFskGj+IVZeMQw2VXlZOxpJDD/gmkrPq7
         cJWK+m43XnvGm135W7y3U80bUqX/GVHURpcIBtUHP9UwemRjEC6ewXq+TmnrK9VHHwFQ
         vojg==
In-Reply-To: <20180609102027.5vkqucnzvh6nfdxu@esperanza>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev@gmail.com>, paulmck@linux.vnet.ibm.com
Cc: Michal Hocko <mhocko@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, Jun 9, 2018 at 3:20 AM Vladimir Davydov <vdavydov.dev@gmail.com> wrote:
>
> On Tue, May 29, 2018 at 05:12:04PM -0700, Shakeel Butt wrote:
> > The memcg kmem cache creation and deactivation (SLUB only) is
> > asynchronous. If a root kmem cache is destroyed whose memcg cache is in
> > the process of creation or deactivation, the kernel may crash.
> >
> > Example of one such crash:
> >       general protection fault: 0000 [#1] SMP PTI
> >       CPU: 1 PID: 1721 Comm: kworker/14:1 Not tainted 4.17.0-smp
> >       ...
> >       Workqueue: memcg_kmem_cache kmemcg_deactivate_workfn
> >       RIP: 0010:has_cpu_slab
> >       ...
> >       Call Trace:
> >       ? on_each_cpu_cond
> >       __kmem_cache_shrink
> >       kmemcg_cache_deact_after_rcu
> >       kmemcg_deactivate_workfn
> >       process_one_work
> >       worker_thread
> >       kthread
> >       ret_from_fork+0x35/0x40
> >
> > To fix this race, on root kmem cache destruction, mark the cache as
> > dying and flush the workqueue used for memcg kmem cache creation and
> > deactivation.
>
> > @@ -845,6 +862,8 @@ void kmem_cache_destroy(struct kmem_cache *s)
> >       if (unlikely(!s))
> >               return;
> >
> > +     flush_memcg_workqueue(s);
> > +
>
> This should definitely help against async memcg_kmem_cache_create(),
> but I'm afraid it doesn't eliminate the race with async destruction,
> unfortunately, because the latter uses call_rcu_sched():
>
>   memcg_deactivate_kmem_caches
>    __kmem_cache_deactivate
>     slab_deactivate_memcg_cache_rcu_sched
>      call_rcu_sched
>                                             kmem_cache_destroy
>                                              shutdown_memcg_caches
>                                               shutdown_cache
>       memcg_deactivate_rcufn
>        <dereference destroyed cache>
>
> Can we somehow flush those pending rcu requests?

You are right and thanks for catching that. Now I am wondering if
synchronize_sched() just before flush_workqueue() should be enough.
Otherwise we might have to replace call_sched_rcu with
synchronize_sched() in kmemcg_deactivate_workfn which I would not
prefer as that would holdup the kmem_cache workqueue.

+Paul

Paul, we have a situation something similar to the following pseudo code.

CPU0:
lock(l)
if (!flag)
  call_rcu_sched(callback);
unlock(l)
------
CPU1:
lock(l)
flag = true
unlock(l)
synchronize_sched()
------

If CPU0 has called already called call_rchu_sched(callback) then later
if CPU1 calls synchronize_sched(). Is there any guarantee that on
return from synchronize_sched(), the rcu callback scheduled by CPU0
has already been executed?

thanks,
Shakeel
