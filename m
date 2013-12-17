From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Tue, 17 Dec 2013 11:25:17 +0100
Message-ID: <20131217102517.GA28991@dhcp22.suse.cz>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <20131216162042.GC26797@dhcp22.suse.cz>
 <alpine.LNX.2.00.1312161742540.2037@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1312161742540.2037-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 16-12-13 18:26:18, Hugh Dickins wrote:
> On Mon, 16 Dec 2013, Michal Hocko wrote:
> > On Mon 16-12-13 00:36:05, Hugh Dickins wrote:
[...]
> > > +/**
> > > + * swap_cgroup_reassign - assign all old entries to new (before old is freed).
> > > + * @old: id of emptied memcg whose entries are now to be reassigned
> > > + * @new: id of parent memcg to which those entries are to be assigned
> > > + *
> > > + * Returns number of entries reassigned, for debugging or for statistics.
> > > + */
> > > +long swap_cgroup_reassign(unsigned short old, unsigned short new)
> > > +{
> > > +	long reassigned = 0;
> > > +	int type;
> > > +
> > > +	for (type = 0; type < MAX_SWAPFILES; type++) {
> > > +		struct swap_cgroup_ctrl *ctrl = &swap_cgroup_ctrl[type];
> > > +		unsigned long idx;
> > > +
> > > +		for (idx = 0; idx < ACCESS_ONCE(ctrl->length); idx++) {
> > > +			struct swap_cgroup *sc, *scend;
> > > +
> > > +			spin_lock(&swap_cgroup_lock);
> > > +			if (idx >= ACCESS_ONCE(ctrl->length))
> > > +				goto unlock;
> > > +			sc = page_address(ctrl->map[idx]);
> > > +			for (scend = sc + SC_PER_PAGE; sc < scend; sc++) {
> > > +				if (sc->id != old)
> > > +					continue;
> > 
> > Is this safe? What prevents from race when id is set to old?
> 
> I am assuming that when this is called, we shall not be making any
> new charges to old (if you see what I mean :) - this is called after
> mem_cgroup_reparent_charges() (the main call - I've not yet wrapped
> my head around Hannes's later safety-net call; perhaps these patches
> would even make that one redundant - dunno).

I have to think about this some more. I was playing with an alternative
fix for this race and few trace points shown me that the races are quite
common.

Anyway, wouldn't be it easier to take the lock for a batch of sc's and
then release it followed by cond_resched? Doing 1024 of iterations
doesn't sound too bad to me (we would take the lock 2 times for 4k pages).

> Quite a lot is made simpler by the fact that we do not need to call
> this from mem_cgroup_force_empty(), with all the races that would
> entail: there was never any attempt to move these swap charges before,
> so it's a pleasure not to have to deal with that possibility now.
>
> > > +				spin_lock(&ctrl->lock);
> > > +				if (sc->id == old) {
> > 
> > Also it seems that compiler is free to optimize this test away, no?
> > You need ACCESS_ONCE here as well, I guess.
> 
> Oh dear, you're asking me to read again through memory-barriers.txt
> (Xmas 2013 edition), and come to a conclusion.  I think this pattern
> of test outside spinlock, spinlock, test again inside spinlock is
> used in very many places, without any ACCESS_ONCE.  I'll have to
> go and search through the precedents.
> 
> I've probably brought this upon myself with the ACCESS_ONCE(ctrl->length)
> a few lines above, which I added at a late stage to match the one above
> it; but now I'm arguing that's unnecessary.

Yeah, that triggered the red flag ;)

> One of the problems with ACCESS_ONCE is that one easily falls into
> a mistaken state in which it seems to be necessary everywhere;
> but that illusion must be resisted.
> 
> The spinlock should make it unnecessary, but I'll have to muse on
> semi-permeable membranes, osmosis, stuff like that.

OK, I have checked that and you are right. ACCESS_ONCE is not needed.
Compiler is not allowed to optimize across barrier() which is a part of
spin_lock. So this should be ok.
[...]
-- 
Michal Hocko
SUSE Labs
