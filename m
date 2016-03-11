From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH] mm: memcontrol: reclaim and OOM kill when shrinking
 memory.max below usage
Date: Fri, 11 Mar 2016 12:19:31 +0300
Message-ID: <20160311091931.GK1946@esperanza>
References: <1457643015-8828-2-git-send-email-hannes@cmpxchg.org>
 <20160311081825.GC27701@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160311081825.GC27701@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Mar 11, 2016 at 09:18:25AM +0100, Michal Hocko wrote:
> On Thu 10-03-16 15:50:14, Johannes Weiner wrote:
...
> > @@ -5037,9 +5040,36 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> >  	if (err)
> >  		return err;
> >  
> > -	err = mem_cgroup_resize_limit(memcg, max);
> > -	if (err)
> > -		return err;
> > +	xchg(&memcg->memory.limit, max);
> > +
> > +	for (;;) {
> > +		unsigned long nr_pages = page_counter_read(&memcg->memory);
> > +
> > +		if (nr_pages <= max)
> > +			break;
> > +
> > +		if (signal_pending(current)) {
> 
> Didn't you want fatal_signal_pending here? At least the changelog
> suggests that.

I suppose the user might want to interrupt the write by hitting CTRL-C.

Come to think of it, shouldn't we restore the old limit and return EBUSY
if we failed to reclaim enough memory?

> 
> > +			err = -EINTR;
> > +			break;
> > +		}

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
