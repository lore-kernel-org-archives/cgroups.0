From: Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: per-cgroup memory reclaim stats
Date: Wed, 17 May 2017 08:03:03 +1000
Message-ID: <CAKTCnz=vj9-C2-XPcijB=fZOVVdxvqZvLEA93xXtRZmF+y3-Lg@mail.gmail.com>
References: <1494530183-30808-1-git-send-email-guro@fb.com>
 <1494555922.21563.1.camel@gmail.com> <20170512164206.GA22367@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ZuDlqTlYzQRgN99uSg9bjuDwiQb5DGUPiKrSH7kjfvo=;
        b=fmCW9fkozM8MbUzbLhRz+XtBFqFESUcO4npnKcJZqiYENMhi2oG8vPSjHi5tGn0WWw
         /emCEE/OBH9Ovv7YrUTlkyv8fXyR2Z7QzUYTX5X5WjgPgfZlAw/f8+PqPGzatFq0f9MC
         gACQumnvBI1C30N2iq3eGBqyMIBk9O08yxdZJpcUrXOG57/QRXRxZY8TJ6HyrlTI2Emq
         04nP++S3xHpAX/nJJL1i1V43UkJVjHqav2yxU5ei4FpeXWQ22E1wdRdXuyZ5aGc294v3
         0lUN3xoicYyLxqYTMiFy54VQlE5BVCvhoKecA7hU2mRwhtflu9T4PA+pVv3luVoBLCdU
         UK1g==
In-Reply-To: <20170512164206.GA22367-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Sat, May 13, 2017 at 2:42 AM, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
> On Fri, May 12, 2017 at 12:25:22PM +1000, Balbir Singh wrote:
>> On Thu, 2017-05-11 at 20:16 +0100, Roman Gushchin wrote:
>> > The meaning of each value is the same as for global counters,
>> > available using /proc/vmstat.
>> >
>> > Also, for consistency, rename mem_cgroup_count_vm_event() to
>> > count_memcg_event_mm().
>> >
>>
>> I still prefer the mem_cgroup_count_vm_event() name, or memcg_count_vm_event(),
>> the namespace upfront makes it easier to parse where to look for the the
>> implementation and also grep. In any case the rename should be independent
>> patch, but I don't like the name you've proposed.
>
> The memory controller is no longer a tacked-on feature to the VM - the
> entire reclaim path is designed around cgroups at this point. The
> namespacing is just cumbersome and doesn't add add any value, IMO.
>
> This name is also more consistent with the stats interface, where we
> use nodes, zones, memcgs all equally to describe scopes/containers:
>
> inc_node_state(), inc_zone_state(), inc_memcg_state()
>

I don't have a very strong opinion, but I find memcg_* easier to parse
than inc_memcg_*
If memcg is going to be present everywhere we may consider abstracting
them inside
the main routines

>> > @@ -357,6 +357,17 @@ static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>> >  }
>> >  struct mem_cgroup *mem_cgroup_from_id(unsigned short id);
>> >
>> > +static inline struct mem_cgroup *lruvec_memcg(struct lruvec *lruvec)
>>
>> mem_cgroup_from_lruvec()?
>
> This name is consistent with other lruvec accessors such as
> lruvec_pgdat() and lruvec_lru_size() etc.
>

lruvec_ being the namespace, the same comment as above.

>> > @@ -1741,11 +1748,16 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
>> >
>> >     spin_lock_irq(&pgdat->lru_lock);
>> >
>> > -   if (global_reclaim(sc)) {
>> > -           if (current_is_kswapd())
>> > +   if (current_is_kswapd()) {
>> > +           if (global_reclaim(sc))
>> >                     __count_vm_events(PGSTEAL_KSWAPD, nr_reclaimed);
>> > -           else
>> > +           count_memcg_events(lruvec_memcg(lruvec), PGSTEAL_KSWAPD,
>> > +                              nr_reclaimed);
>>
>> Has the else gone missing? What happens if it's global_reclaim(), do
>> we still account the count in memcg?
>>
>> > +   } else {
>> > +           if (global_reclaim(sc))
>> >                     __count_vm_events(PGSTEAL_DIRECT, nr_reclaimed);
>> > +           count_memcg_events(lruvec_memcg(lruvec), PGSTEAL_DIRECT,
>> > +                              nr_reclaimed);
>>
>> It sounds like memcg accumlates both global and memcg reclaim driver
>> counts -- is this what we want?
>
> Yes.
>
> Consider a fully containerized system that is using only memory.low
> and thus exclusively global reclaim to enforce the partitioning, NOT
> artificial limits and limit reclaim. In this case, we still want to
> know how much reclaim activity each group is experiencing.

But its also confusing to see memcg.stat's value being greater
than the global value? At-least for me. For example PGSTEAL_DIRECT
inside a memcg > global value of PGSTEAL_DIRECT. Do we make
memcg.stat values sum of all impact on memcg or local to memcg?

Balbir Singh
