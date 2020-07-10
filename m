From: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Memcg stat for available memory
Date: Fri, 10 Jul 2020 14:04:57 -0700
Message-ID: <CAHbLzkoCNt7GPrwN1uPEvd==-Lz9-j6-2RS0CCL0s2e-M_omiw@mail.gmail.com>
References: <alpine.DEB.2.22.394.2006281445210.855265@chino.kir.corp.google.com>
 <CALvZod5Zv33oNLxS_8TyGV_QT4CsBjiEuocxpt2+U-XDMaFDPw@mail.gmail.com>
 <20200703081538.GO18446@dhcp22.suse.cz> <alpine.DEB.2.23.453.2007071210410.396729@chino.kir.corp.google.com>
 <alpine.DEB.2.23.453.2007101223470.1178541@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=knKCGO/TFZKmvezoCtPFxOWQQYS0S9SrfSJaD988IlQ=;
        b=ZwAlQGHv/53vyRlAA/pgP4ejQrYZEO9WBuZ97orWg9JVqECbBB1qAb9fzz1MXWBJLq
         xiYBseSkAnoLcPgAekoTjxZ+YTpFLZZqIgwAXEylYIDb+8OZRR/EKzVtx8oRlFH1aLiW
         6mr119vYLxGfTQVhJuQb7L6H9QyC9kaeTBf+DByR6WV7dCexpTqdjTDQkjJlPQwpTry+
         g28Ey5ba98fxDvcHP11mUbk2NCs4buS6+rP6MMV0EfczuazJATO04b0EHE3SmUcindIR
         nW3eUGt5re+JD3ug4x4fEKJsWZuZdhQo3fZAwK2h9TMg6pBJV3ZXKk4CTeh51GhKRPG4
         GxyA==
In-Reply-To: <alpine.DEB.2.23.453.2007101223470.1178541-X6Q0R45D7oAcqpCFd4KODRPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Yang Shi <yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Jul 10, 2020 at 12:49 PM David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, 7 Jul 2020, David Rientjes wrote:
>
> > Another use case would be motivated by exactly the MemAvailable use case:
> > when bound to a memcg hierarchy, how much memory is available without
> > substantial swap or risk of oom for starting a new process or service?
> > This would not trigger any memory.low or PSI notification but is a
> > heuristic that can be used to determine what can and cannot be started
> > without incurring substantial memory reclaim.
> >
> > I'm indifferent to whether this would be a "reclaimable" or "available"
> > metric, with a slight preference toward making it as similar in
> > calculation to MemAvailable as possible, so I think the question is
> > whether this is something the user should be deriving themselves based on
> > memcg stats that are exported or whether we should solidify this based on
> > how the kernel handles reclaim as a metric that will carry over across
> > kernel vesions?
> >
>
> To try to get more discussion on the subject, consider a malloc
> implementation, like tcmalloc, that does MADV_DONTNEED to free memory back
> to the system and how this freed memory is then described to userspace
> depending on the kernel implementation.
>
>  [ For the sake of this discussion, consider we have precise memcg stats
>    available to us although the actual implementation allows for some
>    variance (MEMCG_CHARGE_BATCH). ]
>
> With a 64MB heap backed by thp on x86, for example, the vma starts with an
> rss of 64MB, all of which is anon and backed by hugepages.  Imagine some
> aggressive MADV_DONTNEED freeing that ends up with only a single 4KB page
> mapped in each 2MB aligned range.  The rss is now 32 * 4KB = 128KB.
>
> Before freeing, anon, anon_thp, and active_anon in memory.stat would all
> be the same for this vma (64MB).  64MB would also be charged to
> memory.current.  That's all working as intended and to the expectation of
> userspace.
>
> After freeing, however, we have the kernel implementation specific detail
> of how huge pmd splitting is handled (rss) in comparison to the underlying
> split of the compound page (deferred split queue).  The huge pmd is always
> split synchronously after MADV_DONTNEED so, as mentioned, the rss is 128KB
> for this vma and none of it is backed by thp.
>
> What is charged to the memcg (memory.current) and what is on active_anon
> is unchanged, however, because the underlying compound pages are still
> charged to the memcg.  The amount of anon and anon_thp are decreased
> in compliance with the splitting of the page tables, however.
>
> So after freeing, for this vma: anon = 128KB, anon_thp = 0,
> active_anon = 64MB, memory.current = 64MB.
>
> In this case, because of the deferred split queue, which is a kernel
> implementation detail, userspace may be unclear on what is actually
> reclaimable -- and this memory is reclaimable under memory pressure.  For
> the motivation of MemAvailable (what amount of memory is available for
> starting new work), userspace *could* determine this through the
> aforementioned active_anon - anon (or some combination of
> memory.current - anon - file - slab), but I think it's a fair point that
> userspace's view of reclaimable memory as the kernel implementation
> changes is something that can and should remain consistent between
> versions.
>
> Otherwise, an earlier implementation before deferred split queues could
> have safely assumed that active_anon was unreclaimable unless swap were
> enabled.  It doesn't have the foresight based on future kernel
> implementation detail to reconcile what the amount of reclaimable memory
> actually is.
>
> Same discussion could happen for lazy free memory which is anon but now
> appears on the file lru stats and not the anon lru stats: it's easily
> reclaimable under memory pressure but you need to reconcile the difference
> between the anon metric and what is revealed in the anon lru stats.
>
> That gave way to my original thought of a si_mem_available()-like
> calculation ("avail") by doing
>
>         free = memory.high - memory.current

I'm wondering what if high or max is set to max limit. Don't you end
up seeing a super large memavail?

>         lazyfree = file - (active_file + inactive_file)

Isn't it (active_file + inactive_file) - file ? It looks MADV_FREE
just updates inactive lru size.

>         deferred = active_anon - anon
>
>         avail = free + lazyfree + deferred +
>                 (active_file + inactive_file + slab_reclaimable) / 2
>
> And we have the ability to change this formula based on kernel
> implementation details as they evolve.  Idea is to provide a consistent
> field that userspace can use to determine the rough amount of reclaimable
> memory in a MemAvailable-like way.
>
