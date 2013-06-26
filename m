From: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups
 statistics
Date: Wed, 26 Jun 2013 17:08:20 -0400
Message-ID: <20130626210820.GA17564@redhat.com>
References: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
 <20130626204540.GA4536@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130626204540.GA4536-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

On Wed, Jun 26, 2013 at 01:45:40PM -0700, Tejun Heo wrote:
> (cc'ing Vivek and Jens)
> 
> On Wed, Jun 26, 2013 at 12:26:10PM -0700, Anatol Pomozov wrote:
> > @@ -548,6 +548,9 @@ u64 __blkg_prfill_u64(struct seq_file *sf, struct blkg_policy_data *pd, u64 v)
> >  	if (!dname)
> >  		return 0;
> >  
> > +	if (!v)
> > +		return 0;
> > +
> 
> I don't think it'd be a good idea to filter out 0 by default from
> __blkg_prfill_u64().  It'd probably be a better idea to do the
> filtering from the users of __blkg_prfill_u64().  Would that be a lot
> more churn?
> 
> > @@ -571,19 +574,23 @@ u64 __blkg_prfill_rwstat(struct seq_file *sf, struct blkg_policy_data *pd,
> >  		[BLKG_RWSTAT_ASYNC]	= "Async",
> >  	};
> >  	const char *dname = blkg_dev_name(pd->blkg);
> > -	u64 v;
> > +	u64 total;
> >  	int i;
> >  
> >  	if (!dname)
> >  		return 0;
> >  
> > +	total = rwstat->cnt[BLKG_RWSTAT_READ] + rwstat->cnt[BLKG_RWSTAT_WRITE];
> > +	/* skip devices with no activity */
> > +	if (!total)
> > +		return 0;
> > +
> 
> Doing it from rwstat is fine as it's always printing "stats" and
> suppressing 0 stats by default should be fine, I think.  Can you
> please update the function comment accordingly tho?
> 
> Vivek, any objections?

I don't have an objection to not listing stats of devices which are
zero, but wondering why all the devices of system are showing in 
cgroup stat.

Don't we add a blkg to a blkcg only if that cgroup did some IO to
that particular device. If yes, then only those devices should
show to which cgroup did some IO and that should be non-zero.

Is it because of hierarchical support where if a child does IO
to device, we will add an blkg instance to parent's cgroup? In
that case hierarchical stats will still be non-zero but group
local stat can be zero.

I think it makes sense to remove zero stats. Hierarchical stat
will anyway have that data.

Thanks
Vivek
