From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [External] Re: [PATCH 3/4] mm: memcontrol: bail out early when
 id is zero
Date: Mon, 15 Feb 2021 11:27:47 +0100
Message-ID: <YCpMo6gLFyqANsgd@dhcp22.suse.cz>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-3-songmuchun@bytedance.com>
 <YCpBUm2N4Bqm5PM5@dhcp22.suse.cz>
 <CAMZfGtVkh-DeYLLo8Nn7kHMCq055RSvL03eON1iqmhydYiQ-iQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613384868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=73NkWy0SYucsJms5v/JqP31gNuHokmiIPgdC8knJweg=;
        b=Tmnax6sJaIBzZXp3R9sNYEAdnpn1Ugf0Kem4uhGfk88hDPKs3PUvyOkp27ScBspmABWtSQ
        x1mqyWFbV/M8ApNz3GFqshMqfOREiaOw22s46pasXI8stgyvG/yWdbk5dqb+Zpje2rMnM/
        1s+WpacNOOfge1Mf709dhpF/q0ixbAE=
Content-Disposition: inline
In-Reply-To: <CAMZfGtVkh-DeYLLo8Nn7kHMCq055RSvL03eON1iqmhydYiQ-iQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon 15-02-21 18:09:44, Muchun Song wrote:
> On Mon, Feb 15, 2021 at 5:39 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> > On Sat 13-02-21 01:01:58, Muchun Song wrote:
> > > The memcg ID cannot be zero, but we can pass zero to mem_cgroup_from_id,
> > > so idr_find() is pointless and wastes CPU cycles.
> >
> > Is this possible at all to happen? If not why should we add a test for
> > _all_ invocations?
> 
> Yeah, this indeed can happen. If we allocate a new swap cache page
> and charge it via mem_cgroup_charge, then the page will uncharge
> the swap counter via mem_cgroup_uncharge_swap. When the swap
> entry is indeed freed, we will call mem_cgroup_uncharge_swap again,
> In this routine, we can pass zero to mem_cgroup_from_id. Right?

If the above claim is correct, which I would need to double check then
it should have been part of the changelog! Please think of your poor
reviewers and the time they have to invest into the review.

I would also like to see your waste of CPU cycles argument to be backed
by something. Are we talking about cycles due to an additional function
call? Is this really something we should even care about?

> > >
> > > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > ---
> > >  mm/memcontrol.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index a3f26522765a..68ed4b297c13 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -5173,6 +5173,9 @@ static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
> > >  struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> > >  {
> > >       WARN_ON_ONCE(!rcu_read_lock_held());
> > > +     /* The memcg ID cannot be zero. */
> > > +     if (id == 0)
> > > +             return NULL;
> > >       return idr_find(&mem_cgroup_idr, id);
> > >  }
> > >
> > > --
> > > 2.11.0
> >
> > --
> > Michal Hocko
> > SUSE Labs

-- 
Michal Hocko
SUSE Labs
