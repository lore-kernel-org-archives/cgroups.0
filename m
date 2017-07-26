From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Cast mismatched enum types passed to
 memcg state and event functions
Date: Wed, 26 Jul 2017 15:03:32 -0700
Message-ID: <20170726150332.313e48837d97046924ddaa16@linux-foundation.org>
References: <20170726192356.18420-1-mka@chromium.org>
        <20170726142309.ac40faf5eb99568e6edb064c@linux-foundation.org>
        <20170726214914.GA84665@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170726214914.GA84665-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Doug Anderson <dianders-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Wed, 26 Jul 2017 14:49:14 -0700 Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:

> El Wed, Jul 26, 2017 at 02:23:09PM -0700 Andrew Morton ha dit:
> 
> > On Wed, 26 Jul 2017 12:23:56 -0700 Matthias Kaehlcke <mka-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> > 
> > > In multiple instances enum values of an incorrect type are passed to
> > > mod_memcg_state() and other memcg functions. Apparently this is
> > > intentional, however clang rightfully generates tons of warnings about
> > > the mismatched types. Cast the offending values to the type expected
> > > by the called function. The casts add noise, but this seems preferable
> > > over losing the typesafe interface or/and disabling the warning.
> > > 
> > > ...
> > >
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -576,7 +576,7 @@ static inline void __mod_lruvec_state(struct lruvec *lruvec,
> > >  	if (mem_cgroup_disabled())
> > >  		return;
> > >  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
> > > -	__mod_memcg_state(pn->memcg, idx, val);
> > > +	__mod_memcg_state(pn->memcg, (enum memcg_stat_item)idx, val);
> > >  	__this_cpu_add(pn->lruvec_stat->count[idx], val);
> > >  }
> > 
> > __mod_memcg_state()'s `idx' arg can be either enum memcg_stat_item or
> > enum memcg_stat_item.  I think it would be better to just admit to
> > ourselves that __mod_memcg_state() is more general than it appears, and
> > change it to take `int idx'.  I assume that this implicit cast of an
> > enum to an int will not trigger a clang warning?
> 
> Sure, no warnings are raised for implicit casts from enum to
> int.
> 
> __mod_memcg_state() is not the only function though, all these
> functions are called with conflicting types:
> 
> memcg_page_state()
> __mod_memcg_state()
> mod_memcg_state()
> count_memcg_events()
> count_memcg_page_event()
> memcg_sum_events()
> 
> Should we change all of them to reveice an int instead of an enum?

I suspect so - the current implementation is denying reality and your
original proposal is a bit of a fudge.  But I'll await input from the
memcg peeps.
