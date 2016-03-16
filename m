From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: reclaim and OOM kill when shrinking
 memory.max below usage
Date: Tue, 15 Mar 2016 22:18:48 -0700
Message-ID: <20160316051848.GA11006@cmpxchg.org>
References: <1457643015-8828-2-git-send-email-hannes@cmpxchg.org>
 <20160311081825.GC27701@dhcp22.suse.cz>
 <20160311091931.GK1946@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160311091931.GK1946@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Mar 11, 2016 at 12:19:31PM +0300, Vladimir Davydov wrote:
> On Fri, Mar 11, 2016 at 09:18:25AM +0100, Michal Hocko wrote:
> > On Thu 10-03-16 15:50:14, Johannes Weiner wrote:
> ...
> > > @@ -5037,9 +5040,36 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> > >  	if (err)
> > >  		return err;
> > >  
> > > -	err = mem_cgroup_resize_limit(memcg, max);
> > > -	if (err)
> > > -		return err;
> > > +	xchg(&memcg->memory.limit, max);
> > > +
> > > +	for (;;) {
> > > +		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > > +
> > > +		if (nr_pages <= max)
> > > +			break;
> > > +
> > > +		if (signal_pending(current)) {
> > 
> > Didn't you want fatal_signal_pending here? At least the changelog
> > suggests that.
> 
> I suppose the user might want to interrupt the write by hitting CTRL-C.

Yeah. This is the same thing we do for the current limit setting loop.

> Come to think of it, shouldn't we restore the old limit and return EBUSY
> if we failed to reclaim enough memory?

I suspect it's very rare that it would fail. But even in that case
it's probably better to at least not allow new charges past what the
user requested, even if we can't push the level back far enough.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
