From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: reclaim and OOM kill when shrinking
 memory.max below usage
Date: Wed, 16 Mar 2016 09:43:57 +0100
Message-ID: <20160316084357.GA21228@dhcp22.suse.cz>
References: <1457643015-8828-2-git-send-email-hannes@cmpxchg.org>
 <20160311081825.GC27701@dhcp22.suse.cz>
 <20160311091931.GK1946@esperanza>
 <20160316051848.GA11006@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160316051848.GA11006-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue 15-03-16 22:18:48, Johannes Weiner wrote:
> On Fri, Mar 11, 2016 at 12:19:31PM +0300, Vladimir Davydov wrote:
> > On Fri, Mar 11, 2016 at 09:18:25AM +0100, Michal Hocko wrote:
> > > On Thu 10-03-16 15:50:14, Johannes Weiner wrote:
> > ...
> > > > @@ -5037,9 +5040,36 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> > > >  	if (err)
> > > >  		return err;
> > > >  
> > > > -	err = mem_cgroup_resize_limit(memcg, max);
> > > > -	if (err)
> > > > -		return err;
> > > > +	xchg(&memcg->memory.limit, max);
> > > > +
> > > > +	for (;;) {
> > > > +		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > > > +
> > > > +		if (nr_pages <= max)
> > > > +			break;
> > > > +
> > > > +		if (signal_pending(current)) {
> > > 
> > > Didn't you want fatal_signal_pending here? At least the changelog
> > > suggests that.
> > 
> > I suppose the user might want to interrupt the write by hitting CTRL-C.
> 
> Yeah. This is the same thing we do for the current limit setting loop.

Yes we do but then the operation is canceled without any change. Now
re-reading the changelog I've realized I have misread the "we run out of
OOM victims and there's only unreclaimable memory left, or the task
writing to memory.max is killed." part and considered task writing... is
OOM killed.
 
> > Come to think of it, shouldn't we restore the old limit and return EBUSY
> > if we failed to reclaim enough memory?
> 
> I suspect it's very rare that it would fail. But even in that case
> it's probably better to at least not allow new charges past what the
> user requested, even if we can't push the level back far enough.

I guess you are right. This guarantee is indeed useful.
-- 
Michal Hocko
SUSE Labs
