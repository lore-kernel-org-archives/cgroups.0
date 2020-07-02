From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: Memcg stat for available memory
Date: Thu, 2 Jul 2020 08:22:10 -0700
Message-ID: <CALvZod5Zv33oNLxS_8TyGV_QT4CsBjiEuocxpt2+U-XDMaFDPw@mail.gmail.com>
References: <alpine.DEB.2.22.394.2006281445210.855265@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uibEynu9caySlMhz/bcWJ3z7yd2MwyAMeTu6m4gB4zc=;
        b=RK3GXi1aY7MEN+2tdQDYtYDkP2NKLLfuyONsx/qMFu5vMGiUeJ/EgWLsCvzj7eHo71
         qCetpDEr0Kc60UJaafyl8JNrJP/G/rDmX+Z1H3aVCLacD74uEbKgOZIf9Gq3JTWFgrsk
         DSgPufYXy45QK2vdrFiD6QUUydkIBc9FZ86OULQeiIi9gdQvYrfqsZ4ZhiMAscR/Symi
         7vNydxRvLI5UfDomaSdR8V0MpzjtJ0R8Oz8IVogo0jweNskHD30tPIZR7jmxzU+KlJAk
         /SdLdHG2uzOLb16MATHJgbD8P/e791l3j9AZ7yHzuAJxWTWU87mwYDDSFPqLZOsUe8kU
         hb5Q==
In-Reply-To: <alpine.DEB.2.22.394.2006281445210.855265-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

(Adding more people who might be interested in this)


On Sun, Jun 28, 2020 at 3:15 PM David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Hi everybody,
>
> I'd like to discuss the feasibility of a stat similar to
> si_mem_available() but at memcg scope which would specify how much memory
> can be charged without I/O.
>
> The si_mem_available() stat is based on heuristics so this does not
> provide an exact quantity that is actually available at any given time,
> but can otherwise provide userspace with some guidance on the amount of
> reclaimable memory.  See the description in
> Documentation/filesystems/proc.rst and its implementation.
>
>  [ Naturally, userspace would need to understand both the amount of memory
>    that is available for allocation and for charging, separately, on an
>    overcommitted system.  I assume this is trivial.  (Why don't we provide
>    MemAvailable in per-node meminfo?) ]
>
> For such a stat at memcg scope, we can ignore totalreserves and
> watermarks.  We already have ~precise (modulo MEMCG_CHARGE_BATCH) data for
> both file pages and slab_reclaimable.
>
> We can infer lazily free memory by doing
>
>         file - (active_file + inactive_file)
>
> (This is necessary because lazy free memory is anon but on the inactive
>  file lru and we can't infer lazy freeable memory through pglazyfree -
>  pglazyfreed, they are event counters.)
>
> We can also infer the number of underlying compound pages that are on
> deferred split queues but have yet to be split with active_anon - anon (or
> is this a bug? :)
>
> So it *seems* like userspace can make a si_mem_available()-like
> calculation ("avail") by doing
>
>         free = memory.high - memory.current
>         lazyfree = file - (active_file + inactive_file)
>         deferred = active_anon - anon
>
>         avail = free + lazyfree + deferred +
>                 (active_file + inactive_file + slab_reclaimable) / 2
>
> For userspace interested in knowing how much memory it can charge without
> incurring I/O (and assuming it has knowledge of available memory on an
> overcommitted system), it seems like:
>
>  (a) it can derive the above avail amount that is at least similar to
>      MemAvailable,
>
>  (b) it can assume that all reclaim is considered equal so anything more
>      than memory.high - memory.current is disruptive enough that it's a
>      better heuristic than the above, or
>
>  (c) the kernel provide an "avail" stat in memory.stat based on the above
>      and can evolve as the kernel implementation changes (how lazy free
>      memory impacts anon vs file lru stats, how deferred split memory is
>      handled, any future extensions for "easily reclaimable memory") that
>      userspace can count on to the same degree it can count on
>      MemAvailable.
>
> Any thoughts?


I think we need to answer two questions:

1) What's the use-case?
2) Why is user space calculating their MemAvailable themselves not good?

The use case I have in mind is the latency sensitive distributed
caching service which would prefer to reduce the amount of its caching
over the stalls incurred by hitting the limit. Such applications can
monitor their MemAvailable and adjust their caching footprint.

For the second, I think it is to hide the internal implementation
details of the kernel from the user space. The deferred split queues
is an internal detail and we don't want that exposed to the user.
Similarly how lazyfree is implemented (i.e. anon pages on file LRU)
should not be exposed to the users.

Shakeel
