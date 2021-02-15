From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH 3/4] mm: memcontrol: bail out early when id
 is zero
Date: Mon, 15 Feb 2021 18:09:44 +0800
Message-ID: <CAMZfGtVkh-DeYLLo8Nn7kHMCq055RSvL03eON1iqmhydYiQ-iQ@mail.gmail.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-3-songmuchun@bytedance.com> <YCpBUm2N4Bqm5PM5@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uUkfBcazTUCSySsbiIpdf7O4sDkmamjhiSz7LSXU/q4=;
        b=H1TVCYlZbW83imFghMNQrgZVHaopx3G7upqnpaCf3o+DIiA7AB2ZPsVxte6UcaFTcX
         trlyNHKP2lqVPJhwEVc3NJADj9CHjpL1Xsch5BrecHXGTg8DGaWMACtBHW/D5d1h/ab3
         hwkpAA34c7CyoHgsja4N8BYXtgbS09kr+Nc8tDkomKLEaxh72pl/5HKUbwf50m7wg6Ha
         sjnAGUX5OPvd86woy4ls62/I9TR7JnfTFAjB1ODQ1RlG8YFW6I6rSMiumlVg+E9FXuIe
         7aVNrDtbVmpMzOQIQ6JMr6tCP/1m4VOC0eP9+AK/GzDTOHk52YNLBFYCEmXR4L5cFGoh
         rTlA==
In-Reply-To: <YCpBUm2N4Bqm5PM5-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Feb 15, 2021 at 5:39 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Sat 13-02-21 01:01:58, Muchun Song wrote:
> > The memcg ID cannot be zero, but we can pass zero to mem_cgroup_from_id,
> > so idr_find() is pointless and wastes CPU cycles.
>
> Is this possible at all to happen? If not why should we add a test for
> _all_ invocations?

Yeah, this indeed can happen. If we allocate a new swap cache page
and charge it via mem_cgroup_charge, then the page will uncharge
the swap counter via mem_cgroup_uncharge_swap. When the swap
entry is indeed freed, we will call mem_cgroup_uncharge_swap again,
In this routine, we can pass zero to mem_cgroup_from_id. Right?


>
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index a3f26522765a..68ed4b297c13 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -5173,6 +5173,9 @@ static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
> >  struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> >  {
> >       WARN_ON_ONCE(!rcu_read_lock_held());
> > +     /* The memcg ID cannot be zero. */
> > +     if (id == 0)
> > +             return NULL;
> >       return idr_find(&mem_cgroup_idr, id);
> >  }
> >
> > --
> > 2.11.0
>
> --
> Michal Hocko
> SUSE Labs
